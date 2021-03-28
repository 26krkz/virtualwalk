module VideosHelper
    def select_video
    @video = Video.find_by(video_id: params[:id])
    end
end