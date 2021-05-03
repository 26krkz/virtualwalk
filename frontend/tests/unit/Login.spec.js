import { shallowMount } from '@vue/test-utils'
import Login from '@/views/Login.vue'

describe('Login.vue', () => {
    it('メールアドレスとパスワードなしではログインボタンを押せない', () => {
        const wrapper = shallowMount(Login)
        console.log(wrapper.html());
    })
    // it('メールアドレスだけではログインボタンを押せない', () => {
        
    // })
    // it('パスワードだけではログインボタンを押せない', () => {

    // })
    // it('メールアドレスとパスワードを入力するとログインボタンを押せる', () => {

    // })
})