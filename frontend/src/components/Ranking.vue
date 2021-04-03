<template>
    <div class="ranking-wrapper">
        <div class="ranking">
            <div class="ranking-title">お気に入りランキング<span>Top5</span></div>
            <div class="scroll-area">
            </div>
            <div class="scroll-area-bottom-icon"><v-icon large >mdi-chevron-down</v-icon></div>
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

            axios.get('http://localhost/favorite', {withCredentials: true} )
            .then(function (response) {
                that.topFiveFavorites = response.data;
                that.compareTopFiveFavoritesAndItems();
                that.getRankingView();
                // console.log(that.topFiveFavorites);
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
        //.scroll-area内にimgタグを作る。それぞれのsrcはお気に入りtopFiveFavoriteVideosから取得する。
        getRankingView(){
            let that = this;
            const scrollArea = document.querySelector('.scroll-area'); 
            for(let i = 0; this.items&&this.items.length > i; i++){
                let newImg = document.createElement('img');
                newImg.src = that.topFiveFavoriteVideos[i].snippet.thumbnails.medium.url;
                newImg.style.cssText = "cursor:pointer; width:100%;";
                newImg.addEventListener('click', ()=>{
                    that.$emit('select-video-id', that.topFiveFavoriteVideos[i].snippet.resourceId.videoId);
                    that.$emit('expand-window', true)
                });
                scrollArea.appendChild(newImg);
            }
        },
    }
}
</script>

<style scoped>
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
    .scroll-area{
        height: 88%;
        overflow: auto;
        padding-right: 20px;
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
    @media screen and (min-width:1270px) {
        .ranking-title {
            font-size:1.2rem;
        }
        .ranking-title span {
            font-size:1.7rem;
        }
    }
</style>