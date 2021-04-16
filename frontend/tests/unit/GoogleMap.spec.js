import { mount } from '@vue/test-utils'
import GoogleMap from '@/components/GoogleMap.vue'
import GoogleMapsApiLoader from 'google-maps-api-loader';
import markerLocation from '../../src/assets/marker.json'

describe('GoogleMap.vue', () => {
    it('render a map', () => {
        const wrapper = mount(GoogleMap, {
            data(){
                return {
                    google: null,
                    map: null,
                    apiKey: process.env.VUE_APP_GOOGLE_MAP_API_KEY,
                    mapConfig: {
                        center: {
                            lat: 35,
                            lng: 155
                        },
                        zoom: 1.9,
                    },
                    markerLocation: markerLocation,
                    markers: [],
                    markerNum: 0,
                }
            }
        })
        
        const googleMapApi = GoogleMapsApiLoader({
            apiKey: wrapper.vm.apiKey,
            libraries: ['places']
        })
        wrapper.vm.google = googleMapApi
        wrapper.vm.initializeMap()
        wrapper.vm.setMarker()

        wrapper.find('div[role="button"]').trigger('click')
        expect(wrapper.emitted('expand-window')).toBeTruthy()
        // console.log(wrapper.html())
    })
})