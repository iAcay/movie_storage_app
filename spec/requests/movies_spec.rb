require 'swagger_helper'

RSpec.describe 'movies', type: :request do

  path '/movies' do
    get('list movies') do
      tags 'Movies'
      description "Following endpoint accepts three types of query parameters:\n
      include accepts 'actors', 'directors' or both 'actors,directors'. Adding include parameter provides to render movie's data with director/actors names'.\n
      sort accepts '-year', 'year', '-budget', 'budget', '-imdb_score', 'imdb_score'. This parameter has impact on sorting rendered movies. '-year' parameter provides to sort movies by release_year in descending order wheras 'year' the other way around. By analogy '-budget', 'budget' and '-imdb_score', 'imdb_score'\n
      filter[actor_id] accepts actors ids. This parameter causes rendering only movies which filtered actor was acting in. \n
      filter[director_id] accepts directors ids. This parameter causes rendering only movies directed by filtered director."

      produces 'application/json'
      parameter name: :include, in: :query, type: :string
      parameter name: :sort, in: :query, type: :string
      parameter name: 'filter[actor_id]', in: :query, type: :string
      parameter name: 'filter[director_id]', in: :query, type: :string

      response(200, 'successful') do
        schema type: :array,
          properties: {
            name: { type: :string },
            release_year: { type: :string },
            budget: { type: :string },
            imdb_score: { type: :string },
            actors: [ { name: { type: :string } } ],
            director: { name: { type: :string } }
          }

        example 'application/json', :raw_movie_data, {
          name: 'The Hateful Eight',
          release_year: '2015',
          budget: '44000000',
          imdb_score: '7.8'
        }

        example 'application/json', :with_included_director_data, {
          name: 'The Hateful Eight',
          release_year: '2015',
          budget: '44000000',
          imdb_score: '7.8',
          director: { name: 'Quentin Tarantino' }
        }

        example 'application/json', :with_included_actors_data, {
          name: 'The Hateful Eight',
          release_year: '2015',
          budget: '44000000',
          imdb_score: '7.8',
          actors: [
            { name: 'Samuel L. Jackson' },
            { name: 'Kurt Russell' }
          ]
        }

        example 'application/json', :with_included_director_and_actors_data, {
          name: 'The Hateful Eight',
          release_year: '2015',
          budget: '44000000',
          imdb_score: '7.8',
          director: { name: 'Quentin Tarantino' },
          actors: [
            { name: 'Samuel L. Jackson' },
            { name: 'Kurt Russell' }
          ]
        }

        let(:movie) { create(:movie) }
        let(:include) { 'actors,directors' }
        let(:sort) { 'year' }
        let('filter[actor_id]') { movie.actors.first.id }
        let('filter[director_id]') { movie.director.id }
        run_test!
      end
    end

    post('create movie') do
      tags 'Movies'
      description "Creating a new movie causes:\n
      - saving movie, director, actors and genres to database,\n
      - sending e-mail with information about new movie to newsletter members,\n
      -- updating director's data(movies_count, total_budget_of_movies),\n
      -- rendering json with new movie data including director and actors informations.\n
      If any of following parameters do not meet the requirements, we will reach 422 response with rendered errors in json format."

      consumes 'application/json'
      parameter name: :movie, in: :query, schema: {
        type: :object,
        properties: { 
          'movie[name]': { type: :string },
          'movie[release_year]': { type: :string },
          'movie[budget]': { type: :string },
          'movie[imdb_score]': { type: :string },
          'movie[director_name]': { type: :string },
          'movie[actors_names]': { type: :string },
          'movie[genres_names]': { type: :string }
        }
      }

      response(200, 'movie created') do        
        example 'application/json', :successful_creation_of_new_movie, {
          movie: {
            name: 'The Hateful Eight',
            release_year: '2015',
            budget: '44000000',
            imdb_score: '7.8',
            actors: [
              { name: 'Samuel L. Jackson' },
              { name: 'Kurt Russell' }
            ],
            director: { name: 'Quentin Tarantino' }
          } 
        }

        let(:movie) { { movie: { name: "The Hateful Eight", release_year: "2015", 
                                 budget: "44000000", imdb_score: "7.8", 
                                 director_name: "Quentin Tarantino", 
                                 actors_names: "Samuel L. Jackson,Kurt Russell", 
                                 genres_names: "Western" } } }
        run_test!
      end

      response(422, 'unprocessable_entity') do
        example 'application/json', :failure_to_create_new_movie, {
                  name: ["can't be blank, Movie with this name already exists"],
                  release_year: ["Release year is not a number"],
                  budget: ["Budget is not a number"],
                  imdb_score: ["IMDb score is not a number"]
        }

        let(:movie) { { movie: { name: "The Hateful Eight", release_year: "no_number",
                                 budget: "no_number", imdb_score: "no_number" } } }
        run_test!
      end
    end
  end
end
