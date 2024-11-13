import Vue from 'vue'
import App from './App.vue'
import Amplify from 'aws-amplify'
import {
  applyPolyfills,
  defineCustomElements
} from '@aws-amplify/ui-components/loader'
import 'dotenv/config'

Vue.config.productionTip = false
Vue.config.ignoredElements = [/amplify-\w*/]

Amplify.configure({
  Auth: {
    identityPoolId: process.env.COGNITO_IDENTITY_POOL_ID,
    region: process.env.AWS_REGION,
    identityPoolRegion: process.env.AWS_REGION,
    userPoolId: process.env.COGNITO_USER_POOL_ID,
    userPoolWebClientId: process.env.COGNITO_USER_POOL_WEB_CLIENT_ID
  }
})

applyPolyfills().then(() => {
  defineCustomElements(window)
})

new Vue({
  render: h => h(App),
}).$mount('#app')
