class AddRottenIdToMovies < ActiveRecord::Migration
  def up
    add_column :movies, :rotten_id, :string
  end

  def down
    remove_column :movies, :rotten_id
  end
end
