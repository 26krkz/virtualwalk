class VideosController < ApplicationController
  def show
    @video = Video.find_by(video_id: params[:id])
        render json: @video
  end
end
