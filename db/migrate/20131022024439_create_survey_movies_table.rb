class CreateSurveyMoviesTable < ActiveRecord::Migration
  def up
  	create_table :survey_movies do |t|
  		t.belongs_to :survey
  		t.belongs_to :movie

  		t.timestamps
    end
  end

  def down
  	drop_table :survey_movies
  end
end
