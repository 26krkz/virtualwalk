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
                <v-tab v-for="region in regions" :key="region.id" @click="getRegionsVideos(region)">
                    {{ region }}
                </v-tab>
            </v-tabs>
            <v-card flat height="200" class="tab-items">
                <div v-for="selectedRegionVideo of selectedRegionVideos" :key="selectedRegionVideo.id">
                    <v-card class="tab-item" width="320" height="180">
                        <img :src="selectedRegionVideo.snippet.thumbnails.medium.url" 
                            @click="showSelectedVideo(selectedRegionVideo.snippet.resourceId.videoId)"
                        >
                    </v-card>
                </div>
            </v-card>
        </v-card>
    </div>
</template>

<script>
import axios from 'axios';
export default {
    data(){
        return{
            tabs: null,
            regions: ['ヨーロッパ', 'アジア', 'アフリカ', 'オセアニア', '北アメリカ', '南アメリカ'],
            items:[],
            selectedRegionData:[],
            selectedRegionVideos: [],

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
            that.getRegionsVideos(that.regions[0]);
        })
        .catch(function (error) {
        console.log(error);
        })
    },
    methods: {
        getRegionsVideos(selectedRegion){
                this.selectedRegionVideos = [];
                let that = this;
                axios.get('http://localhost/videos',
                          {params: {region: selectedRegion},
                           withCredentials: true,
                           headers: { 'X-Requested-With': 'XMLHttpRequest' }
                          }
                         )
                .then(function (response) {
                    that.selectedRegionData = response.data;
                    that.compareSelectedRegionDataAndItems();
                })
                .catch(function (error) {
                console.log(error);
                })
        },
        //それぞれのregionの動画データ取得メソッド
        compareSelectedRegionDataAndItems(){
            //YoutubeAPIで取得したプレイリストとselectRegion()で取得したデータを照らし合わせることで
            //プレイリストの中の特定の地域の動画データのみを取得。取得したデータはにselectedRegionVideos入れていく。
            for(let i = 0; this.selectedRegionData&&this.selectedRegionData.length > i; i++){
                for(let j = 0; this.items&&this.items.length > j; j++){
                    let regionData = this.selectedRegionData[i];
                    let item = this.items[j].snippet.resourceId.videoId;
                    if(regionData == item){
                        this.selectedRegionVideos.push(this.items[j]);
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
 .tab-items {
     display: flex;
     flex-wrap: wrap;
     overflow: auto;
 }
 .tab-item {
     margin: 10px 7px;
 }
</style>