namespace :db do
  task update_directors: :environment do
    Director.all.each do |director|
      movies_count = director.movies.count
      total_budget_of_movies = 0
      director.movies.each do |movie|
        total_budget_of_movies += movie.budget.to_i
      end

      director.update(movies_count: movies_count, total_budget_of_movies: total_budget_of_movies)
      puts "#{director.name}, id: #{director.id} updated!"
    end
  end
end
