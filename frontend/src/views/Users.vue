<template>
    <v-main>
        <h1>{{ user.name }}</h1>
        <h1>{{ user.email }}</h1>
    </v-main>
</template>

<script>
// import axios from 'axios'

export default {
    props: ['id'],
    data(){
        return{
            user: null,
        }
    },
    mounted(){
        
    },
}
</script>