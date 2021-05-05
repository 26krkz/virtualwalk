import { shallowMount } from '@vue/test-utils'
import CountryTabs from '@/components/CountryTabs.vue'

describe( 'CountryTabs.vue', () => {
    it( 'タブをクリックした時にgetRegionsVideos()が実行される。', () => {
        const wrapper = shallowMount(CountryTabs);
        const stub = jest.fn();
        wrapper.setMethods({
            getRegionsVideos: stub,
        });
        wrapper.find('v-tab').trigger('click');
        expect(stub).toHaveBeenCalled();
    })
    it( 'サムネイルをクリックするとselect-video-idとexpand-windowがイベントアップされる', () => {
        const wrapper = shallowMount(CountryTabs, {
                                                    data(){
                                                        return {
                                                            selectedRegionVideos: [
                                                                {
                                                                    snippet: {
                                                                        resourceId: { videoId: "sampleVideoId" },
                                                                        thumbnails: { medium: { url: "videoUrl" } }
                                                                    }
                                                                }
                                                            ]
                                                        }
                                                    }
                                                   }
                                        );
        wrapper.find('img').trigger('click');
        expect(wrapper.emitted('select-video-id')[0][0]).toBe('sampleVideoId');
        expect(wrapper.emitted('expand-window')[0][0]).toBe(true);
    })
})