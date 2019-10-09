import Vue from 'vue'
import App from "./App.vue"
import Vuetify from 'vuetify' // Import Vuetify to your project
import store from "./store.js"

Vue.config.productionTip = false;
Vue.use(Vuetify) // Add Vuetify as a plugin
export default new Vuetify({ })


const solverContainer = document.querySelector("#solver-container")

if (solverContainer) {
  new Vue({
    el: '#solver-container',
    vuetify: new Vuetify(),
    store,
    template: '<App/>',
    components: { App }
  })
}
