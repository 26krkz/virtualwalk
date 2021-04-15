import { mount } from '@vue/test-utils'
import GoogleMap from '@/components/GoogleMap.vue'

describe('GoogleMap.vue', () => {
    it('render a map', () => {
        const wrapper = mount(GoogleMap)

        // wrapper.find('div[role="button"]').trigger('click')
        // expect(wrapper.emitted('expand-window')).toBeTruthy()
        console.log(wrapper.html())
    })
})