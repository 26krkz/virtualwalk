<template>
    <div></div>
</template>
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
        const url = 'http://localhost/login';
        let params = {session: {email: this.email,
                                password: this.password,
                                remember_me: false
                               }
                      };

        axios.post( url, params, {withCredentials: true} )
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