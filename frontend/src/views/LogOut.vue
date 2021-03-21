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
        let result = confirm('ログアウトしますか？');
        if( result ){
            axios.delete('http://localhost/login', {withCredentials: true} )
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