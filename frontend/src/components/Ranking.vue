<template>
    <div>
        <div class="ranking-title">お気に入りランキング<span>Top 5</span></div>
        <div class="scroll-area">
        <div v-for="item of items" v-bind:key="item.id">
            <img :src="item.snippet.thumbnails.medium.url">
        </div>
        </div>
        <div class="icon"><v-icon large >mdi-chevron-down</v-icon></div>
    </div>

</template>

<script>
import axios from 'axios';
export default {
    data(){
        return{
            items: [],
            topFiveFavorites: [],
            topFiveFavoriteVideos: [],

            //youtubeから指定のプレイリストの動画を取得するのに必要なparams
            getPlayListParams: {
            part: 'snippet',
            playlistId: process.env.VUE_APP_YOUTUBE_PLAYLIST_ID, /*Youtubeのplaylist id*/
            key: process.env.VUE_APP_YOUTUBE_API_KEY
            },
        }
    },
    created(){
        let that = this;

        // YoutubeAPIにより指定プレイリストの動画を取得し、それらをitemsにいれる
        axios.get('https://www.googleapis.com/youtube/v3/playlistItems', { params: that.getPlayListParams })
        .then(function (response) {
            that.items = response.data.items;
            that.getTopFiveFavorites();
        })
        .catch(function (error) {
        console.log(error);
        })

    },
    methods: {
        // selectMovie(){
        //     this.$emit('select-video-id', 1);
        // },
        getTopFiveFavorites(){
            let that = this;

            axios.get('http://localhost/favorite', {withCredentials: true} )
            .then(function (response) {
                that.topFiveFavorites = response.data;
                console.log(that.topFiveFavorites);
            })
            .catch(function (error) {
                console.log(error);
            })
        },
        getRankingView(){
            let that = this;
            const scrollArea = document.getElementsByClassName('scroll-area'); 
            for(let i = 0;this.items&&this.items.length > i; i++){
                let newImg = document.createElement('img');
                newImg.src = that.items[i].snippet.thumbnails.medium.url;
                newImg.appendChild(scrollArea);
            }
        },
        //お気に入りした動画データの取得メソッド
        compareTopFiveFavoritesAndItems(){
            //YoutubeAPIで取得したプレイリストとgetTopFiveFavorites()で取得したデータを照らし合わせることで
            //プレイリストの中のお気に入りランキングトップ５の動画の情報のみを取得。取得したデータはtopFivefavoriteVideosに入れていく。
            for(let i = 0; this.topFiveFavorites&&this.topFiveFavorites.length > i; i++){
                for(let j = 0; this.items&&this.items.length > j; j++){
                    let topFive = this.topFiveFavorites[i].video_id;
                    let item = this.items[j].snippet.resourceId.videoId;
                    if(topFive == item){
                        this.topFiveFavoriteVideos.push(this.items[j]);
                    }
                }
            }
        }
    }
}
</script>

<style scoped>
 img {
     width: 300px;
 }
 .scroll-area{
	height: 570px;
	overflow: auto;
	padding-right: 20px;
}
.icon {
    text-align: center;
}
.ranking-title {
    color: #FF9800;
    font-size: 1.2rem;
    font-weight: bold;
}
.ranking-title span {
    color: #00BCD4; 
    /* color: #FF5722; */
    font-size: 1.7rem;
}
</style>