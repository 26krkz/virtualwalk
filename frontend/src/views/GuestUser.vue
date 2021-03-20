<script>
import axios from 'axios'
export default {
    data(){
        return {
            email: 'guest@gmail.com',
            password: 'guestuser',
        }
    },
    mounted(){
        let that = this;
        axios.post('http://localhost/login',
                    {session: {email: that.email,
                                password: that.password,
                                remember_me: true
                               }
                    },
                    {withCredentials: true}
                   )
        .then(function (response) {
            that.data = response.data;
            console.log(that.data);
            that.$emit('logged-in-data', that.data);
            that.$router.push({ name: 'Home'})
        })
        .catch(function (error) {
            console.log(error);
        })
    }
}
</script>