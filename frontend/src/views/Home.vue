<template>
    <v-main class="main">
      <v-container fluid class="top-page-container">
        <v-row>
          <v-col cols="12" md="9">
            <div class="google-map-container">
              <v-card elevation="1">
                <GoogleMap @select-video-id="selectVideoId" @expand-window="expandWindow" :video-id='videoId' :zoom='zoom' :random='random'></GoogleMap>
              </v-card>
              <v-btn class="randomly-select-btn" color="warning" small dark @click="randomlySelect">ランダムに選択<v-icon>mdi-map-marker</v-icon></v-btn>
            </div>
          </v-col>
          <v-col cols="12" md="3">
            <Ranking @select-video-id="selectVideoId" @expand-window="expandWindow"></Ranking>
          </v-col>
        </v-row>
      </v-container>
      <div class="youtube-component">
      <div class="down-icon1 d-none d-lg-block" ><v-icon x-large v-show="expand">mdi-chevron-down</v-icon></div>
      <div class="down-icon2 d-none d-lg-block" ><v-icon x-large v-show="expand">mdi-chevron-down</v-icon></div>
      <v-btn class="close-btn" v-show="expand" @click="closeYoutubeWindow" small >close</v-btn>
        <v-card>
          <Youtube :video-id='videoId' :expand='expand'></Youtube>
        </v-card>
      </div>
      <CountryTabs class="country-tabs-component" @select-video-id="selectVideoId" @expand-window="expandWindow"></CountryTabs>
    </v-main>
</template>

<script>
import GoogleMap from '../components/GoogleMap';
import Youtube from '../components/Youtube';
import Ranking from '../components/Ranking';
import CountryTabs from '../components/CountryTabs';

export default {
  name: 'App',
  data(){
    return {
      videoId: '',
      items: null,
      expand: null,
      zoom: false,
      random: false,
    }
  },
  methods: {
    selectVideoId(e){
      this.videoId = e;
    },
    expandWindow(e){
      this.expand = e;
    },
    closeYoutubeWindow() {
      this.expand = false;
      this.zoom = !this.zoom;
    },
    randomlySelect() {
      this.random = !this.random;
    }
  },

  components: {
    GoogleMap,
    Youtube,
    Ranking,
    CountryTabs
  },


};
</script>

<style>
  .main {
    margin-bottom: 50px;
  }
  .top-page-container {
    margin: 17px 0;
  }
  .google-map-container {
    position: relative;
  }
  .randomly-select-btn {
    position: absolute;
    bottom: 5%;
    left: 7%;
  }
  .youtube-component {
    width: 95%;
    margin:0 auto;
    position: relative;
  }
  .down-icon1 {
    position:absolute;
    top: -45px;
    right: 50%;
  }
  .down-icon2 {
      position:absolute;
      top: -35px;
      right: 50%;
  }
  .close-btn {
    position: absolute;
    top: -24px;
    right: 0;
    background-color: #eee;
    border-radius: 0;
  }
  .country-tabs-component {
    margin: 0 12px;
  }
  @media screen and (min-width: 1320px){
    .main {
    margin-right:6vw;
    margin-left:6vw;
    }
    .country-tabs-component {
      margin: 0;
    }
  }
  @media screen and (min-width: 960px){
    .top-page-container {
    margin: 25px 0;
    }
  }
</style>