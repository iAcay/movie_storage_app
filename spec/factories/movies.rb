FactoryBot.define do
  factory :movie do
    name { 'Avatar' }
    release_year { '2009' }
    budget { '237000000' }
    imdb_score { '7.9' }
    director
    actors { build_list :actor, 1 }
  end
end
