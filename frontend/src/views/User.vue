<template>
<v-main id="main-container">
    <p>ユーザー名</p>
    <p>{{ userData.name }}</p>
    <p>メールアドレス</p>
    <p>{{ userData.email }}</p>
    <v-btn class="btn" @click="expand1 = !expand1">プロフィールを変更</v-btn>
    <v-btn class="btn" @click="deleteAccount">退会する</v-btn>
    <v-expand-transition>
        <v-card class="form-container" width="260" v-show="expand1">
            <!-- submit.preventによりsubmitボタンを押してもページがリロードされるのを防ぐ -->
            <v-form
            ref="form"
            @submit.prevent="updateAccount"
            >
                <v-container>
                    <v-row class="mr-3 ml-3">
                        <!-- ユーザーネームの登録 -->
                        <v-col cols="12" >
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
                            :rules="[rules.required, rules.email]"
                            label="E-mail"
                            ></v-text-field>
                        </v-col>

                        <v-btn class="btn" @click="expand2 = !expand2">パスワードを変更</v-btn>

                        <v-expand-transition>
                            <div v-show="expand2">
                                <!-- パスワードの登録 -->
                                <v-col cols="12">
                                    <v-text-field
                                    class="text-field"
                                    v-model="form.password1"
                                    :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                                    :rules="[rules.required, rules.min]"
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
                            </div>

                        </v-expand-transition>
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
                    変更する
                    </v-btn>
                </v-card-actions>
            </v-form>
        </v-card>
    </v-expand-transition>
    <div>
        お気に入り一覧
    </div>
</v-main>
</template>

<script>
import axios from 'axios'
  export default {
    data () {
    //   Object.freezeにより以降オブジェクトの変更を防ぎ空のオブジェクトを保つ
    //   let that = this;
      const defaultForm = Object.freeze({ userName: '', email: '', password1: '', password2: '' })

      return {
        expand1: false,
        expand2: false,
        userData: this.$route.params.info.current_user,
        snackbar: false,
        show1: false,
        show2: false,
        info: null,
        defaultForm,
        form: Object.assign({}, this.defaultForm),
        rules: {
          name: [value => (value || '').length > 0 || 'user nameは必須です'],
          email: value => {
            const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            return pattern.test(value) || '有効なメールアドレスを入力してください'
          },
          required: value => !!value || 'Passwordは必須です',
          min: value => value.length >= 6 || '6字以上で作成してください',
          issame: value => value == this.form.password1 || '同じパスワードを入力してください',
        },
      }
    },
    computed: {
      formIsValid () {
        return (
          this.form.userName &&
          this.form.email 
        )
      },
    },

    methods: {
      resetForm () {
        this.form = Object.assign({}, this.defaultForm)
        this.$refs.form.reset()
      },
      updateAccount() {
        let that = this;
        const url = 'http://localhost/users/' + this.userData.id;
        const params =  {user: {name: this.form.userName,
                                email: this.form.email,
                                password: this.form.password1,
                                password_confirmation: this.form.password2
                                }
                        };
    
        axios.patch( url, params, { withCredentials: true })
        .then(function (response) {
            that.info = response.data;
            that.$emit('logged-in-info', that.info);
            that.$router.push({ name: 'User'})
        })
        .catch(function (error) {
            console.log(error);
        })    

        this.resetForm()
      },
      deleteAccount(){
        let that = this;
        const url = 'http://localhost/users/' + this.userData.id;
        let result = confirm('退会するとアカウントが削除されますがよろしいですか？');
        if( result ){
            axios.delete( url, {withCredentials: true})
            .then(function (response) {
                that.info = response.data;
                that.$emit('logged-in-info', that.info);
                that.$router.push({ name: 'Home'})
            })
            .catch(function (error) {
            console.log(error);
            })
        }else{
            this.$router.push({ name: 'User'})
        }
       }
    },
  }
</script>

<style scoped>
 p {
     margin:0;
 }
 .btn {
     margin-bottom: 10px;
     margin-right: 20px;
 }
 #main-container {
     margin-left: 5vw;
 }
 .text-field {
     padding: 0;
 }
</style>