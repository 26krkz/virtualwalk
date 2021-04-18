class FavoritesController < ApplicationController

  # お気に入りに追加
  def create
    @favorite = Favorite.create(user_id: params[:user_id], video_id: params[:video_id])
    render json: { message: 'お気に入りに追加しました！'}
  end
  # お気に入り削除
  def destroy
    @favorite = Favorite.find_by(user_id: params[:user_id], video_id: params[:video_id])
    @favorite.destroy
    render json: { message: 'お気に入りから削除しました' }
  end

  def show
    @top_five_favorites = Video.find(Favorite.group(:video_id).order('count(video_id) desc').limit(5).pluck(:video_id))
    render json: @top_five_favorites
  end

end
