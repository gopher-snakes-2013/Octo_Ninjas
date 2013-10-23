class Add6NewFieldsToMoviesTable < ActiveRecord::Migration
  def up
  	add_column :movies, :synopsis, :text
  	add_column :movies, :runtime, :string
  	add_column :movies, :critics_score, :string
  	add_column :movies, :audience_score, :string
  	add_column :movies, :pic, :string
  end

  def down
		remove_column :movies, :synopsis, :text
  	remove_column :movies, :runtime, :string
  	remove_column :movies, :critics_score, :string
  	remove_column :movies, :audience_score, :string
  	remove_column :movies, :pic, :string
  end
end
