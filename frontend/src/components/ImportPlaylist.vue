<template>
    <div></div>
</template>
<script>
import axios from 'axios';

export default {
    data(){
        return {
            items: [],
            params: {
            part: 'snippet',
            playlistId: process.env.VUE_APP_YOUTUBE_PLAYLIST_ID, /*Youtubeのplaylist id*/
            key: process.env.VUE_APP_YOUTUBE_API_KEY
            }
        }
    },
    created(){
    // axiosにより指定のプレイリストの動画を取得し、それらをitemsに代入する
        let that = this;
        axios.get('https://www.googleapis.com/youtube/v3/playlistItems', { params: that.params })
        .then(function (response) {
            that.items = response.data.items;
            that.$emit('playlist-items', that.items);
        })
        .catch(function (error) {
        console.log(error);
        })
  },
  
}
</script>