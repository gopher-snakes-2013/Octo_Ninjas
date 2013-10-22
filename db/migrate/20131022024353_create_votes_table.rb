class CreateVotesTable < ActiveRecord::Migration
  def up
  	create_table :votes do |t|
  		t.belongs_to :survey_movies
  		t.string :name

  		t.timestamps
  end

  def down
  	drop_table :votes
  end
end
