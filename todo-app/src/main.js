import Vue from 'vue'
import App from './App.vue'
import Amplify from 'aws-amplify'
import {
  applyPolyfills,
  defineCustomElements
} from '@aws-amplify/ui-components/loader'

Vue.config.productionTip = false
Vue.config.ignoredElements = [/amplify-\w*/]

Amplify.configure({
  Auth: {
    identityPoolId: 'ap-northeast-1:87111808-c1cd-4d75-8cff-6a85646f5934',
    region: 'ap-northeast-1',
    identityPoolRegion: 'ap-northeast-1',
    userPoolId: 'ap-northeast-1_BXhWUbfqi',
    userPoolWebClientId: '1l8a1k0hvthobrnuj4l22i1skm'
  }
})

applyPolyfills().then(() => {
  defineCustomElements(window)
})

new Vue({
  render: h => h(App),
}).$mount('#app')
