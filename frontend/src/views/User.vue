<template>
<v-main class="main-container">
    <v-card class="user-card" width="450" elevation="1">
        <div class="user-info">
            <div class="user-info--name">
                <div>ユーザー名：</div>
                <div v-show="!temporaryUserData">{{ userData.name }}</div>
                <div v-show="temporaryUserData">{{ temporaryUserDataName }}</div>
            </div>
            <div class="user-info--email">
                <div>メールアドレス：</div>
                <div class="email-invisible" v-show="!show1" @click="isVisible">
                    <div class="invisible-icon"><v-icon>mdi-eye-off</v-icon></div>
                    <div>***********</div>
                </div>
                <div class="email-visible" v-show="show1" @click="isVisible">
                    <div class="visible-icon"><v-icon>mdi-eye</v-icon></div>
                    <div v-show="!temporaryUserData">{{ userData.email }}</div>
                    <div v-show="temporaryUserData">{{ temporaryUserDataEmail }}</div>
                </div>
            </div>
        </div>
        <v-btn class="update-user-btn" @click="expand1 = !expand1">プロフィールを変更</v-btn>
        <v-btn class="delete-user-btn" @click="deleteAccount">退会する</v-btn>
        <v-expand-transition>
            <v-card class="form-container" width="260" v-show="expand1" >
                <!-- submit.preventによりsubmitボタンを押してもページがリロードされるのを防ぐ -->
                <v-form
                ref="form"
                @submit.prevent="updateAccount"
                >
                    <v-container>
                        <v-row class="mr-3 ml-3">
                            <!-- ユーザーネームの登録 -->
                            <v-col cols="12" >
                                <v-text-field
                                calss="text-field"
                                v-model="form.userName"
                                label="User name"
                                :rules="rules.name"
                                required
                                ></v-text-field>
                            </v-col>

                            <!-- メールアドレスの登録 -->
                            <v-col cols="12">
                                <v-text-field
                                class="text-field"
                                v-model="form.email"
                                :rules="[rules.requiredEmail, rules.email]"
                                label="E-mail"
                                ></v-text-field>
                            </v-col>

                            <v-btn class="btn" @click="expand2 = !expand2">パスワードを変更</v-btn>

                            <v-expand-transition>
                                <div v-show="expand2">
                                    <!-- パスワードの登録 -->
                                    <v-col cols="12">
                                        <v-text-field
                                        class="text-field"
                                        v-model="form.password1"
                                        :append-icon="show2 ? 'mdi-eye' : 'mdi-eye-off'"
                                        :rules="[rules.requiredPassword, rules.min]"
                                        :type="show2 ? 'text' : 'password'"
                                        label="Password"
                                        counter
                                        @click:append="show2 = !show2"
                                        ></v-text-field>
                                    </v-col>

                                    <!-- パスワードの確認 -->
                                    <v-col cols="12">
                                        <v-text-field
                                        class="text-field"
                                        v-model="form.password2"
                                        :append-icon="show3 ? 'mdi-eye' : 'mdi-eye-off'"
                                        :rules="[rules.issame]"
                                        :type="show3 ? 'text' : 'password'"
                                        label="Password(確認)"
                                        @click:append="show3 = !show3"
                                        ></v-text-field>
                                    </v-col>
                                </div>

                            </v-expand-transition>
                        </v-row>
                    </v-container>
                    <!-- キャンセルと登録ボタン、登録ボタンはformIsValidを満たした時にdisabledが外れる。 -->
                    <v-card-actions>
                        <v-btn
                        text
                        @click="resetForm"
                        >
                        キャンセル
                        </v-btn>
                        <v-spacer></v-spacer>
                        <v-btn
                        :disabled="!formIsValid"
                        text
                        color="primary"
                        type="submit"
                        >
                        変更する
                        </v-btn>
                    </v-card-actions>
                </v-form>
            </v-card>
        </v-expand-transition>
    </v-card>
    <div class="favorites">
        <div class="favorites-title">お気に入り一覧</div>
        <div class="border">
            <div class="favorite-videos">
                <div v-for="n of 5" :key="n">
                    <v-card class="favorite-video-img">
                        <img src="https://placehold.jp/320x180.png?text=virtualwalk" v-show="show4">
                    </v-card>
                </div>
                <div v-show="showDummy">
                    <v-card class="favorite-video-img-dummy">
                        <div class="img-dummy"><div>お気に入りに追加すると<br>動画が表示されます。</div></div>
                    </v-card>
                </div>
                <div v-for="favoriteVideo of favoriteVideos" v-bind:key="favoriteVideo.id">
                    <v-card class="favorite-video-img" :id="favoriteVideo.snippet.resourceId.videoId">
                        <img :src="favoriteVideo.snippet.thumbnails.medium.url"       
                            @click="showSelectedVideo(favoriteVideo.snippet.resourceId.videoId)"
                        >
                    </v-card>
                </div>
            </div>
        </div>
    </div>
    <div class="memo-component">
        <Memo v-show="expand" @get-customized-times="getCustomizedTimes" @select-time="selectTime" :video-id='videoId' :user-data='userData'></Memo>
    </div>
    <div class="youtube-component">
      <v-btn class="close-btn" v-show="expand" @click="expand = !expand" small>close</v-btn>
        <v-card>
          <Youtube @deleted-favorite-video-id='deletedFavoriteVideoId' :video-id='videoId' :expand='expand' :customizedTimes="customizedTimes" :selectedTime="selectedTime"></Youtube>
        </v-card>
      </div>
