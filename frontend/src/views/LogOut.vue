<script>
import axios from 'axios'
export default {
    data(){
        return{
            data: null,
        }
    },
    created(){
        let that = this;
        let result = confirm('ログアウトしますか？');
        if( result ){
            axios.delete('http://localhost/login', {withCredentials: true} )
            .then(function (response) {
                that.data = response.data;
                console.log(that.data);
                that.$emit('logged-in-data', that.data);
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