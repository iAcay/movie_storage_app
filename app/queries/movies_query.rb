class MoviesQuery
  def initialize(params = {})
    @params = params
  end

  def results
    prepare_collection
    filter_by_actors
    filter_by_directors
    distinct_results
    sorting
    @results
  end

  private

  def prepare_collection
    @results = Movie.all
  end

  def distinct_results
    @results = @results.distinct
  end

  def filter_by_actors
    return if @params.dig(:filter, :actor_id).blank?
    actors_ids = @params.dig(:filter, :actor_id).split(',')

    @results = @results.joins(:actors).where(actors: { id: actors_ids })
  end

  def filter_by_directors
    return if @params.dig(:filter, :director_id).blank?
    directors_ids = @params.dig(:filter, :director_id).split(',')

    @results = @results.joins(:director).where(director_id: directors_ids)
  end

  def sorting
    return if @params[:sort].blank?
    
    sort = [release_year: :desc] if @params[:sort] == '-year'
    sort = [release_year: :asc] if @params[:sort] == 'year'
    sort = [budget: :desc] if @params[:sort] == '-budget'
    sort = [budget: :asc] if @params[:sort] == 'budget'
    sort = [imdb_score: :desc] if @params[:sort] == '-imdb_score'
    sort = [imdb_score: :asc] if @params[:sort] == 'imdb_score'
    
    @results = @results.order(sort)
  end
end
