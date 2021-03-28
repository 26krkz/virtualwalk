<template>
<v-expand-transition>
  <v-container v-show="expand" class="container grey lighten-3">
      <v-btn class="close-btn" color="black" icon small outlined @click="expand = !expand">
          <v-icon>mdi-window-close</v-icon>
      </v-btn>
      <v-row>
        <v-col cols='4' class="select-movie">
            <img v-bind:src="item.snippet.thumbnails.medium.url">
            <p><v-icon small color="orange">mdi-tag</v-icon>{{ videoData.country }}</p>
            <p><v-icon small color="orange">mdi-tag</v-icon>{{ videoData.region }}</p>
        </v-col>
        <v-col cols='2'>

            <v-btn v-show="show1" block @click="pressFavoriteBtn">
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
            <select id="playing" v-model="playingTime" v-on:change="getEndTime">
                <option selected>指定しない</option>
                <option v-for="pTime in pTimes" v-bind:key="pTime.id" v-bind:value="pTime.value">
                    {{ pTime.text }}
                </option>
            </select>
            </label>
            </div>

            <v-btn block class="resume-btn" @click="resume">表示</v-btn>
        </v-col>
        <v-col class="iframe" cols='6'>
            <iframe width="560" height="315" 
                v-bind:src="selectedMovieUrl" frameborder="0" allowfullscreen>
            </iframe>
            <div class="iframe-cover" v-show="show2">表示ボタンを押してね</div>
        </v-col>
      </v-row>
      <!-- お気に入りに加えたらスナックバーを表示する -->
    <v-snackbar
      class="snackbar"
      v-model="snackbar" 
      color="cyan"
      elevation="7"
      transition="scroll-y-reverse-transition"
      timeout="1500"
      absolute
    >
      <span>{{ snackbarText }}</span>
    </v-snackbar>
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
          current_user: null,
          videoData: null,
          item: [],
          show1: false,
          show2: true,
          heartColor: null,
          heartIcon: "mdi-heart-outline",
          snackbar: false,
          snackbarText: '',
          selectedMovieUrl: '',
          startTime: '',
          playingTime: '',
          endTime: '',
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
      };
  },
  created(){
    // アプリを開いた時にログイン済みかどうか確認する。
    // ログイン済みの場合のみ（jsonにcurrent_userが含まれる）、current_userを取得＋お気に入りボタンを表示
    let that = this;
        axios.get('http://localhost/login', { withCredentials: true })
        .then(function (response) {
            const info = response.data;
            if(info.current_user){
              that.current_user = info.current_user;
              that.show1 = true;
            }
        })
        .catch(function (error) {
        console.log(error);
        })
  },
  watch: {
    //   マップ上のマーカーが押されpropsで取得したvideoIdが更新されるたびに以下を実行
      videoId: function(){
                    let that = this;
                    //一度お気に入りボタンのハートを透明にする。つまりマップのマーカーを押すたびにハートを透明にする。
                    this.heartIcon = "mdi-heart-outline";
                    this.heartColor = null;

                    //    videoIdを元にdb上のvideoテーブルからvideoIdと一致するvideo_idをもつデータを取得
                    //    データ取得後、propsで取得したyoutubeのプレイリストの動画の中から取得したデータと一致する動画をitemに格納
                    const url = 'http://localhost/videos/' + this.videoId;
            
                    axios.get(url, {withCredentials: true} )
                    .then(function (response) {
                        that.videoData = response.data;
                        if( that.current_user != null){
                            that.whetherAddedFavorite();
                        }
                    })
                    .catch(function (error) {
                        console.log(error);
                    })
                    for(let i = 0;i < this.items.length; i++){
                        if(this.items[i].snippet.resourceId.videoId == this.videoId){
                            this.item = this.items[i];
                        }
                    }
                },
  },
  methods: {
    // 開始時間と再生時間の和を終了時間としてendTimeに代入している
    getEndTime(){
            this.endTime = Number(this.startTime) + Number(this.playingTime);
    },
    resume(){
        this.selectedMovieUrl= 'https://www.youtube.com/embed/' + this.item.snippet.resourceId.videoId
                                + '?start=' + this.startTime
                                + '&end=' + this.endTime;

        if(this.show2 == true){this.show2 = false;}  //初めて表示ボタンを押す時には.iframe-coverを外す。
    },
    whetherAddedFavorite(){
         // ログインしているユーザーがお気に入りした全ての動画のvideo_idを取得し、その中に選択した動画のidがあるか調べる。
         // あればお気に入り登録されているのでハートマークを赤色に、なければそのままにする。
        let that = this;
        console.log(that.videoData.id);
        axios.get('http://localhost/users/favorites', {withCredentials: true} )
        .then(function (response) {
            let favoriteList = response.data;
            for(let i = 0;i < favoriteList.length; i++){
                if(favoriteList[i].id == that.videoData.id){
                    that.heartIcon = "mdi-heart";
                    that.heartColor = "pink";
                }
            }
        })
        .catch(function (error) {
            console.log(error);
        })
    },
    pressFavoriteBtn(){
      if(this.heartIcon == "mdi-heart-outline"){
          this.heartIcon = "mdi-heart";
          this.heartColor = "pink";
          this.addFavorite();
      }else{
          this.heartIcon = "mdi-heart-outline";
          this.heartColor = null;
          this.removeFavorite();
      }
    },
    addFavorite(){
        //お気に入りに登録したら、ログインしているユーザーとその動画をaxios.postによりfavoritesテーブルに登録する
        let that = this;
        const url = 'http://localhost/favorite';
        let params = {user_id: this.current_user.id,
                      video_id: this.videoData.id
                      };
        axios.post( url, params, { withCredentials: true })
        .then(function (response) {
            that.snackbarText = response.data.message;
        })
        .catch(function (error) {
            console.log(error);
        })    
        //snackbarを表示。表示して消えた後、再びsnackbarをfalseにセットする
        this.snackbar = true;
        setTimeout(function(){
            that.snackbar = false;
        }, 2000);
    },
    removeFavorite(){
        //既にお気に入りに登録している場合、favoritesテーブルのuser_idとvideo_idの一致するデータを削除する。
        let that = this;
        const url = 'http://localhost/favorite';
        let params = { data: { video_id: this.videoData.id, user_id: this.current_user.id } };
        axios.delete( url, params, { withCredentials: true })
        .then(function (response) {
            that.snackbarText = response.data.message;
            console.log(response.data)
        })
        .catch(function (error) {
            console.log(error);
        })
        //snackbarを表示。表示して消えた後、再びsnackbarをfalseにセットする
        this.snackbar = true;
        setTimeout(function(){
            that.snackbar = false;
        }, 2000);
    }
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