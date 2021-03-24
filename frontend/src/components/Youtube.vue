<template>
<v-expand-transition>
  <v-container v-show="expand" class="container grey lighten-2">
      <v-btn class="close-btn" color="black" icon small outlined @click="expand = !expand">
          <v-icon>mdi-window-close</v-icon>
      </v-btn>
      <v-row>
        <v-col cols='4' class="select-movie">
            <img v-bind:src="item.snippet.thumbnails.medium.url">
            <p>{{ videoData.country }}</p>
            <p>{{ videoData.region }}</p>
        </v-col>
        <v-col cols='2'>

            <v-btn block @click="addFavorite">
                お気に入りに追加
                <v-icon v-bind:color="heartColor">{{ heartIcon }}</v-icon>
            </v-btn>
            
            <div class="select-btn">
            <!-- 開始時間を設定 -->
            <label for="start">開始時間：
            <select id="start" v-model="startTime">
                <option selected>指定しない</option>
                <option v-for="sTime in sTimes" v-bind:key="sTime.id" v-bind:value="sTime.value">
                    {{ sTime.text }}
                </option>
            </select>
            </label>
            </div>
        
            <div class="select-btn">
            <!-- 再生時間を設定 -->
            <label for="playing">再生時間：
            <select id="playing" v-model="playingTime" v-on:change="EndTime()">
                <option selected>指定しない</option>
                <option v-for="pTime in pTimes" v-bind:key="pTime.id" v-bind:value="pTime.value">
                    {{ pTime.text }}
                </option>
            </select>
            </label>
            </div>

            <v-btn block class="resume-btn" @click="Resume">表示</v-btn>
        </v-col>
        <v-col class="iframe" cols='6'>
            <iframe width="560" height="315" 
                v-bind:src="selectedMovieUrl" frameborder="0" allowfullscreen>
            </iframe>
            <div class="iframe-cover" v-show="show">表示ボタンを押してね</div>
        </v-col>
      </v-row>
  </v-container>
</v-expand-transition>
</template>

<script>
import axios from 'axios';
export default {
  props: ['videoId', 'items', 'expand'],
  data(){
      return{
          apiKey: null,
          videoData: [],
          item: [],
          selectedMovieUrl: '',
          startTime: '',
          playingTime: '',
          endTime: '',
          show: true,
          sTimes: [
              { text: '0 : 10', value: '600'},
              { text: '0 : 30', value: '1800'},
              { text: '1 : 00', value: '3600'},
              { text: '1 : 30', value: '5400'},
          ],
          pTimes: [
              { text: '10 mim', value: '10'},
              { text: '20 mim', value: '1200'},
              { text: '30 mim', value: '1800'},
              { text: '1 h',    value: '3600'},
          ],
          heartColor: null,
          heartIcon: "mdi-heart-outline",
      };
  },
  watch: {
      videoId: function(){
                    let that = this;
                    const url = 'http://localhost/videos/' + this.videoId;
            
                    axios.get(url, {withCredentials: true} )
                    .then(function (response) {
                        that.videoData = response.data;
                        console.log(that.videoData);
                    })
                    .catch(function (error) {
                        console.log(error);
                    })
                    for(let i = 0;i < this.items.length; i++){
                        if(this.items[i].snippet.resourceId.videoId == this.videoId){
                            this.item = this.items[i];
                        }
                    }
                }
  },
  methods: {
    // 開始時間と再生時間の和を終了時間としてendTimeに代入している
    EndTime(){
            this.endTime = Number(this.startTime) + Number(this.playingTime);
    },
    Resume(){
        this.selectedMovieUrl= 'https://www.youtube.com/embed/' + this.item.snippet.resourceId.videoId
                                + '?start=' + this.startTime
                                + '&end=' + this.endTime;

        if(this.show == true){this.show = false;}  //初めて表示ボタンを押す時には.iframe-coverを外す。
    },
    addFavorite(){
      if(this.heartIcon == "mdi-heart-outline"){
          this.heartIcon = "mdi-heart";
          this.heartColor = "pink";
      }else{
          this.heartIcon = "mdi-heart-outline";
          this.heartColor = null;
      }
    },
  }
}

</script>

<style scoped>
 .select-btn label {
     background-color: #f5f5f5;
     padding: 6px 4px;
     border-radius: 4%;
 }
 .fav-btn, .select-btn, .resume-btn {
     margin: 15px 0;
     user-select:none;
 }
  img {
      height:198px;
      width:352px;
  }

  .container {
      margin-bottom: 50px;
      position: relative;
  }
  .close-btn {
      position:absolute;
      top: -13px;
      right: -13px;
  }
   .iframe {
       position:relative;
   }
   .iframe-cover {
       position:absolute;
       top: 0;
       left: 0;
       background-color: #c0c0c0;
       width:560px;
       height: 315px;
       margin-left: 12px;
       margin-top: 12px;
       text-align: center;
   }
</style>