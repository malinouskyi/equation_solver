import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

// root state object.
// each Vuex instance is just a single state tree.
const state = {
  equations: []
}

// mutations are operations that actually mutates the state.
// each mutation handler gets the entire state tree as the
// first argument, followed by additional payload arguments.
// mutations must be synchronous and can be recorded by plugins
// for debugging purposes.
const mutations = {
  addEquation (state, equation) {
    if (Array.isArray(equation)) {
      equation.map(addTime)
      function addTime(value, index) {
        value['received_at'] = new Date().toLocaleString()
        state.equations.push(value)
      }
    }
    else {
      equation.received_at = new Date().toLocaleString()
      state.equations.push(equation)
    }
  },
  setEquitions(state, equations) {
    state.equations = equations 
  },  
}

// actions are functions that causes side effects and can involve
// asynchronous operations.
const actions = {
}

// getters are functions
const getters = {
  equations: state => {
    return state.equations
  }  
}

function isObject (value) {
  return value && typeof value === 'object' && value.constructor === Object;
}

// A Vuex instance is created by combining the state, mutations, actions,
// and getters.
export default new Vuex.Store({
  state,
  getters,
  actions,
  mutations
})