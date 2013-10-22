class CreateSurveysTable < ActiveRecord::Migration
  def up
  	create_table :surveys do |t|
  		t.belongs_to :user


  		t.timestamps
  end

  def down
  	drop_table :surveys
  end
end
