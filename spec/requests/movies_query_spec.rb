require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Movies', type: :request do
  context 'indexing movies with included directors and actors' do
    it 'renders movies with included director' do
      director = create(:director, name: 'Quentin Tarantino')
      actor = create(:actor, name: 'Samuel L. Jackson')
      create(:movie, name: 'The Hateful Eight', 
                     release_year: '2015', 
                     budget: '44000000', 
                     imdb_score: '7.8', 
                     director: director, 
                     actors: [actor])

      get '/movies?include=directors'

      expected = [{
              name: 'The Hateful Eight',
              release_year: '2015', 
              budget: '44000000', 
              imdb_score: '7.8',
              director: { name: 'Quentin Tarantino' }
      }].to_json
     
      expect(response.body).to eq expected
    end

    it 'renders movies with included actors' do
      director = create(:director, name: 'Quentin Tarantino')
      actor1 = create(:actor, name: 'Samuel L. Jackson')
      actor2 = create(:actor, name: 'Kurt Russell')
      create(:movie, name: 'The Hateful Eight', 
                     release_year: '2015', 
                     budget: '44000000', 
                     imdb_score: '7.8', 
                     director: director, 
                     actors: [actor1, actor2])

      get '/movies?include=actors'

      expected = [{
              name: 'The Hateful Eight',
              release_year: '2015', 
              budget: '44000000', 
              imdb_score: '7.8',
              actors: [
                        { name: 'Samuel L. Jackson' },
                        { name: 'Kurt Russell' }
              ]
      }].to_json

      expect(response.body).to eq expected
    end

    it 'renders movies with included actors and directors' do
      director = create(:director, name: 'Quentin Tarantino')
      actor1 = create(:actor, name: 'Samuel L. Jackson')
      actor2 = create(:actor, name: 'Kurt Russell')
      create(:movie, name: 'The Hateful Eight', 
                     release_year: '2015', 
                     budget: '44000000', 
                     imdb_score: '7.8', 
                     director: director, 
                     actors: [actor1, actor2])

      get '/movies?include=actors,directors'

      expected = [{
              name: 'The Hateful Eight',
              release_year: '2015', 
              budget: '44000000', 
              imdb_score: '7.8',
              actors: [
                        { name: 'Samuel L. Jackson' },
                        { name: 'Kurt Russell' }
              ],
              director: { name: 'Quentin Tarantino' }
      }].to_json

      expect(response.body).to eq expected
    end
  end

  context 'sorting movies' do
    it 'sorts movies by release year' do
      create(:movie, name: 'The Hateful Eight', 
                     release_year: '2015', 
                     budget: '44000000', 
                     imdb_score: '7.8',
                     director: create(:director, name: 'Quentin Tarantino'),
                     actors: [create(:actor, name: 'Samuel L. Jackson')])

      create(:movie, name: 'Avatar', 
                     release_year: '2009', 
                     budget: '237000000', 
                     imdb_score: '7.9',
                     director: create(:director, name: 'James Cameron'),
                     actors: [create(:actor, name: 'Sam Worthington')])

      get '/movies?sort=year'

      expected = [{
          name: 'Avatar',
          release_year: '2009', 
          budget: '237000000', 
          imdb_score: '7.9'
        }, 
        {
          name: 'The Hateful Eight',
          release_year: '2015', 
          budget: '44000000', 
          imdb_score: '7.8'
      }].to_json
     
      expect(response.body).to eq expected

      get '/movies?sort=-year'

      expected = [{
          name: 'The Hateful Eight',
          release_year: '2015', 
          budget: '44000000', 
          imdb_score: '7.8'
        },
        {
          name: 'Avatar',
          release_year: '2009', 
          budget: '237000000', 
          imdb_score: '7.9'
      }].to_json
     
      expect(response.body).to eq expected
    end

    it 'sorts movies by budget' do
      create(:movie, name: 'The Hateful Eight', 
                     release_year: '2015', 
                     budget: '10', 
                     imdb_score: '7.8',
                     director: create(:director, name: 'Quentin Tarantino'),
                     actors: [create(:actor, name: 'Samuel L. Jackson')])

      create(:movie, name: 'Avatar', 
                     release_year: '2009', 
                     budget: '20', 
                     imdb_score: '7.9',
                     director: create(:director, name: 'James Cameron'),
                     actors: [create(:actor, name: 'Sam Worthington')])

      get '/movies?sort=-budget'

      expected = [{
          name: 'Avatar',
          release_year: '2009', 
          budget: '20', 
          imdb_score: '7.9'
        }, 
        {
          name: 'The Hateful Eight',
          release_year: '2015', 
          budget: '10', 
          imdb_score: '7.8'
      }].to_json
     
      expect(response.body).to eq expected

      get '/movies?sort=budget'

      expected = [{
          name: 'The Hateful Eight',
          release_year: '2015', 
          budget: '10', 
          imdb_score: '7.8'
        },
        {
          name: 'Avatar',
          release_year: '2009', 
          budget: '20', 
          imdb_score: '7.9'
      }].to_json
     
      expect(response.body).to eq expected
    end

    it 'sorts movies by imdb_score' do
      create(:movie, name: 'The Hateful Eight', 
                     release_year: '2015', 
                     budget: '44000000', 
                     imdb_score: '7.8',
                     director: create(:director, name: 'Quentin Tarantino'),
                     actors: [create(:actor, name: 'Samuel L. Jackson')])

      create(:movie, name: 'Avatar', 
                     release_year: '2009', 
                     budget: '237000000', 
                     imdb_score: '7.9',
                     director: create(:director, name: 'James Cameron'),
                     actors: [create(:actor, name: 'Sam Worthington')])

      get '/movies?sort=-imdb_score'

      expected = [{
          name: 'Avatar',
          release_year: '2009', 
          budget: '237000000', 
          imdb_score: '7.9'
        }, 
        {
          name: 'The Hateful Eight',
          release_year: '2015', 
          budget: '44000000', 
          imdb_score: '7.8'
      }].to_json
     
      expect(response.body).to eq expected

      get '/movies?sort=imdb_score'

      expected = [{
          name: 'The Hateful Eight',
          release_year: '2015', 
          budget: '44000000', 
          imdb_score: '7.8'
        },
        {
          name: 'Avatar',
          release_year: '2009', 
          budget: '237000000', 
          imdb_score: '7.9'
      }].to_json
     
      expect(response.body).to eq expected
    end
  end

  context 'filtering movies' do
    it 'filters movies by actors' do
      actor1 = create(:actor, name: 'Samuel L. Jackson')
      actor2 = create(:actor, name: 'Kurt Russell')
      create(:movie, name: 'The Hateful Eight', 
                     release_year: '2015', 
                     budget: '44000000', 
                     imdb_score: '7.8',
                     director: create(:director, name: 'Quentin Tarantino'),
                     actors: [actor1, actor2])

      actor3 = create(:actor, name: 'Sam Worthington')
      create(:movie, name: 'Avatar', 
                     release_year: '2009', 
                     budget: '237000000', 
                     imdb_score: '7.9',
                     director: create(:director, name: 'James Cameron'),
                     actors: [actor3])

      get "/movies?filter[actor_id]=#{actor1.id}"

      expected = [{
          name: 'The Hateful Eight',
          release_year: '2015', 
          budget: '44000000', 
          imdb_score: '7.8'
      }].to_json
     
      expect(response.body).to eq expected
    end

    it 'filters movies by actors and returns all actors of filtered movies' do
      actor1 = create(:actor, name: 'Samuel L. Jackson')
      actor2 = create(:actor, name: 'Kurt Russell')
      create(:movie, name: 'The Hateful Eight', 
                     release_year: '2015', 
                     budget: '44000000', 
                     imdb_score: '7.8',
                     director: create(:director, name: 'Quentin Tarantino'),
                     actors: [actor1, actor2])

      actor3 = create(:actor, name: 'Sam Worthington')
      create(:movie, name: 'Avatar', 
                     release_year: '2009', 
                     budget: '237000000', 
                     imdb_score: '7.9',
                     director: create(:director, name: 'James Cameron'),
                     actors: [actor3])

      get "/movies?filter[actor_id]=#{actor1.id}&include=actors"

      expected = [{
          name: 'The Hateful Eight',
          release_year: '2015', 
          budget: '44000000', 
          imdb_score: '7.8',
          actors: [
            { name: 'Samuel L. Jackson' },
            { name: 'Kurt Russell' }
          ]
      }].to_json
     
      expect(response.body).to eq expected
    end

    it 'filters movies by directors' do
      director1 = create(:director, name: 'Quentin Tarantino')
      actor1 = create(:actor, name: 'Samuel L. Jackson')
      actor2 = create(:actor, name: 'Kurt Russell')
      create(:movie, name: 'The Hateful Eight', 
                     release_year: '2015', 
                     budget: '44000000', 
                     imdb_score: '7.8',
                     director: director1,
                     actors: [actor1, actor2])

      director2 = create(:director, name: 'James Cameron')
      actor3 = create(:actor, name: 'Sam Worthington')
      create(:movie, name: 'Avatar', 
                     release_year: '2009', 
                     budget: '237000000', 
                     imdb_score: '7.9',
                     director: director2,
                     actors: [actor3])

      get "/movies?filter[director_id]=#{director1.id}"

      expected = [{
          name: 'The Hateful Eight',
          release_year: '2015', 
          budget: '44000000', 
          imdb_score: '7.8'
      }].to_json
     
      expect(response.body).to eq expected
    end
  end
end
