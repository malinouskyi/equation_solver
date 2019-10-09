<template>
  <div id="equations-list">
    <ul>
        <transition-group name="equation-appear">
        <li v-for="(equation,index) in equations" v-bind:key="index">
            {{equation.constants}}
            <div class="equation-metadata" v-bind:style="equationStyle(equation.solution.status)">
              <span class="solution">Ответ: {{equation.solution.answer}}</span>
            </div>      
        </li>
        </transition-group>
    </ul>
  </div>
</template>

<script>
  export default {
    computed: {
      equations() {
        return this.$store.state.equations
      }
    },    
    methods: {
      equationStyle(status) {
        switch(status) {
          case '0':
           return { backgroundColor: '#EBA5A5' }
          case '1':
           return { backgroundColor: '#9BEB71' }
          default:
            return { }
        } 
      }
    }
  }
</script>