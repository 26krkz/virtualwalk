<template>
    <v-main class="main">
      <v-container fluid class="top-page-container">
        <v-row>
          <v-col cols="12" md="9">
            <v-card elevation="1">
              <GoogleMap @select-video-id="selectVideoId" @expand-window="expandWindow"></GoogleMap>
            </v-card>
          </v-col>
          <v-col cols="12" md="3">
            <Ranking @select-video-id="selectVideoId" @expand-window="expandWindow"></Ranking>
          </v-col>
        </v-row>
      </v-container>
      <div class="youtube-component">
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
    }
  },
  methods: {
    selectVideoId(e){
      this.videoId = e;
    },
    expandWindow(e){
      this.expand = e;
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
    margin: 10px 0;
  }
  .youtube-component {
    /* margin-right: 6vw;
    margin-left: 6vw; */
    width: 90%;
    margin:0 auto;
  }
  .country-tabs-component {
    margin: 0 12px;
  }
  @media screen and (min-width: 1270px){
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