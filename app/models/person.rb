class Person < ApplicationRecord
  self.abstract_class = true

  def self.movies(name)
    director = Director.find_by(name: name)
    directed_movies = director.nil? ? [] : director.movies

    actor = Actor.find_by(name: name)
    participated_movies = actor.nil? ? [] : actor.movies

    directed_movies | participated_movies
  end
end
