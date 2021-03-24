class CreateVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :videos do |t|
      t.string :video_id
      t.string :region
      t.string :country
      t.integer :playlist_number

      t.timestamps
    end
  end
end
