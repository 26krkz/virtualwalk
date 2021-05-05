import { shallowMount } from '@vue/test-utils'
import Login from '@/views/Login.vue'

describe('Login.vue', () => {
    const wrapper = shallowMount(Login)
    console.log(wrapper.html());

    it('メールアドレスとパスワードなしではログインボタンを押せない', () => {
        // wrapper.find('v-text-field-stub' + '[label="Email"]').element.value = 'test@example.com'
        // wrapper.find('v-text-field-stub' + '[label="Email"]').trigger('input')

        // expect(wrapper.find('v-text-field' + '[label="Email"]').element.value).toBe('test@example.com')
    })
    // it('メールアドレスだけではログインボタンを押せない', () => {
        
    // })
    // it('パスワードだけではログインボタンを押せない', () => {

    // })
    it('メールアドレスとパスワードを入力するとログインボタンを押せる', () => {
        wrapper.find('v-text-field' + '[label="Email"]').element.value = 'test@example.com'
        wrapper.find('v-text-field' + '[label="Email"]').trigger('change')

        // const emailSpace = wrapper.find('v-text-field-stub' + '[label="Email"]');
        // await emailSpace.setValue('test@example.com')
        wrapper.find('v-text-field' + '[label="Password"]').element.value = 'password'
        wrapper.find('v-text-field' + '[label="Password"]').trigger('change')
        // console.log(wrapper.html());

        const stub = jest.fn();
        wrapper.setMethods({
            submit: stub,
        });
        // wrapper.vm.form.email = 'test@example.com'
        // wrapper.vm.form.password = 'testPassword'
        // wrapper.find('v-btn' + '[type="submit"]').trigger('click')
        wrapper.find('v-form').trigger('submit.prevent')
        expect(stub).toHaveBeenCalled();
        expect(wrapper.vm.form.email).toBe('test@example.com');


    })
})