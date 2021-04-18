<template>
    <div class="ranking-wrapper">
        <div class="ranking">
            <div class="ranking-title">お気に入りランキング<span>Top5</span></div>
            <div class="scroll-area">
                <div v-for="topFiveFavoriteVideo of topFiveFavoriteVideos" :key="topFiveFavoriteVideo.id">
                    <v-card flat>
                        <img :src="topFiveFavoriteVideo.snippet.thumbnails.medium.url" 
                            @click="showSelectedVideo(topFiveFavoriteVideo.snippet.resourceId.videoId)"
                            class="thumbnail"
                        >
                    </v-card>
                </div>
            </div>
            <div class="scroll-area-bottom-icon d-none d-md-block "><v-icon large >mdi-chevron-down</v-icon></div>
        </div>
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
            maxResults: 50,
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
        //お気に入りに追加された回数で降順に並べた動画データを配列で取得する
        getTopFiveFavorites(){
            let that = this;
            const url = process.env.VUE_APP_API_BASE_URL + '/favorite';
            axios.get(url, {withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' }} )
            .then(function (response) {
                that.topFiveFavorites = response.data;
                that.compareTopFiveFavoritesAndItems();
            })
            .catch(function (error) {
                console.log(error);
            })
        },
        //お気に入りした動画データの取得メソッド
        compareTopFiveFavoritesAndItems(){
            //YoutubeAPIで取得したプレイリストとgetTopFiveFavorites()で取得したデータを照らし合わせることで
            //プレイリストの中のお気に入りランキングトップ５の動画情報のみを取得。取得したデータはtopFiveFavoriteVideosに入れていく。
            for(let i = 0; this.topFiveFavorites&&this.topFiveFavorites.length > i; i++){
                for(let j = 0; this.items&&this.items.length > j; j++){
                    let topFive = this.topFiveFavorites[i].video_id;
                    let item = this.items[j].snippet.resourceId.videoId;
                    if(topFive == item){
                        this.topFiveFavoriteVideos.push(this.items[j]);
                    }
                }
            }
        },
        showSelectedVideo(videoId){
            this.$emit('select-video-id', videoId);
            this.$emit('expand-window', true)
        }
    }
}
</script>

<style scoped>
    .scroll-area {
        display:flex;
        overflow-x: scroll;
        border-top: 3px solid #e0e0e0;
        border-bottom: 3px solid #e0e0e0;
    }
    .thumbnail {
        cursor: pointer;
        margin: 5px 0.5vw 0 0.5vw;
    }
    .scroll-area-bottom-icon {
        text-align: center;
        padding-right: 20px;
    }
    .ranking-title {
        color: #FF9800;
        font-size: 1rem;
        font-weight: bold;
        margin-bottom: 5px;
    }
    .ranking-title span {
        color: #00BCD4; 
        font-size: 1.5rem;
    }
    @media screen and (min-width:960px) {
        .ranking-wrapper {
            width:100%;
            padding-top:220%;
            position: relative;
            margin:auto;
        }
        .ranking {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
        }
        .scroll-area {
            display:grid;
            height: 88%;
            overflow: auto;
            padding-right: 20px;
            border-top: none;
            border-bottom: none;
        }
        .thumbnail {
            width:100%;
            margin: 0;
        }
    }
    @media screen and (min-width:1270px) {
        .ranking-title {
            font-size:1.2rem;
        }
        .ranking-title span {
            font-size:1.7rem;
        }
    }
</style>