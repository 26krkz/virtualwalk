<template>
  <div>
    <v-menu class="search-container" offset-y>
      <template v-slot:activator="{ on }" class="template">
        <v-text-field
        class="search"
        solo
        placeholder="キーワードで検索（地域、国、都市名）"
        prepend-inner-icon="mdi-map-marker"
        v-model="sample"
        v-on="on"
        ></v-text-field>
      </template>
      <v-card class="result-container">
        <div>sample</div>
      </v-card>
    </v-menu>
  </div>
</template>
<script>
export default {
  data() {
    return {
      sample: ''
    }
  },
  watch: {
    sample: function() {
      if (this.sample != '') {
        let keyword = this.sample;
        let greet = 'hello';
        if (greet.indexOf(keyword) > -1) {
          console.log('hello');
        }
      }
    }
  }
}
</script>
<style scoped>
  .search {
    max-width: 400px;
  }
</style>