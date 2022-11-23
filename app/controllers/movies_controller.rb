class MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    movies = MoviesQuery.new(params).results.preload(:director, :actors)
        # I do not use here .includes because it has bad influence on filter_by_actors (it uses eager_load). 
        # With .includes final json returns movies only with actors' names which was filtered, so we do not receive all movie actors. 
        # .preload method guarantees we receive movies with all actors that were acting in particular movie. 
        # Example:
        # 
        # We're looking for movies that Johnny Depp starred in.
        # 
        #  movies = MoviesQuery.new(params).results.includes(:actors) will return:
        #       {
        #         "name": "Yoga Hosers",
        #         "release_year": "2016.0",
        #         "budget": "5000000.0",
        #         "imdb_score": "4.8",
        #         "actors": [
        #             {
        #                 "name": "Johnny Depp"
        #             }
        #         ]
        #       }
        # 
        #  movies = MoviesQuery.new(params).results.preload(:actors) will return
        #       {
        #         "name": "Yoga Hosers",
        #         "release_year": "2016.0",
        #         "budget": "5000000.0",
        #         "imdb_score": "4.8",
        #         "actors": [
        #             {
        #                 "name": "Johnny Depp"
        #             },
        #             {
        #                 "name": "Haley Joel Osment"
        #             },
        #             {
        #                 "name": "Natasha Lyonne"
        #             }
        #         ]
        #       }
   
    render json: MovieResource.new(movies, params: { include: params[:include] }).serialize, status: :ok
  end

  def create
    form = MovieForm.new(movie_params)
    service = CreateMovieService.new(form)

    if service.call
      render json: MovieResource.new(service.movie, params: { include: 'directors,actors' }).serialize, status: :ok
    else
      render json: service.errors, status: :unprocessable_entity
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:name, :release_year, :budget, :imdb_score, :director_name, :actors_names, :genres_names)
  end
end
