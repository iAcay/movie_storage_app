class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :name
      t.string :release_year
      t.string :budget
      t.string :imdb_score
      t.references :director, foreign_key: true
      
      t.timestamps
    end
  end
end
