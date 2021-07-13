import axios from 'axios';

const getYoutubeData = (callback) => {
  //youtubeから指定のプレイリストの動画を取得するのに必要なparams
  const params = {
    part: 'snippet',
    maxResults: 50,
    playlistId: process.env.VUE_APP_YOUTUBE_PLAYLIST_ID,
    key: process.env.VUE_APP_YOUTUBE_API_KEY
  }  
  
  axios.get('https://www.googleapis.com/youtube/v3/playlistItems', { params: params })
  .then(response => { callback(response.data.items); })
  .catch(function (error) {
    return console.log(error);
  })
}
export default getYoutubeData;