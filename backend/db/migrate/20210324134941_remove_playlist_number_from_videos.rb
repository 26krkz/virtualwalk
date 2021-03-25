class RemovePlaylistNumberFromVideos < ActiveRecord::Migration[6.1]
  def change
    remove_column :videos, :playlist_number, :integer
  end
end
