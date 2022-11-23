class MovieForm
  include ActiveModel::Model
  
  attr_accessor :name, :release_year, :budget, :imdb_score, :director_name, :actors_names, :genres_names

  validates :name, :release_year, :budget, :imdb_score, :director_name, :actors_names, :genres_names, presence: true
  validate  :uniqueness_of_movie_name
  validates :release_year, :budget, :imdb_score, numericality: { only_float: true }


  def initialize(params = {})
    @name = params[:name]
    @release_year = params[:release_year]
    @budget = params[:budget]
    @imdb_score = params[:imdb_score]
    @director_name = params[:director_name]
    @actors_names = params[:actors_names]
    @genres_names = params[:genres_names]
  end

  def attributes
    {
      name: name,
      release_year: release_year,
      budget: budget,
      imdb_score: imdb_score,
      director_name: director_name,
      actors_names: actors_names,
      genres_names: genres_names
    }
  end

  private

  def uniqueness_of_movie_name
    errors.add(:name, 'Movie with this name already exists') if Movie.find_by(name: name).present?
  end
end
