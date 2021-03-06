<template>
<v-expand-transition>
  <v-container fluid v-show="expand" class="container grey lighten-3">
      <v-row>
        <v-col cols='12' md="4" class="selected-video">
            <div class="video-info">
                <div class="thumbnail-wrapper">
                    <div class="thumbnail">
                        <img v-bind:src="item.snippet.thumbnails.medium.url">
                    </div>
                </div>
                <div class="selected-video--tags">
                    <div class="tag"><v-icon small color="orange">mdi-tag</v-icon>{{ videoData.country }}</div>
                    <div class="tag"><v-icon small color="orange">mdi-tag</v-icon>{{ videoData.tag1 }}</div>
                    <div class="tag"><v-icon small color="orange">mdi-tag</v-icon>{{ videoData.region }}</div>
                    <div class="tag"><v-icon small color="orange">mdi-tag</v-icon>{{ videoData.time }}</div>
                </div>
            </div>
            <div class="customize-video">
                <v-btn class="fav-btn" :disabled="disable" @click="pressFavoriteBtn">
                    お気に入りに追加
                    <v-icon v-bind:color="heartColor">{{ heartIcon }}</v-icon>
                </v-btn>
                <div class="select-time">
                    <div class="select-time-start">
                    <!-- 開始時間を設定 -->
                    <label for="start">開始時間:
                    <select id="start" v-model="startTime">
                        <option v-for="sTime in sTimes" v-bind:key="sTime.id" v-bind:value="sTime.value">
                            {{ sTime.text }}
                        </option>
                    </select>
                    </label>
                    </div>
                
                    <div class="select-time-playing">
                    <!-- 再生時間を設定 -->
                    <label for="playing">再生時間:
                    <select id="playing" v-model="playingTime" v-on:change="getEndTime">
                        <option v-for="pTime in pTimes" v-bind:key="pTime.id" v-bind:value="pTime.value">
                            {{ pTime.text }}
                        </option>
                    </select>
                    </label>
                    </div>
                </div>

                <v-btn class="resume-btn" @click="resume">表示</v-btn>
            </div>
        </v-col>
        <v-col cols='12' md="8">
            <div class="iframe-wrapper">
                <iframe
                    v-bind:src="selectedMovieUrl"
                    frameborder="0"
                    allowfullscreen
                    class="iframe">
                </iframe>
                <div class="iframe-cover" v-show="show2">表示ボタンを押してね</div>
            </div>
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
  props: ['videoId', 'expand', 'customizedTimes', 'selectedTime'],
  data(){
      return{
          apiKey: null,
          current_user: null,
          videoData: null,
          items: [],
          item: [],
          disable: true,
          show2: true,
          heartColor: null,
          heartIcon: "mdi-heart-outline",
          snackbar: false,
          snackbarText: '',
          selectedMovieUrl: '',
          startTime: '0',
          playingTime: '',
          endTime: '',
          sTimes: [
              { text: '指定しない', value: '0'},
              { text: '0:10:00', value: '600'},
              { text: '0:15:00', value: '900'},
              { text: '0:30:00', value: '1800'},
              { text: '0:45:00', value: '2700'},
              { text: '1:00:00', value: '3600'},
              { text: '1:20:00', value: '4800'},
              { text: '1:40:00', value: '6000'},
              { text: '2:00:00', value: '7200'},
              { text: '2:20:00', value: '8400'},
              { text: '2:40:00', value: '9600'},
          ],
          pTimes: [
              { text: '指定しない', value: ''},
              { text: '10 mim', value: '600'},
              { text: '15 mim', value: '900'},
              { text: '20 mim', value: '1200'},
              { text: '30 mim', value: '1800'},
              { text: '40 mim', value: '2400'},
              { text: '50 mim', value: '3000'},
              { text: '1 h',    value: '3600'},
              { text: '1.5 h',  value: '5400'},
          ],
          //youtubeから指定のプレイリストの動画を取得するのに必要なparams
          getPlayListParams: {
            part: 'snippet',
            maxResults: 50,
            playlistId: process.env.VUE_APP_YOUTUBE_PLAYLIST_ID, /*Youtubeのplaylist id*/
            key: process.env.VUE_APP_YOUTUBE_API_KEY
          },
      };
  },
  created(){
    // アプリを開いた時にログイン済みかどうか確認する。
    // ログイン済みの場合のみ（jsonにcurrent_userが含まれる）、current_userを取得＋お気に入りボタンを表示
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/login';
        axios.get(url, { withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' } })
        .then(function (response) {
            const info = response.data;
            if(info.current_user){
              that.current_user = info.current_user;
              that.disable = false;
            }
        })
        .catch(function (error) {
        console.log(error);
        })

        // YoutubeAPIにより指定プレイリストの動画を取得し、それらをitemsにいれる
        axios.get('https://www.googleapis.com/youtube/v3/playlistItems', { params: that.getPlayListParams })
        .then(function (response) {
            that.items = response.data.items;
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

                    //videoIdを元にdb上のvideoテーブルからvideoIdと一致するvideo_idをもつデータを取得
                    const url = process.env.VUE_APP_API_BASE_URL + '/videos/' + this.videoId;
            
                    axios.get(url, {withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' }} )
                    .then(function (response) {
                        that.videoData = response.data;
                        if( that.current_user != null){
                            that.whetherAddedFavorite();
                        }
                        that.initializeStartTimes(response.data.time);
                    })
                    .catch(function (error) {
                        console.log(error);
                    })
                    //データ取得後、propsで取得したyoutubeのプレイリストの動画の中から取得したデータと一致する動画をitemに格納
                    for(let i = 0;i < this.items.length; i++){
                        if(this.items[i].snippet.resourceId.videoId == this.videoId){
                            this.item = this.items[i];
                        }
                    }
                },
      customizedTimes: function() {
                    this.initializeStartTimes(this.videoData.time);
                    this.getCustomizedTimes();
                },
      selectedTime: function () {
          let customizedTimes = document.getElementsByClassName('customized-time');
          for(let i = 0;i < customizedTimes.length; i++) {
              if (this.selectedTime == customizedTimes[i].innerText) {
                  customizedTimes[i].selected = true;
                  this.startTime = customizedTimes[i].value;
              }
          }
      }
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
    // ログインしているユーザーがお気に入りした全ての動画のvideo_idを取得し、その中に選択した動画のidがあるか調べる。
    // あればお気に入り登録されているのでハートマークを赤色に、なければそのままにする。
    whetherAddedFavorite(){
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/users/favorites';
        axios.get(url, {withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' }} )
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
          let result = confirm('お気に入りから削除すると動画のメモも削除されますがよろしいですか？');
          if(result){
              this.heartIcon = "mdi-heart-outline";
              this.heartColor = null;
              this.removeFavorite();
          }
      }
    },
    // お気に入りに登録したら、ログインしているユーザーとその動画をaxios.postによりfavoritesテーブルに登録する
    addFavorite(){
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/favorite';
        let params = {
                user_id: this.current_user.id,
                video_id: this.videoData.id
                };

        axios.post( url, params, { withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' } })
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
    // 既にお気に入りに登録している場合、favoritesテーブルのuser_idとvideo_idの一致するデータを削除する。
    removeFavorite(){
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/favorite';
        let params = {
                user_id: this.current_user.id,
                video_id: this.videoData.id
                };

        this.$emit('deleted-favorite-video-id', this.videoData.video_id);

        axios.delete( url, {params: params, withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' } })
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
    // propで渡ってきたcustomizedTimesを開始時間のselectのoptionとして追加している。
    getCustomizedTimes() {
        const select = document.getElementById('start');
        for (let i = 0; i < this.customizedTimes.length; i++) {
            let option = document.createElement('option');
            option.textContent = this.customizedTimes[i];
            option.value = this.getCustomizedTimeValue(this.customizedTimes[i]);
            option.classList.add('customized-time');
            select.appendChild(option);
        }
    },
    // propで渡ってきたcustomizedTimesは'XX:YY:ZZ'の文字列型だから、時間、分、秒で分けてミリ秒変換してリターンしoptionのvalueとして扱う。
    getCustomizedTimeValue(time) {
        let value = time.split(':');
        let hour = Number(value[0]);
        let minite = Number(value[1]);
        let second = Number(value[2]);
        return String(hour * 3600 + minite * 60 + second);
    },
    // 新たに動画を選択したり、新たにcustomizedTimesが渡ってきた時に開始時間のselectを空にして、optionを初期化している。
    // selectに追加するoptionは指定した動画の時間に応じて変更されるようになっている。setOption()
    initializeStartTimes(videoTime) {
        const select = document.getElementById('start');
        if(select.firstChild != null) {
            while(select.firstChild) {
                select.removeChild(select.firstChild);
            }
        }
        let time = videoTime.split(':');
        let hour = Number(time[0]);
        let minite = Number(time[1]);
        let second = Number(time[2]);
        let value = hour * 3600 + minite * 60 + second;

        this.setOption(value);
    },
    setOption(value) {
        const select = document.getElementById('start');
        for (let i = 0; i < this.sTimes.length; i++) {
            if( this.sTimes[i].value < value){
                let option = document.createElement('option');
                option.textContent = this.sTimes[i].text;
                option.value = this.sTimes[i].value;
                select.appendChild(option);
            }
        }
    }
  }
}

</script>

<style scoped>
 .container {
      margin-bottom: 30px;
      position: relative;
 }
 .selected-video {
       width:100%;
 }
 .thumbnail-wrapper {
     width:100%;
     padding-top:56.25%; 
     position:relative;
     margin-bottom: 5px;
 }
 .thumbnail img{
      position:absolute;
      top:0;
      width:100%;
      height: 100%;
      /* margin: 5px 0; */
 }
 .selected-video--tags {
      display:flex;
      flex-wrap: wrap;
      margin-bottom: 15px;
 }
 .tag {
      margin-right: 0.5rem;
  }
 .select-time {
     display: flex;
     user-select:none;
 }
 .select-time-start {
     margin-right: 0.5rem;
     margin-bottom: 15px;
 }
 .select-time-playing {
     margin-bottom: 15px;
 }
 .select-time-start label, .select-time-playing label {
     background-color: #f5f5f5;
     padding: 9px 4px;
     border-radius: 4%;
     font-size: 0.825rem;
 }
 .fav-btn, .resume-btn {
     width: 100%;
     margin-bottom: 15px;
     user-select:none;
 }

 .iframe-wrapper {
     width:100%;
     padding-top:56.25%; 
     position:relative;
 }
 .iframe {
     position: absolute;
     top: 0;
     width: 100%;
     height: 100%;
 }
 .iframe-cover {
      position:absolute;
      top: 0;
      background-color: #c0c0c0;
      text-align: center;
      width: 100%;
      height: 100%;
 }
 @media screen and (min-width:600px){
     .selected-video {
         display:flex;
     }
     .customize-video {
         margin: 20px 15px;
         width: 40%;
     }
     .select-time {
        display: grid;
     }
 }
 @media screen and (min-width: 960px) {
     .selected-video {
         display:grid;
     }
     .customize-video {
         margin: 0;
         width: 100%;
     }
      .select-time {
        display: flex;
     }
 }
   
   
</style>