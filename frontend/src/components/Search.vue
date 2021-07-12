<template>
  <div>
    <v-menu offset-y>
      <template v-slot:activator="{ on }">
        <v-text-field
        class="input-container"
        solo
        placeholder="タグで検索（地域、国、都市名）"
        prepend-inner-icon="mdi-map-marker"
        v-model="inputWord"
        v-on="on"
        ></v-text-field>
      </template>
      <div class="result-contaienr-wrapper">
        <v-card class="result-container">
          <!-- if文で場合わけする -->
          <div>検索対象がありません</div>
          <div
            class="result-item"
            v-for="n of thumbnails.length"
            :key="n"
          >
            <div class="result-item-tags">
              <div
                class="tag-wrapper"
                v-for="tag of extractedVideoData[n-1].tags"
                :key="tag.id"
              >
                <div class="tag"><v-icon small color="orange">mdi-tag</v-icon>{{ tag }}</div>
              </div>
            </div>
            <img :src="thumbnails[n-1]" class="result-item-img">
          </div>
        </v-card>
      </div>
    </v-menu>
  </div>
</template>
<script>
import videoData from '../assets/video-data.json';
import getYoutubeData from '../getYoutubeData.js';
export default {
  data() {
    return {
      inputWord: '',
      videoData: videoData,
      extractedVideoData: [],
      videoIds: [],
      items: [],
      thumbnails: [],
    }
  },
  watch: {
    inputWord: function() {
      if (this.inputWord != '') {
        let keyword = this.inputWord;
        let extractedVideoData = this.extractedVideoData;
        const videoData = this.videoData;

        for (let i = 0; i < videoData.length; i++) {
          let tags = videoData[i].tags;
          for (let j = 0; j < tags.length; j++) {
            if (tags[j].indexOf(keyword) > -1) {
              if (!extractedVideoData.includes(videoData[i])) {
                // 検索ワードに引っかかったtagにヒットして抽出されたvideoDataをextractedVideoDataにpushしている。
                extractedVideoData.push(videoData[i])
                this.getSearchingVideoData();
              }
            }
          }
        }
      } else {
        this.extractedVideoData = [];
      }
    }
  },
  created() {
    // Youtubeのデータを取得するためのメソッド。引数にsetItemsメソッドを入れることで、getYoutubeData()の先で取得したresponseを
    // this.itemsに代入することができる。
    const setItems = (items) => {
      this.items = items;
    }
    getYoutubeData(setItems);
  },
  methods: {
    // extractedVideoDataのvideoidを用いてそれぞれのthumunailsのurlを取得し、thumbnailsにpushする。
    // getSearchingVideoData()が発火した時に、前回の検索履歴を消すためにthumbnailsに空配列を代入。
    getSearchingVideoData() {
      this.thumbnails = [];
      let extractedVideoData = this.extractedVideoData;
      const items = this.items;

      for (let i = 0; i < extractedVideoData.length; i++){
        for (let j = 0; j < items.length; j++) {
          if (extractedVideoData[i].videoId == items[j].snippet.resourceId.videoId) {
            this.thumbnails.push(items[j].snippet.thumbnails.medium.url);
          }
        }
      }
    }
  }
}
</script>
<style scoped>
  .input-container {
    max-width: 290px;
  }
  .result-contaienr-wrapper {
    max-height: 350px;
  }
  .result-container {
    overflow: auto;
    max-width: 380px;
  }
  .result-item {
    width: 95%;
    margin: 10px auto;
    cursor: pointer;
  }
  .result-item:hover {
    background-color: #eee;
  }
  .result-item-tags {
    margin-top: 20px;
    height: 75%;
    display: flex;
    flex-wrap: wrap;
  }
  .tag {
    margin-right: 5px;
  }
  .result-item-img {
    width: 97%;
    border-radius: 3%;
  }
  @media screen and (min-width:400px) {
    .result-item {
      display: flex;
    }
    .result-item-img {
    height: 113.63px;
    width: 200px;
    }
  }
</style>