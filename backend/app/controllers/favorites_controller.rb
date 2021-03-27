class FavoritesController < ApplicationController

  # お気に入りに追加
  def create
    @favorite = Favorite.create(user_id: params[:user_id], video_id: params[:video_id])
    render json: { message: 'お気に入りに追加しました！'}
  end
  # お気に入り削除
  def destroy
    current_user
    select_video
    # @favorite = Favorite.find_by(user_id: @current_user.id, video_id: params: @video.id)
    # @favorite.destroy
    render json: { message: 'お気に入りから削除しました', current_user: @current_user, video: @video }
  end

end
