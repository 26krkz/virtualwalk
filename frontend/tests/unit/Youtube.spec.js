import { shallowMount } from '@vue/test-utils'
import Youtube from '@/components/Youtube.vue'

describe('Youtube.vue', () => {
    it('render a map', () => {
        const wrapper = shallowMount(Youtube);
        console.log(wrapper.html());
    })
})