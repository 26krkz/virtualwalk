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
        <v-btn text >
          <span class="mr-3">{{ userName }}</span>
        </v-btn>

        <router-link to="/logout" class="nav-btn mr-3" >
          <v-btn text >log out</v-btn>
        </router-link>
      </div>

    <!-- ログインしていない場合表示されるnav -->
      <div v-else>
        <router-link to="/users/guest" class="nav-btn mr-3">
          <v-btn text>ゲストユーザーでログイン</v-btn>
        </router-link>

        <router-link to="/signup" class="nav-btn mr-3">
          <v-btn text>sign up</v-btn>
        </router-link>

        <router-link to="/signin" class="nav-btn mr-3">
          <v-btn text>log in</v-btn>
        </router-link>
      </div>

    </v-app-bar>
  </header>

  <router-view @logged-in-data="loggedInData"></router-view>
  </v-app>
</template>

<script>
export default {
  data(){
    return{
      data: null,
      loggedInUser: false,
      userName: ''
    }
  },
  methods: {
    loggedInData(e){
      this.data = e;
      this.loggedInUser = this.data.loggedIn;
      this.userName = this.data.current_user.name;
      
    }
  }
}
</script>

<style scoped>
 .home-btn, .nav-btn {
   color: #fff;
   text-decoration: none;
 }
</style>