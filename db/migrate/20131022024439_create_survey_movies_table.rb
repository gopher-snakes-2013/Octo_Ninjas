class CreateSurveyMoviesTable < ActiveRecord::Migration
  def up
  	create_table :survey_movies do |t|
  		t.belongs_to :survey
  		t.belongs_to :movies

  		t.timestamps
  end

  def down
  	drop_table :survey_movies
  end
end
