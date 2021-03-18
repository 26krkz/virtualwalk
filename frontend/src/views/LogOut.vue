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
        axios.delete('http://localhost/login')
        .then(function (response) {
            that.data = response.data;
            console.log(that.data);
            that.$emit('logged-in', that.data.loggedIn);
            that.$router.push({ name: 'Home'})
        })
        .catch(function (error) {
        console.log(error);
        })

    }
}
</script>