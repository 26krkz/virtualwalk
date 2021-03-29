<template>
    <div>
        <h2>お気に入り Top 5</h2>
        <div class="scrollArea">
        <div v-for="item of items" v-bind:key="item.id">
            <img @click="selectMovie" :src="item.snippet.thumbnails.medium.url">
        </div>
        </div>
    </div>

</template>

<script>
export default {
    props: ['items'],
    methods: {
        selectMovie(){
            this.$emit('select-video-id', 1);
        }
    }
}
</script>

<style scoped>
 img {
     width: 260px;
 }
 .scrollArea{
	height: 570px;
	overflow: auto;
	padding-right: 20px;
}
/*スクロールバーの横幅指定*/
/* .scrollArea.deco::-webkit-scrollbar {
    width: 15px;
} */
/*スクロールバーの背景色・角丸指定*/
/* .scrollArea.deco::-webkit-scrollbar-track {
  border-radius: 10px;
	background: #f2f2f2;
} */
/*スクロールバーの色・角丸指定*/
/* .scrollArea.deco::-webkit-scrollbar-thumb {
  border-radius: 10px;
	background:#09C9D9;
} */
</style>