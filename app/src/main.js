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
    identityPoolId: 'ap-northeast-1:5f1ad0f8-74cb-4283-81f9-93512c44307c',
    region: 'ap-northeast-1',
    identityPoolRegion: 'ap-northeast-1',
    userPoolId: 'ap-northeast-1_XwVhHrxhp',
    userPoolWebClientId: '3nk6n6nqsne58b3nf2f1ttn2f0'
  }
})

applyPolyfills().then(() => {
  defineCustomElements(window)
})

new Vue({
  render: h => h(App),
}).$mount('#app')
