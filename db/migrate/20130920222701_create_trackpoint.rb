class CreateTrackpoint < ActiveRecord::Migration
  def change
    create_table :trackpoints do |t|
      t.string :response, :limit => 8000
      t.float :terrain_elevation_meters
      t.timestamp :processed_at
      t.timestamps
    end
  end
end
