<template>
  <v-main>
    <h3>Start virtualwalk</h3>
    <h1>Create your account</h1>

    <v-snackbar
      v-model="snackbar"
      absolute
      top
      right
      color="success"
    >
      <span>登録が完了しました！</span>
    </v-snackbar>

    <v-card class="form-container" width="300" height="350">
        <v-form
        ref="form"
        @submit.prevent="submit"
        >
            <v-container>
                <v-row class="mr-3 ml-3">
                    <v-col cols="12">
                        <v-text-field
                        calss="text-field"
                        v-model="form.userName"
                        label="User name"
                        :rules="rules.name"
                        required
                        ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                        <v-text-field
                        class="text-field"
                        v-model="form.email"
                        :rules="[rules.required, rules.email]"
                        label="E-mail"
                        ></v-text-field>
                    </v-col>
                    <v-col cols="12">
                        <v-text-field
                        class="text-field"
                        v-model="form.password"
                        :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
                        :rules="[rules.password.required, rules.password.min]"
                        :type="show ? 'text' : 'password'"
                        name="input-10-1"
                        label="Password"
                        hint="At least 8 characters"
                        counter
                        @click:append="show = !show"
                        ></v-text-field>
                    </v-col>
                </v-row>
            </v-container>
            <v-card-actions>
                <v-btn
                :disabled="!formIsValid"
                text
                color="primary"
                type="submit"
                >
                登録する
                </v-btn>
            </v-card-actions>
        </v-form>
    </v-card>
  </v-main>
</template>

<script>
  export default {
    data () {
      const defaultForm = Object.freeze({ userName: '', email: '', password: '' })

      return {
        snackbar: false,
        form: Object.assign({}, defaultForm),
        rules: {
          name: [value => (value || '').length > 0 || 'user nameは必須です'],
          email: value => {
            const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            return pattern.test(value) || 'Invalid e-mail.'
          },
          password: [{required: value => !!value || 'Required.'},
                     {min: v => v.length >= 8 || 'Min 8 characters'}],
        },
        defaultForm,
        show: false,
      }
    },

    computed: {
      formIsValid () {
        return (
          this.form.userName &&
          this.form.email &&
          this.form.password
        )
      },
    },

    methods: {
      resetForm () {
        this.form = Object.assign({}, this.defaultForm)
        this.$refs.form.reset()
      },
      submit () {
        this.snackbar = true
        this.resetForm()
      },
    },
  }
</script>

<style scoped>
 .form-container {
     /* width: 300px; */
     margin:0 auto;
 }
 .text-field {
     padding: 0;
 }
</style>