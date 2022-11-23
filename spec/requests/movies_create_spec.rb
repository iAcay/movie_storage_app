require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Movie', type: :request do
  context 'creating new movie' do
    it 'sends newsletter email after creating a new movie' do
      create(:newsletter_email)
      
      params = { movie: { name: "The Hateful Eight", release_year: "2015", 
                          budget: "44000000", imdb_score: "7.8", 
                          director_name: "Quentin Tarantino", 
                          actors_names: "Samuel L. Jackson,Kurt Russell", 
                          genres_names: "Western" } }

      request = -> { post '/movies', params: params }
    
      expect { request.call }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(ActionMailer::Base.deliveries.last.subject).to eq "New movie The Hateful Eight has been added!"
    end

    it "updates director's data after creating a new movie" do
      director = create(:director, name: 'Quentin Tarantino', movies_count: 0, total_budget_of_movies: 10000000)
    
      params = { movie: { name: "The Hateful Eight", release_year: "2015", 
                          budget: "44000000", imdb_score: "7.8", 
                          director_name: "Quentin Tarantino", 
                          actors_names: "Samuel L. Jackson,Kurt Russell", 
                          genres_names: "Western" } }

      post '/movies', params: params
      
      expect { director.reload }. to change(director, :movies_count).from(0).to(1)
      expect(director.total_budget_of_movies).to eq 54000000
    end
  end
end
