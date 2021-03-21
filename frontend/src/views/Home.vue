<template>
    <v-main id="main">
      <v-container fluid>
        <v-row>
          <v-col cols="9">
            <GoogleMap @change-marker-num="changeMarkerNum" @expand-window="expandWindow"></GoogleMap>
          </v-col>
          <v-col cols="3">
            <Ranking :items='items' @change-marker-num="changeMarkerNum"></Ranking>
          </v-col>
        </v-row>
      </v-container>
      
      <ImportPlaylist @playlist-items="playlistItems"></ImportPlaylist>
      <Youtube :marker-num='markerNum' :items='items' :expand='expand'></Youtube>
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
      markerNum: null,
      items: null,
      expand: null,
    }
  },
  methods: {
    changeMarkerNum(e){
      this.markerNum = e;
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
  #main {
    margin: 0 6vw;
  }
</style>