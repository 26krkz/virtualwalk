class AddTagsToVideos < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :tag1, :string
    add_column :videos, :time, :string
  end
end
