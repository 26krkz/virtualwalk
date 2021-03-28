class VideosController < ApplicationController
  def show
    select_video
        render json: @video
  end
end
