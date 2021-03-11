<template>
    <div>
        <h2>お気に入り Top 5</h2>
        <div v-for="item of items" v-bind:key="item.id">
            <img @click="selectMovie" :src="item.snippet.thumbnails.medium.url">
        </div>
    </div>

</template>

<script>
export default {
    props: ['items'],
    methods: {
        selectMovie(){
            this.$emit('change-marker-num', 1);
        }
    }
}
</script>

<style scoped>
 img {
     width: 260px;
 }
</style>