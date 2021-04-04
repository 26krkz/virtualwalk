<template>
  <div class="map-wrapper">
    <div class="map" ref="googleMap">
    </div>
  </div>
</template>

<script>
import GoogleMapsApiLoader from 'google-maps-api-loader';
import markerLocation from '../assets/marker.json'
export default {
    name: 'Map',
    data(){
        return {
            google: null,
            map: null,
            apiKey: process.env.VUE_APP_GOOGLE_MAP_API_KEY,
            mapConfig: {
                center: {
                    lat: 35,
                    lng: 155
                },
                zoom: 1.9,
            },
            markerLocation: markerLocation,
            markers: [],
            markerNum: 0,
        }
    },
    //google-map-api-loaderライブラリ、Maps javascript APIを利用してマップを表示。マップ上にはマーカーも表示。
    async mounted() {
         const googleMapApi = await GoogleMapsApiLoader({
         apiKey: this.apiKey,
         libraries: ['places']
    })
    this.google = googleMapApi
    this.initializeMap()
    this.setMarker();
    },
    methods: {
      //google mapの表示。
      initializeMap() {
        const mapContainer = this.$refs.googleMap
        this.map = new this.google.maps.Map(
          mapContainer, this.mapConfig
        )
      },
      //マップ上にマーカーを表示。
      setMarker(){
        for(let i=0; i<this.markerLocation.length; i++){
            let marker = new this.google.maps.Marker({
                position: this.markerLocation[i],
                map: this.map,
                // title: this.markerLocation[i].id,
            });
            this.markers.push(marker);          //生成したマーカーをマーカー配列にpushする
            marker.addListener('click', ()=>{          //マーカーをクリックしたときのイベント
                if (marker.getAnimation() == null) {    //マーカーをクリックした時にバウンドさせる。もう一度クリックor他のマーカーをクリックした時は止める。
                    for(let i = 0; i< this.markers.length; i++){
                        this.markers[i].setAnimation(null);
                    }
                    marker.setAnimation(this.google.maps.Animation.BOUNCE);
                    this.$emit('expand-window', true)
                  } else {
                    marker.setAnimation(null);
                    this.$emit('expand-window', false)
                }
                this.$emit('select-video-id', this.markerLocation[i].videoId);    //event upで選択したマーカーのidをApp.vueに渡す。
            });
        }
      }
    },
}
</script>

<style scoped>
.map-wrapper {
  width:100%;
  padding-top:70%;
  position: relative;
  margin:auto;
  }
.map {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  }
</style>