<template>
  <v-main>
    <div class="signup-top">
        <h4>Start virtualwalk</h4>
        <h1>Create your account!</h1>
    </div>
    
    <!-- 登録フォーム -->
    <v-card class="form-container" width="300">
        <!-- submit.preventによりsubmitボタンを押してもページがリロードされるのを防ぐ -->
        <v-form
        ref="form"
        @submit.prevent="submit"
        >
            <v-container>
                <v-row class="mr-3 ml-3">
                    <!-- ユーザーネームの登録 -->
                    <v-col cols="12">
                        <v-text-field
                        calss="text-field"
                        v-model="form.userName"
                        label="User name"
                        :rules="rules.name"
                        required
                        ></v-text-field>
                    </v-col>

                    <!-- メールアドレスの登録 -->
                    <v-col cols="12">
                        <v-text-field
                        class="text-field"
                        v-model="form.email"
                        :rules="[rules.requiredEmail, rules.email]"
                        label="E-mail"
                        ></v-text-field>
                    </v-col>

                    <!-- パスワードの登録 -->
                    <v-col cols="12">
                        <v-text-field
                        class="text-field"
                        v-model="form.password1"
                        :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                        :rules="[rules.requiredPassword, rules.min]"
                        :type="show1 ? 'text' : 'password'"
                        label="Password"
                        counter
                        @click:append="show1 = !show1"
                        ></v-text-field>
                    </v-col>

                    <!-- パスワードの確認 -->
                    <v-col cols="12">
                        <v-text-field
                        class="text-field"
                        v-model="form.password2"
                        :append-icon="show2 ? 'mdi-eye' : 'mdi-eye-off'"
                        :rules="[rules.issame]"
                        :type="show2 ? 'text' : 'password'"
                        label="Password(確認)"
                        @click:append="show2 = !show2"
                        ></v-text-field>
                    </v-col>
                </v-row>
            </v-container>
            <!-- キャンセルと登録ボタン、登録ボタンはformIsValidを満たした時にdisabledが外れる。 -->
            <v-card-actions>
                <v-btn
                 text
                 @click="resetForm"
                >
                キャンセル
                </v-btn>
                <v-spacer></v-spacer>
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
import axios from 'axios'
  export default {
    data () {
    //   Object.freezeにより以降オブジェクトの変更を防ぐ
      const defaultForm = Object.freeze({ userName: '', email: '', password1: '', password2: '' })

      return {
        snackbar: false,
        show1: false,
        show2: false,
        info: null,
        defaultForm,
        form: Object.assign({}, defaultForm),
        rules: {
          name: [value => (value || '').length > 0 || 'user nameは必須です'],
          email: value => {
            const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            return pattern.test(value) || '有効なメールアドレスを入力してください'
          },
          requiredEmail: value => !!value || 'e-mailは必須です',
          requiredPassword: value => !!value || 'passwordは必須です',
          min: value => value.length >= 6 || '6字以上で作成してください',
          issame: value => value == this.form.password1 || '同じパスワードを入力してください',
        },
      }
    },

    computed: {
      formIsValid () {
        return (
          this.form.userName &&
          this.form.email &&
          this.form.password1 &&
          this.form.password2
        )
      },
    },

    methods: {
      resetForm () {
        this.form = Object.assign({}, this.defaultForm)
        this.$refs.form.reset()
      },
      submit() {
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/users';
        let params = {user: {name: this.form.userName,
                             email: this.form.email,
                             password: this.form.password1,
                             password_confirmation: this.form.password2
                             }
                      };

        axios.post( url, params, { withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' }})
        .then(function (response) {
            that.info = response.data;
            that.$emit('logged-in-info', that.info);
            that.$router.push({ name: 'Home'})
        })
        .catch(function (error) {
            console.log(error);
        })    

        this.resetForm()
      },
    },
  }
</script>

<style scoped>
 .signup-top {
     text-align: center;
     margin-top:4vw;
     margin-bottom: 2vw;
 }
 .form-container {
     margin:0 auto;
 }
 .text-field {
     padding: 0;
 }
</style>