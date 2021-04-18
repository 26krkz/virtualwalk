<template>
    <div></div>
</template>
<script>
import axios from 'axios'
export default {
    data(){
        return{
            info: null,
        }
    },
    created(){
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/login';
        let result = confirm('ログアウトしますか？');
        if( result ){
            axios.delete(url, {withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' }} )
            .then(function (response) {
                that.info = response.data;
                that.$emit('logged-in-info', that.info);
                that.$router.push({ name: 'Home'})
            })
            .catch(function (error) {
            console.log(error);
            })
        }else{
            this.$router.push({ name: 'Home'})
        }

    }
}
</script>