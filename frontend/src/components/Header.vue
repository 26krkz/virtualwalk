<template>
    <v-app-bar
      app
      color="cyan"
      dark
    >
      <router-link to="/" class="home-btn ml-5">
        <h1>virtualwalk</h1>
      </router-link>
      <v-spacer></v-spacer>

      <v-btn text @click="user">
        <span class="mr-3">user</span>
      </v-btn>

      <router-link to="/users/guest" class="nav-btn mr-3">
        <v-btn text>ゲストユーザーでログイン</v-btn>
      </router-link>

      <v-btn text>
        <span class="mr-3">how to use</span>
      </v-btn>

      <router-link to="/signup" class="nav-btn mr-3">
        <v-btn text>sign up</v-btn>
      </router-link>
    
      <router-link to="/signin" class="nav-btn mr-3">
        <v-btn text>sign in</v-btn>
      </router-link>
    </v-app-bar>
</template>

<script>
import axios from 'axios'
export default {
  data(){
    return{
      id: 2,
    }
  },
  methods: {
    user(){
      let that = this;
        axios.get(`http://localhost/users/${ that.id }`)
        .then(function (response) {
            that.user = response.data;
            console.log(that.user);
        })
        .catch(function (error) {
        console.log(error);
        })
      
      this.$router.push({ path: `/users/${this.id}` })
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