<template>
  <v-app>
  <header>
    <v-app-bar app color="cyan" dark>

      <router-link to="/" class="home-btn ml-5">
        <h1>virtualwalk</h1>
      </router-link>

      
      <v-spacer></v-spacer>


      <v-btn text>
        <span class="mr-3">how to use</span>
      </v-btn>

    <!-- ログインしていた場合表示されるnav -->
      <div v-if="loggedInUser">

        <router-link :to="{ name: 'User', params: { username: userName, info: info }}"
                      class="nav-btn mr-3">
          <v-btn text >{{ userName }}</v-btn>
        </router-link>

        <router-link to="/logout" class="nav-btn mr-3" >
          <v-btn text >log out</v-btn>
        </router-link>
      </div>

    <!-- ログインしていない場合表示されるnav -->
      <div v-else>
        <router-link to="/guest" class="nav-btn mr-3">
          <v-btn text>ゲストユーザーでログイン</v-btn>
        </router-link>

        <router-link to="/signup" class="nav-btn mr-3">
          <v-btn text>sign up</v-btn>
        </router-link>

        <router-link to="/login" class="nav-btn mr-3">
          <v-btn text>log in</v-btn>
        </router-link>
      </div>

    </v-app-bar>
  </header>

    <!-- error or messageがあったらスナックバーを表示する -->
    <v-snackbar
      class="snackbar"
      v-model="snackbar" 
      color="success"
      top
      right
      elevation="7"
      transition="slide-x-reverse-transition"
      timeout="3000"
    >
      <span>{{ snackbarText }}</span>
    </v-snackbar>

  <router-view @logged-in-info="loggedInInfo"></router-view>
  </v-app>
</template>

<script>
import axios from 'axios';
export default {
  data(){
    return{
      snackbar: false,
      snackbarText: 'sample',
      info: null,
      loggedInUser: false,
      userName: ''
    }
  },
  created(){
    // アプリを開いた時にログイン済みかどうか確認する
    let that = this;
        axios.get('http://localhost/login', { withCredentials: true })
        .then(function (response) {
            that.info = response.data;
            that.loggedInUser = that.info.loggedIn;
            that.userName = that.info.current_user.name;
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
        this.userName = this.info.current_user.name;
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
 .home-btn, .nav-btn {
   color: #fff;
   text-decoration: none;
 }
 .snackbar {
   position:absolute;
   top:5px;
 }
</style>