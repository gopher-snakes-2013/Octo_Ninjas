class CreateSurveysTable < ActiveRecord::Migration
  def up
  	create_table :surveys do |t|
  		t.belongs_to :user
      t.string :survey_url
      t.text :survey_info


  		t.timestamps
    end
  end

  def down
  	drop_table :surveys
  end
end
