class MemosController < ApplicationController
  before_action :set_favorite, only: [:create]

  def index
    # 特定のお気に入りidのメモを全て取得
    video = Video.find_by(video_id: params[:video_id]);
    favorite = Favorite.find_by(user_id: params[:user_id], video_id: video.id);
    if favorite
      @memos = Memo.where(favorite_id: favorite.id)
      render json: @memos
    end
  end

  def create
    # memoの新規作成
    Memo.create(favorite_id: @favorite.id, time: params[:memo][:time], comment: params[:memo][:comment])
  end

  def update
    # memoの更新
    Memo.find(params[:id]).update(memo_params)
  end

  def destroy
    # memoの削除
    Memo.find(params[:id]).destroy
  end

  private
  
      def set_favorite
        video = Video.find_by(video_id: params[:memo][:video_id]);
        @favorite = Favorite.find_by(user_id: params[:memo][:user_id], video_id: video.id);
      end

      def memo_params
        params.require(:memo).permit(:time, :comment)
      end
end
