class CreateDirectors < ActiveRecord::Migration[6.1]
  def change
    create_table :directors do |t|
      t.string :name, null: false
      t.bigint :movies_count, default: 0
      t.bigint :total_budget_of_movies, default: 0
      
      t.timestamps
    end
  end
end
