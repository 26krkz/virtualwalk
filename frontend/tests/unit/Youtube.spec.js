import { shallowMount } from '@vue/test-utils'
import Youtube from '@/components/Youtube.vue'
// import axios from 'axios'
// jest.mock('axios')

describe('Youtube.vue', () => {
    const wrapper = shallowMount(Youtube, {
                                            propsData: {
                                                videoId: 'sampleVideoId',
                                                expand: true
                                            },
                                            data(){
                                                return {
                                                    item: {
                                                        snippet: {
                                                            resourceId: { videoId: "sampleVideoId" },
                                                            thumbnails: { medium: { url: "videoUrl" } }
                                                        }
                                                    },
                                                    videoData: {
                                                        id: 1,
                                                        country: 'Japan',
                                                        tag1: 'Tokyo',
                                                        region: 'Asia',
                                                        time: '1:00:00'
                                                    }
                                                }
                                            }
                                        }
    );

    it('表示ボタンを押すと動画のURLが指定される', () => {
        wrapper.find('v-btn'+ '.resume-btn').trigger('click');
        expect(wrapper.vm.selectedMovieUrl).toBe('https://www.youtube.com/embed/sampleVideoId?start=0&end=');
    })

    it('開始時間と再生時間を設定後で表示ボタンを押すと動画のURL上で正しく時間が指定がされる', () => {
        // 開始時間を指定するselectタグから0:10:00を指定する
        wrapper.find('.select-time-start').findAll('option').at(1).setSelected();
        // 再生時間を指定するselectタグから10minを指定する
        wrapper.find('.select-time-playing').findAll('option').at(1).setSelected();
        wrapper.find('v-btn'+ '.resume-btn').trigger('click');
        //時間指定後表示ボタンを押すとurlにそれぞれの時間が追加される。開始時間は10分後（600秒後）、終了時間は開始時間＋再生時間の20分（1200秒後）
        expect(wrapper.vm.selectedMovieUrl).toBe('https://www.youtube.com/embed/sampleVideoId?start=600&end=1200');
    })

    // it('指定の動画がお気に入りに追加されていた場合ハートがピンクになる', () => {
    //     wrapper.vm.heartIcon = 'mdi-heart-outline';
    //     wrapper.vm.whetherAddedFavorite();
    //     const response = {
    //         favoriteList: [{id: 1}]
    //       }
    //     axios.get.mockImplementationOnce(() => {
    //         return Promise.resolve(response)
    //       })
    //     expect(wrapper.vm.heartIcon).toBe('mdi-heart')
        
    // })

    it('指定の動画がお気に入りに追加した場合ハートがグレーからピンクになり、お気に入り追加メソッドが実行される', () => {
        // お気に入りボタンを使えるようにする
        wrapper.vm.disable = false;
        //お気に入りボタンのアイコンをお気に入り追加されていない状態に設定
        wrapper.vm.heartIcon = 'mdi-heart-outline';

        const stub = jest.fn();
        wrapper.setMethods({
            addFavorite: stub,
        });
        wrapper.find('.fav-btn').trigger('click');
        expect(wrapper.vm.heartIcon).toBe("mdi-heart")
        expect(wrapper.vm.heartColor).toBe("pink")
        expect(stub).toHaveBeenCalled();
        
    })
    it('指定の動画がお気に入りから削除した場合ハートがピンクからグレーになり、お気に入り削除メソッドが実行される', () => {
        // お気に入りボタンを使えるようにする
        wrapper.vm.disable = false;
        //お気に入りボタンのアイコンをお気に入り追加されている状態に設定
        wrapper.vm.heartIcon = 'mdi-heart';

        const stub = jest.fn();
        wrapper.setMethods({
            removeFavorite: stub,
        });
        wrapper.find('.fav-btn').trigger('click');
        expect(wrapper.vm.heartIcon).toBe("mdi-heart-outline")
        expect(wrapper.vm.heartColor).toBe(null)
        expect(stub).toHaveBeenCalled();
    })
})