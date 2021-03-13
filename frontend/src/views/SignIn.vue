<template>
  <v-main>
    <div class="signup-top">
        <h4>Sign in to virtualwalk</h4>
    </div>

    <!-- 登録に成功した時にスナックバーを表示する -->
    <v-snackbar
      v-model="snackbar" 
      absolute
      top
      right
      color="success"
    >
      <span>ログインしました</span>
    </v-snackbar>
    
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
                        v-model="form.userName"
                        label="User name"
                        ></v-text-field>
                    </v-col>

                    <!-- パスワードの入力 -->
                    <v-col cols="12">
                        <v-text-field
                        class="text-field"
                        v-model="form.password1"
                        :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                        :type="show1 ? 'text' : 'password'"
                        name="input-10-1"
                        label="Password"
                        @click:append="show1 = !show1"
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
                ログイン
                </v-btn>
            </v-card-actions>
        </v-form>
    </v-card>
  </v-main>
</template>

<script>
  export default {
    data () {
    //   Object.freezeにより以降オブジェクトの変更を防ぐ
      const defaultForm = Object.freeze({ userName: '', password1: ''})

      return {
        snackbar: false,
        show1: false,
        defaultForm,
        form: Object.assign({}, defaultForm),
      }
    },

    computed: {
      formIsValid () {
        return (
          this.form.userName &&
          this.form.password1
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