<script>
import axios from 'axios';

export default {
    data(){
        return {
            items: []
        }
    },
    created(){
    // axiosにより指定のプレイリストの動画を取得し、それらをitemsに代入する
        let that = this;
        axios.get('https://www.googleapis.com/youtube/v3/playlistItems', {
            params: {
            part: 'snippet',
            playlistId: 'PLEVYGtNFqAs1vnF6ZB4DaEwfT4f39W8lb', /*Youtubeのplaylist id*/
            // maxResults: 5, /*表示する動画の数*/
            key: 'AIzaSyD4-SGX6A_7gEyADb-cRh9FrD3Y-d6XeL8'
            }
        })
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