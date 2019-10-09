<template>
  <v-app>
    <div id="solver-container">
      <p id="error" class="alert alert-danger">
        {{ error }}
      </p>
      <Equation v-on:send-equation="sendEquation"/>
      
      <div class="row">
        <div class="col-xs-8">          
          <Solver/>
        </div>
      </div>
    </div>
  </v-app>
</template>

<script>

  import Equation from './components/Equation.vue'
  import Solver from './components/Solver.vue'
  //import Users  from './components/Users.vue'
  import { Socket, Presence } from "phoenix"

  export default {
    components: { 
      Solver, 
      Equation
    },
    data () {
      return {
        scores: {},
        users: [],
        error: ""
      }
    },
    methods: {
      sendEquation(data) {
       if (data) {
          let equation = { constants: data.message, type: data.type}
          this.channel.push("solve_new_equation", equation )
        }
      },
      /*sendChat(event) {
        if (this.chatMessage) {
          this.channel.push("new_chat_message", { body: this.chatMessage })
          this.chatMessage = ""
        }
      },*/
      joinChannel(authToken, solverName) {
        const socket =
          new Socket("/socket", { params: { token: authToken } })

        socket.connect()

        this.channel = socket.channel(`solvers:${solverName}`, {})
        
        this.channel.on("solver_summary", summary => {
          this.$store.commit('addEquation', summary.equations )
          this.users = this.toUsers(this.presences)
        })

        this.presences = {}

        this.channel.on('presence_state', state => {
          this.presences = Presence.syncState(this.presences, state)
          this.users = this.toUsers(this.presences)
        })

        this.channel.on('presence_diff', diff => {
          this.presences = Presence.syncDiff(this.presences, diff)
          this.users = this.toUsers(this.presences)
        })

        this.channel
          .join()
          .receive("ok", response => {
            console.log(`Joined ${solverName} 😊`)
          })
          .receive("error", response => {
            this.error = `Joining ${solverName} failed 🙁`
            console.log(this.error, response)
          })
      },
      toUsers(presences) {
        const listBy = (name, { metas: [first, ...rest] }) => {
            return { name: name}
        }

        return Presence.list(presences, listBy)
      }
    },
    created: function () {
      const solverContainer = this.$parent.$el

      const { authToken, solverName } = solverContainer.dataset

      this.joinChannel(authToken, solverName)
    }
  }
</script>