<template>
  <v-app>
  <header>
    <Header></Header>
  </header>

  <router-view/>
  </v-app>
</template>

<script>
import Header from "./components/Header"
export default {
  components: {
    Header,
  }
}
</script>