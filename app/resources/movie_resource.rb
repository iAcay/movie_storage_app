class MovieResource
  include Alba::Resource

  root_key :movie

  attributes :name, :release_year, :budget, :imdb_score

  many :actors, resource: ActorResource, if: proc { !params[:include].nil? && params[:include].include?('actors') }
  one :director, resource: DirectorResource, if: proc { !params[:include].nil? && params[:include].include?('directors') }
end
