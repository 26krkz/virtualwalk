class FavoritesController < ApplicationController
  
  # お気に入り登録
  def create
    @favorite = Favorite.create(user_id: params[:user_id], video_id: params[:video_id])
  end
  # お気に入り削除
  def destroy
    @favorite = Favorite.find_by(user_id: params[:user_id], video_id: params[:video_id])
    @favorite.destroy
  end

end
