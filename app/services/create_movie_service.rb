class CreateMovieService
  attr_reader :movie, :errors, :form

  def initialize(form)
    @form = form
    @errors = []
  end

  def call
    ActiveRecord::Base.transaction do
      validate_form
      initialize_new_movie
      add_movie_director
      add_movie_actors
      add_movie_genres
      save_movie
      update_movie_director_data
    end
    send_newsletter_email_about_new_movie # ultimately it should be sent with sidekiq
    true
  rescue ActiveModel::ValidationError, ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
    errors << e.message
    false
  end

  private

  attr_writer :movie

  def validate_form
    form.validate!
  end

  def initialize_new_movie
    self.movie = Movie.new(name: form.name, release_year: form.release_year, budget: form.budget, imdb_score: form.imdb_score)
  end

  def add_movie_director
    director = Director.find_or_create_by!(name: form.director_name)
    movie.director = director
  end

  def add_movie_actors
    actors_names = form.actors_names.split(',')
    actors_names.each do |actor_name|
      actor = Actor.find_or_create_by!(name: actor_name)
      movie.actors << actor unless movie.actors.include?(actor) 
    end
  end

  def add_movie_genres
    genres_names = form.genres_names.split(',')
    genres_names.each do |genre_name|
      genre = Genre.find_or_create_by!(name: genre_name)
      movie.genres << genre unless movie.genres.include?(genre) 
    end
  end

  def save_movie
    movie.save!
  end

  def update_movie_director_data
    director = movie.director
    director.movies_count = movie.director.movies.count
    director.total_budget_of_movies += movie.budget.to_i
    director.save!
  end

  def send_newsletter_email_about_new_movie
    NewsletterMailer.new_movie_email(movie).deliver_now
  end
end
