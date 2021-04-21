class VideosController < ApplicationController
  def show
    select_video
    render json: @video
  end

  def index
    @videos = Video.where(region: params[:region]).pluck(:video_id)
    render json: @videos
  end
end