</v-main>
</template>

<script>
import Youtube from '../components/Youtube';
import Memo from '../components/Memo';
import axios from 'axios'
  export default {
    data () {
    //   Object.freezeにより以降オブジェクトの変更を防ぎ空のオブジェクトを保つ
      const defaultForm = Object.freeze({ userName: '', email: '', password1: '', password2: '' })

      return {
        customizedTimes: "",
        selectedTime: "",
        delteFavoriteId: "",
        temporaryUserData: false,
        temporaryUserDataName: "",
        temporaryUserDataEmail: "",
        expand1: false,
        expand2: false,
        userData: this.$route.params.current_user,
        snackbar: false,
        show1: false,
        show2: false,
        show3: false,
        show4: true,
        showDummy: false,
        info: null,
        videoId: '',
        items: [],
        expand: null,
        favoriteList: null,
        favoriteVideos: [],
        defaultForm,
        form: Object.assign({}, this.defaultForm),
        //ユーザー登録欄のバリデーション
        rules: {
          name: [value => (value || '').length > 0 || 'user nameは必須です'],
          email: value => {
            const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            return pattern.test(value) || '有効なメールアドレスを入力してください'
          },
          requiredEmail: value => !!value || 'e-mailは必須です',
          requiredPassword: value => !!value || 'passwordは必須です',
          min: value => value&&value.length >= 6 || '6字以上で作成してください',
          issame: value => value == this.form.password1 || '同じパスワードを入力してください',
        },
        //youtubeから指定のプレイリストの動画を取得するのに必要なparams
        getPlayListParams: {
            part: 'snippet',
            maxResults: 50,
            playlistId: process.env.VUE_APP_YOUTUBE_PLAYLIST_ID, /*Youtubeのplaylist id*/
            key: process.env.VUE_APP_YOUTUBE_API_KEY
        },
      }
    },
    watch: {
        // Youtubeコンポーネントでお気に入りから動画を削除すると、$emitによって削除した動画のIDが渡され、対応する動画のimgが削除される。
        delteFavoriteId: function() {
            let deleteItem = document.getElementById(this.delteFavoriteId);
            deleteItem.remove();
        }
    },
    created(){
        let that = this;

        // YoutubeAPIにより指定プレイリストの動画を取得し、それらをitemsにいれる
        axios.get('https://www.googleapis.com/youtube/v3/playlistItems', { params: that.getPlayListParams })
        .then(function (response) {
            that.items = response.data.items;
            that.getFavoriteList();
        })
        .catch(function (error) {
        console.log(error);
        })
    },
    computed: {
      formIsValid () {
        return (
          this.form.userName &&
          this.form.email 
        )
      },
    },
    methods: {
      isVisible(){
          if(this.show1){
              this.show1 = false;
          }else{
              this.show1 = true;
          }
      },
      resetForm () {
        this.form = Object.assign({}, this.defaultForm)
        this.$refs.form.reset()
      },
      //ユーザーアカウントの更新メソッド
      updateAccount() {
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/users/' + this.userData.id;
        const params =  {user: {name: this.form.userName,
                                email: this.form.email,
                                password: this.form.password1,
                                password_confirmation: this.form.password2
                                }
                        };
        this.temporaryUserData = true;
        this.temporaryUserDataName = this.form.userName;
        this.temporaryUserDataEmail = this.form.email;
    
        axios.patch( url, params, { withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' }})
        .then(function (response) {
            that.info = response.data;
            that.$emit('logged-in-info', that.info);
        })
        .catch(function (error) {
            console.log(error);
        })    

        this.resetForm()
      },
      //ユーザーの退会メソッド
      deleteAccount(){
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/users/' + this.userData.id;
        let result = confirm('退会するとアカウントが削除されますがよろしいですか？');
        if( result ){
            axios.delete( url, {withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' }})
            .then(function (response) {
                that.info = response.data;
                that.$emit('logged-in-info', that.info);
                that.$router.push({ name: 'Home'})
            })
            .catch(function (error) {
            console.log(error);
            })
        }else{
            this.$router.push({ name: 'User'})
        }
       },
       //dbのfavoritesテーブル取得メソッド
       getFavoriteList(){
        //Youtuebeからプレイリストを取得した後、続けてdbのfavoritesテーブルからログインユーザーのお気に入りした動画のidを取得しfavoriteListにいれる
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/users/favorites';

        axios.get(url, {withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' }} )
        .then(function (response) {
            that.show4 = false;
            if(response.data.message){
                that.showDummy = true;
            }
            that.favoriteList = response.data;
            that.compareFavoriteListAndItems();
        })
        .catch(function (error) {
            console.log(error);
        })
       },
       //お気に入りした動画データの取得メソッド
       compareFavoriteListAndItems(){
           //YoutubeAPIで取得したプレイリストとgetFavoriteList()で取得したデータを照らし合わせることで
           //プレイリストの中のユーザーがお気に入りに入れた動画の情報のみを取得。取得したデータはfavoriteVideosに入れていく。
           for(let i = 0; this.favoriteList&&this.favoriteList.length > i; i++){
               for(let j = 0; this.items&&this.items.length > j; j++){
                   let favorite = this.favoriteList[i].video_id;
                   let item = this.items[j].snippet.resourceId.videoId;
                   if(favorite == item){
                       this.favoriteVideos.push(this.items[j]);
                   }
               }
           }
       },
       showSelectedVideo(videoId){
           this.videoId = videoId;
           this.expand = true;
       },
       getCustomizedTimes(e){
            this.customizedTimes = e;
        },
        selectTime(e) {
            this.selectedTime = e;
        },
        deletedFavoriteVideoId(e) {
            this.delteFavoriteId = e;
        }
    },
    components: {
        Youtube,
        Memo,
    }
  }
</script>

<style scoped>
.main-container {
     margin: 30px 3vw;
 }
.user-card {
    margin-bottom: 25px;
    padding: 25px;
 }
.user-info--name, .user-info--email, .email-invisible, .email-visible{
    display: flex;
    flex-wrap: wrap;
 }
 .user-info {
     font-size: 1rem;
     margin-bottom: 10px;
 }
 .email-invisible, .email-visible {
     cursor: pointer;
     user-select: none;    
 }
 .visible-icon, .invisible-icon {
     margin-right: 0.2rem;
 }
 .update-user-btn, .delete-user-btn {
     margin-bottom: 10px;
     margin-right: 20px;
 } 
 .text-field {
     padding: 0;
 }
 .favorites {
     margin-bottom: 35px;
 }
 .favorites-title {
     font-size: 1.5rem;
     font-weight: bold;
     color: #FF9800;
     margin-bottom: 15px;
 }
 .border {
     border-top: 3px solid #e0e0e0;
     border-bottom: 3px solid #e0e0e0;
 }
 .favorite-videos {
     display:flex;
     overflow-x:scroll;
 }
 .favorite-video-img-dummy {
     height: 180px;
     margin: 5px 0.5vw 5px 0;
 }
 .img-dummy {
     height: 180px;
     width: 320px;
     background-color: #c0c0c0;
 }
 .img-dummy div {
     padding-top: 70px;
     text-align: center;
 }
 .favorite-video-img {
     cursor: pointer;
     height: 180px;
     margin: 5px 0.5vw 5px 0;
 }
 .memo-component {
     width: 80%;
     margin: 0 auto;
     margin-bottom: 45px;;
 }
 .youtube-component {
    width: 95%;
    margin:0 auto;
    position: relative;
  }
 .close-btn {
    position: absolute;
    top: -24px;
    right: 0;
    background-color: #eee;
    border-radius: 0;
  }
 @media screen and (max-width:400px){
    .user-info {
        font-size: 0.8rem;
    }
    .main-container {
     margin: 30px 0.5vw;
    }
 }
 @media screen and (min-width: 960px) {
     .memo-component {
        width: 65%;
     }
 }
</style>