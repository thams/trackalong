class CreateTrackpoint < ActiveRecord::Migration
  def change
    create_table :trackpoints do |t|
      t.string :response, :limit => 8000
      t.string :terrain_elevation # should this be a numeric?
      t.timestamp :processed_at
      t.timestamps
    end
  end
end
