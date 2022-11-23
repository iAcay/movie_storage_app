require 'csv'

# In order to run following rake task put "% bundle exec rake db:import_movies_from_csv your_file_path" in your console
namespace :db do
  task import_movies_from_csv: :environment do
    CSV.foreach(ARGV[1], headers: true) do |row|
      movie = Movie.find_or_initialize_by(name: row['movie_title'])
      movie.director = Director.find_or_create_by(name: row['director_name'])
      movie.actors << Actor.find_or_create_by(name: row['actor_1_name']) unless row['actor_1_name'].nil?
      movie.actors << Actor.find_or_create_by(name: row['actor_2_name']) unless row['actor_2_name'].nil?
      movie.actors << Actor.find_or_create_by(name: row['actor_3_name']) unless row['actor_3_name'].nil?
      row['genres'].split('|').each do |genre_name|
        movie.genres << Genre.find_or_create_by(name: genre_name)
      end
      movie.release_year = row['title_year']
      movie.budget = row['budget']
      movie.imdb_score = row['imdb_score']
      movie.save
    end
    puts 'Movies imported!'
    Rake::Task['db:update_directors'].execute
  end
end
