<template>
    <v-main class="main">
      <v-container fluid class="googlemap-container">
        <v-row>
          <v-col cols="9">
            <GoogleMap @select-video-id="selectVideoId" @expand-window="expandWindow"></GoogleMap>
          </v-col>
          <v-col cols="3">
            <Ranking @select-video-id="selectVideoId" @expand-window="expandWindow"></Ranking>
          </v-col>
        </v-row>
      </v-container>
      <Youtube :video-id='videoId' :expand='expand'></Youtube>
    </v-main>
</template>

<script>
import GoogleMap from '../components/GoogleMap';
import Youtube from '../components/Youtube';
import Ranking from '../components/Ranking';

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
    Ranking
  },


};
</script>

<style>
  .main {
    margin: 0 6vw;
  }
  .googlemap-container {
    margin: 25px 0;
  }
</style>