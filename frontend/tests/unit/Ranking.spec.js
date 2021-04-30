import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuetify from 'vuetify';
import Ranking from '@/components/Ranking.vue'

describe('Ranking.vue', () => {
    const localVue = createLocalVue();
    let vuetify

    beforeEach(() => {
      vuetify = new Vuetify()
    })
    it('render a Ranking top 5 videos', () => {
        const wrapper = shallowMount(Ranking, { localVue, 
                                                vuetify,
                                                data(){
                                                  return{ 
                                                    topFiveFavoriteVideos: [
                                                      { snippet: {
                                                          resourceId: { videoId: "sampleVideoId" },
                                                          thumbnails: { medium: { url: "videoUrl" } }
                                                        }
                                                      }
                                                    ]
                                                  }
                                                } 
                                              });
        // const stub = jest.fn();
        // wrapper.setMethods({
        //   showSelectedVideo: stub,
        // });
        wrapper.find('img').trigger('click');
        // expect(stub).toHaveBeenCalled();
        expect(wrapper.emitted('select-video-id')).not.toBeUndefined();
        expect(wrapper.emitted('expand-window')).not.toBeUndefined();
    })
})

