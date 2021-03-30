<template>
    <v-main class="main">
      <v-container fluid class="googlemap-container">
        <v-row>
          <v-col cols="9">
            <GoogleMap @select-video-id="selectVideoId" @expand-window="expandWindow"></GoogleMap>
          </v-col>
          <v-col cols="3">
            <Ranking :items='items' @select-video-id="selectVideoId"></Ranking>
          </v-col>
        </v-row>
      </v-container>
      
      <ImportPlaylist @playlist-items="playlistItems"></ImportPlaylist>
      <Youtube :video-id='videoId' :items='items' :expand='expand'></Youtube>
    </v-main>
</template>

<script>
import GoogleMap from '../components/GoogleMap';
import Youtube from '../components/Youtube';
import ImportPlaylist from '../components/ImportPlaylist';
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
    playlistItems(e){
      this.items= e;
    },
    expandWindow(e){
      this.expand = e;
    }
  },

  components: {
    GoogleMap,
    Youtube,
    ImportPlaylist,
    Ranking
  },


};
</script>

<style>
  .main {
    margin: 0 6vw;
  }
  .googlemap-container {
    margin-bottom: 30px;
  }
</style>