<template>
    <v-main>
        <h2>{{ userData.name }}</h2>
        <h2>{{ userData.email }}</h2>
    </v-main>
</template>

<script>
export default {
    data(){
        return{
            userData: this.$route.params.data.current_user,
        }
    },
}
</script>