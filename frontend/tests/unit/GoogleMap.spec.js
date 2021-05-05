import { shallowMount } from '@vue/test-utils'
import GoogleMap from '@/components/GoogleMap.vue'

describe('GoogleMap.vue', () => {
    it('render a map', () => {
        const wrapper = shallowMount(GoogleMap)
        console.log(wrapper.html());
    })
})