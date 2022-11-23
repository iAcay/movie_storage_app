describe CreateMovieService do
  describe '.call' do
    it 'creates movie' do
      movie_params = { name: "The Hateful Eight", release_year: "2015", 
                 budget: "44000000", imdb_score: "7.8", 
                 director_name: "Quentin Tarantino", 
                 actors_names: "Samuel L. Jackson,Kurt Russell", 
                 genres_names: "Western" }

      form = MovieForm.new(movie_params)  
      service = described_class.new(form)
      result = nil

      expect { result = service.call }.to change(Movie, :count).from(0).to(1) && 
                                          change(Director, :count).from(0).to(1) &&
                                          change(Actor, :count).from(0).to(2) &&
                                          change(Genre, :count).from(0).to(1)
      expect(result).to be true
      expect(service.errors).to be_blank
      expect(service.movie.name).to eq 'The Hateful Eight'
      expect(service.movie.release_year).to eq '2015'
      expect(service.movie.budget).to eq '44000000'
      expect(service.movie.imdb_score).to eq '7.8'
      expect(service.movie.director.name).to eq 'Quentin Tarantino'
      expect(service.movie.actors.first.name).to eq 'Samuel L. Jackson'
      expect(service.movie.actors.last.name).to eq 'Kurt Russell'
      expect(service.movie.genres.first.name).to eq 'Western'
    end

    it "returns false if movie's details are nil" do
      movie_params = { name: nil, release_year: "2015", 
                       budget: "44000000", imdb_score: "7.8", 
                       director_name: "Quentin Tarantino", 
                       actors_names: "Samuel L. Jackson,Kurt Russell", 
                       genres_names: "Western" }
      
      form = MovieForm.new(movie_params)  
      service = described_class.new(form)
      result = nil

      expect { result = service.call }.not_to change(Movie, :count)
      expect(result).to be false
      expect(service.errors).to be_present
    end

    it "returns false if movie's name is not unique" do
      create(:movie, name: 'The Hateful Eight')

      movie_params = { name: "The Hateful Eight", release_year: "2015", 
                       budget: "44000000", imdb_score: "7.8", 
                       director_name: "Quentin Tarantino", 
                       actors_names: "Samuel L. Jackson,Kurt Russell", 
                       genres_names: "Western" }

      form = MovieForm.new(movie_params)  
      service = described_class.new(form)
      result = nil

      expect { result = service.call }.not_to change(Movie, :count)
      expect(result).to be false
      expect(service.errors).to be_present
    end

    it "updates director's data after movie creation" do
      director = create(:director, name: 'Quentin Tarantino', movies_count: 0, total_budget_of_movies: 0)

      movie_params = { name: "The Hateful Eight", release_year: "2015", 
                       budget: "44000000", imdb_score: "7.8", 
                       director_name: "Quentin Tarantino", 
                       actors_names: "Samuel L. Jackson,Kurt Russell", 
                       genres_names: "Western" }

      form = MovieForm.new(movie_params)  
      service = described_class.new(form)
        
      expect { service.call && director.reload}.to change(director, :movies_count).from(0).to(1) &&
                                                   change(director, :total_budget_of_movies).from(0).to(44000000)
    end

    it 'sends newsletter email after creating a new movie' do
      create(:newsletter_email)
      
      movie_params = { name: "The Hateful Eight", release_year: "2015", 
                       budget: "44000000", imdb_score: "7.8", 
                       director_name: "Quentin Tarantino", 
                       actors_names: "Samuel L. Jackson,Kurt Russell", 
                       genres_names: "Western" }

      form = MovieForm.new(movie_params)  
      service = described_class.new(form)

      expect { service.call }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(ActionMailer::Base.deliveries.last.subject).to eq "New movie The Hateful Eight has been added!"
    end
  end
end
