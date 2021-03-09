<template>
  <v-app>
    <header>
      <Header></Header>
    </header>

    <v-main>
      <v-container>
        <v-row>
          <v-col cols="10">
            <GoogleMap @change-marker-num="changeMarkerNum"></GoogleMap>
          </v-col>
          <v-col cols="2">
            <Ranking :items='items' @change-marker-num="changeMarkerNum"></Ranking>
          </v-col>
        </v-row>
      </v-container>
      
      <ImportPlaylist @playlist-items="playlistItems"></ImportPlaylist>
      <Youtube :marker-num='markerNum' :items='items'></Youtube>
    </v-main>
  </v-app>
</template>

<script>
import Header from './components/Header';
import GoogleMap from './components/GoogleMap';
import Youtube from './components/Youtube';
import ImportPlaylist from './components/ImportPlaylist';
import Ranking from './components/Ranking';

export default {
  name: 'App',
  data(){
    return {
      markerNum: null,
      items: null,
    }
  },
  methods: {
    changeMarkerNum(e){
      this.markerNum = e;
    },
    playlistItems(e){
      this.items= e;
    }
  },

  components: {
    Header,
    GoogleMap,
    Youtube,
    ImportPlaylist,
    Ranking
  },


};
</script>

<style>
  .sample {
      height: 100px;
      background-color: skyblue;
      margin-bottom: 10px;
  }
</style>