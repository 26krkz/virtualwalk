<template>
    <div>
        <v-card>
            <v-tabs
            v-model="tabs"
            background-color="cyan"
            dark
            grow
            >
                <v-tabs-slider color="orange"></v-tabs-slider>
                <v-tab v-for="region in regions" :key="region.id">
                    {{ region }}
                </v-tab>
            </v-tabs>
            <v-tabs-items v-model="tabs">
                <v-tab-item v-for="i in 6" :key="i.id">
                    <v-card flat>
                        <div v-for="selectedRegionVideo of selectedRegionVideos" :key="selectedRegionVideo.id">
                            <img :src="selectedRegionVideo.snippet.thumbnails.medium.url">
                        </div>
                    </v-card>
                </v-tab-item>
            </v-tabs-items>
        </v-card>
    </div>
</template>

<script>
import axios from 'axios';
export default {
    data(){
        return{
            tabs: null,
            regions: ['ヨーロッパ', 'アジア', 'アフリカ', 'オセアニア/オーストラリア', '北アメリカ', '南アメリカ'],
            items:[],
            selectedRegionData:[],
            selectedRegionVideos: [],

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
        })
        .catch(function (error) {
        console.log(error);
        })

        this.getRegionsVideos();

    },
    methods: {
        getRegionsVideos(){
            for(let i = 0; i < this.regions.length; i++){
                let selectedRegion = this.regions[i];
                let that = this;
                axios.get('http://localhost/videos', {params: {region: selectedRegion} }, {withCredentials: true})
                .then(function (response) {
                    that.selectedRegionData[i]= response.data;
                    console.log(that.selectedRegionData);
                    // console.log(that.selectedRegionData[0][0]);
                    that.compareSelectedRegionDataAndItems();
                })
                .catch(function (error) {
                console.log(error);
                })
            }
        },
        //お気に入りした動画データの取得メソッド
        compareSelectedRegionDataAndItems(){
            //YoutubeAPIで取得したプレイリストとselectRegion()で取得したデータを照らし合わせることで
            //プレイリストの中の特定の地域の動画データのみを取得。取得したデータはにselectedRegionVideos入れていく。
            // let that = this;
            for(let i = 0; this.selectedRegionData&&this.selectedRegionData.length > i; i++){
                let regionData = this.selectedRegionData[i];
                console.log(regionData[0]);
                for(let j = 0; regionData&&regionData.length > j; j++){
                    for(let k = 0; this.items&&this.items.length > k; k++){
                        let item = this.items[k].snippet.resourceId.videoId;
                        if(regionData[j] == item){
                            this.selectedRegionVideos.push(this.items[k]);
                            console.log(this.selectedRegionVideos);
                            console.log('hello');
                        }
                    }

                }
            }
        },
    }
}
</script>