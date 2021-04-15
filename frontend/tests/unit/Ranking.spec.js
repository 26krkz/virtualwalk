import { mount } from '@vue/test-utils'
import Vue from 'vue';
import Vuetify from 'vuetify';
import Ranking from '@/components/Ranking.vue'

Vue.use(Vuetify);

describe('Ranking.vue', () => {
    it('render a Ranking top 5 videos', () => {
        const wrapper = mount(Ranking);
        console.log(wrapper.html())
    })
})

