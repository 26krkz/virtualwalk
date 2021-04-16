import { mount, createLocalVue } from '@vue/test-utils'
import Vuetify from 'vuetify';
import Ranking from '@/components/Ranking.vue'

describe('Ranking.vue', () => {
    const localVue = createLocalVue();
    let vuetify

    beforeEach(() => {
      vuetify = new Vuetify()
    })
    it('render a Ranking top 5 videos', () => {
        const wrapper = mount(Ranking, { localVue, vuetify });
        console.log(wrapper.html())
    })
})

