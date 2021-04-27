<template>
  <v-app class="body">
  <header>
    <v-app-bar app color="cyan" dark>

      <div class="d-md-none">
        <v-btn icon @click="drawer = !drawer">
          <v-icon>mdi-menu</v-icon>
        </v-btn>
      </div>

      <v-spacer class="d-md-none"></v-spacer>

      <router-link to="/" class="home-btn">
        <h1>virtualwalk</h1>
      </router-link>

      
      <v-spacer></v-spacer>

      <nav class="d-none d-md-flex">
        <router-link to="/about" class="nav-btn" >
            <v-btn text >how to use</v-btn>
          </router-link>

        <!-- ログインしていた場合表示されるnav -->
        <div v-if="loggedInUser">

          <router-link :to="{ name: 'User', params: { username:current_user.name, current_user:current_user }}"
                        class="nav-btn">
            <v-btn text >{{ current_user.name }}</v-btn>
          </router-link>

          <router-link to="/logout" class="nav-btn" >
            <v-btn text >log out</v-btn>
          </router-link>
        </div>

        <!-- ログインしていない場合表示されるnav -->
        <div v-else>
          <router-link to="/guest" class="nav-btn">
            <v-btn text>ゲストユーザーでログイン</v-btn>
          </router-link>

          <router-link to="/signup" class="nav-btn">
            <v-btn text>sign up</v-btn>
          </router-link>

          <router-link to="/login" class="nav-btn">
            <v-btn text>log in</v-btn>
          </router-link>
        </div>

      </nav>

    </v-app-bar>
  </header>

    <!-- error or messageがあったらスナックバーを表示する -->
    <v-snackbar
      class="snackbar"
      v-model="snackbar" 
      :color="snackbarColor"
      top
      right
      elevation="7"
      transition="slide-x-reverse-transition"
      timeout="3000"
    >
      <span>{{ snackbarText }}</span>
    </v-snackbar>
    <!-- 画面のwidthが960px以下になったらハンバーガーメニューとdrawerでnavを表示する。 -->
    <v-navigation-drawer
      class="navigation-drawer"
      v-model="drawer"
      temporary
      absolute
      dark
      color="cyan"
    >
        <div>
          <v-btn class="arrow-left" icon @click="drawer = !drawer">
            <v-icon>mdi-arrow-left</v-icon>
          </v-btn>
        </div>
        <div>
          <router-link to="/about" class="nav-btn" >
              <v-btn text >how to use</v-btn>
            </router-link>
        </div>

        <!-- ログインしていた場合表示されるnav -->
        <div v-if="loggedInUser">
          <div>
            <router-link :to="{ name: 'User', params: { username:current_user.name, current_user:current_user }}"
                          class="nav-btn">
              <v-btn text >{{ current_user.name }}</v-btn>
            </router-link>
          </div>
          <div>
            <router-link to="/logout" class="nav-btn" >
              <v-btn text >log out</v-btn>
            </router-link>
          </div>
        </div>

        <!-- ログインしていない場合表示されるnav -->
        <div v-else>
          <div>
            <router-link to="/guest" class="nav-btn">
              <v-btn text>ゲストユーザーでログイン</v-btn>
            </router-link>
          </div>
          <div>
            <router-link to="/signup" class="nav-btn">
              <v-btn text>sign up</v-btn>
            </router-link>
          </div>
          <div>
            <router-link to="/login" class="nav-btn">
              <v-btn text>log in</v-btn>
            </router-link>
          </div>
        </div>
    </v-navigation-drawer>
    <router-view @logged-in-info="loggedInInfo"></router-view>
  </v-app>
</template>

<script>
import axios from 'axios';
export default {
  data(){
    return{
      drawer: false,
      snackbar: false,
      snackbarText: '',
      snackbarColor: '',
      info: null,
      loggedInUser: false,
      current_user: null
    }
  },
  created(){
    // アプリを開いた時にログイン済みかどうか確認する
    let that = this;
    const url = process.env.VUE_APP_API_BASE_URL + '/login';
        axios.get(url, { withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' } })
        .then(function (response) {
            that.info = response.data;
            if(that.info.current_user){
              that.loggedInUser = that.info.loggedIn;
              that.current_user = that.info.current_user;
            }
        })
        .catch(function (error) {
        console.log(error);
        })
  },
  methods: {
    loggedInInfo(e){
      this.info = e;
      this.loggedInUser = this.info.loggedIn;
      this.snackbarText = this.info.message;
      if(this.info.current_user){
        this.current_user = this.info.current_user;
        this.snackbarColor = 'green';
      }else{
        this.snackbarColor  = 'red';
      }
      this.snackbar = true;

      //snackbarが表示されて3秒後に消えた後、再びsnackbarをfalseにセットする
      let that = this;
      setTimeout(function(){
        that.snackbar = false;
      }, 4000);
    }
  }
}
</script>

<style scoped>
 .body {
   font-family: Helvetica, Arial, sans-serif;
   font-size: 0.875rem;
   max-width: 1500px;
   margin:0 auto;
 }
 .home-btn {
    margin-right: 48px;
    padding-left: 1vw;
 }
 .home-btn, .nav-btn {
   color: #fff;
   text-decoration: none;
 }
 .snackbar {
   position:absolute;
   top:5px;
 }
 .arrow-left {
   margin:10px;
 }
 @media screen and(max-width:960px){
   .home-btn {
     padding-left: 0;
   }
 }
</style>