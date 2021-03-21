<script>
import axios from 'axios'
export default {
    data(){
        return {
            email: 'guest@gmail.com',
            password: 'guestuser',
            info: null,
        }
    },
    created(){
        let that = this;
        axios.post('http://localhost/login',
                    {session: {email: that.email,
                                password: that.password,
                                remember_me: false
                               }
                    },
                    {withCredentials: true}
                   )
        .then(function (response) {
            that.info = response.data;
            that.$emit('logged-in-info', that.info);
            that.$router.push({ name: 'Home'})
        })
        .catch(function (error) {
            console.log(error);
        })
    }
}
</script>