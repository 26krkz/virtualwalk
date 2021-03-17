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
          <span class="mr-3">user</span>
        </v-btn>

        <v-btn text>
          <span class="mr-3">log out</span>
        </v-btn>
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

  <router-view @logged-in="loggedIn"></router-view>
  </v-app>
</template>

<script>
export default {
  data(){
    return{
      loggedInUser: false,
    }
  },
  methods: {
    loggedIn(e){
      this.loggedInUser = e;
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