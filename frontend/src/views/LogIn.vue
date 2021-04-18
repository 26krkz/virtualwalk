<template>
  <v-main>
    <div class="login-top">
        <h4>Log in to virtualwalk</h4>
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
                    <!-- ユーザーネームの入力 -->
                    <v-col cols="12">
                        <v-text-field
                        calss="text-field"
                        v-model="form.email"
                        label="Email"
                        ></v-text-field>
                    </v-col>

                    <!-- パスワードの入力 -->
                    <v-col cols="12">
                        <v-text-field
                        class="text-field"
                        v-model="form.password"
                        :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                        :type="show1 ? 'text' : 'password'"
                        name="input-10-1"
                        label="Password"
                        @click:append="show1 = !show1"
                        ></v-text-field>
                    </v-col>
                    <v-col cols="12" class="textfield">
                      <v-checkbox
                        v-model="form.remember_me"
                        class="checkbox"
                        label="ログインしたままにする"
                        color="cyan"
                        hide-details
                       >
                      </v-checkbox>
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
                ログイン
                </v-btn>
            </v-card-actions>
        </v-form>
    </v-card>
    <router-link to="/signup" ><div class="signup-link">新規登録はこちら！</div></router-link>
  </v-main>
</template>

<script>
import axios from 'axios'

  export default {
    data () {
    //   Object.freezeにより以降オブジェクトの変更を防ぐ
      const defaultForm = Object.freeze({ email: '', password: '', remember_me: false })

      return {
        // snackbar: false,
        show1: false,
        defaultForm,
        form: Object.assign({}, defaultForm),
        user: null,
        info: null
      }
    },

    computed: {
      formIsValid () {
        return (
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
        let that = this;
        const url = process.env.VUE_APP_API_BASE_URL + '/login';
        let params = {session: {email: this.form.email,
                                password: this.form.password,
                                remember_me: this.form.remember_me
                               }
                      };

        axios.post(url, params, {withCredentials: true, headers: { 'X-Requested-With': 'XMLHttpRequest' }} )
        .then(function (response) {
            that.info = response.data;
            that.$emit('logged-in-info', that.info);
            if( that.info.current_user ){
              that.$router.push({ name: 'Home' })
            }else{
              that.$touter.push({ name: 'User' })
            }
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
 .login-top {
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
 .checkbox {
   margin-top:0;
 }
 .login {
     text-decoration: none;
 }
 .signup-link {
     display:block;
     text-align: right;
     padding-right: 15px;
     margin: 15px auto;
     width: 300px;
     color: black;
}
</style>