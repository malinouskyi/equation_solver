<template>
  <v-form v-model="valid" ref="form" lazy-validation>
    <v-card>
      <v-card-title class="headline"></v-card-title>
        <v-radio-group v-model="type" :rules="[v => !!v || 'Выберите вид уравнения']" required row>
          <v-radio label="линейное" value="linear" @change="getType('linear')"></v-radio>
          <v-radio label="квадратное" value="quadratic" @change="getType('quadratic')"></v-radio>
        </v-radio-group>
      <v-card-text>

        <v-text-field v-if="type == 'linear'"
          :disabled=isInputDisabled
          v-model="message"
          filled
          clear-icon="mdi-close-circle"
          clearable
          label="Условие"
          type="text"
          :rules= "linearRules"
          @click:clear="clearMessage"
        ></v-text-field>

        <v-text-field v-if="type == 'quadratic'"
          :disabled=isInputDisabled
          v-model="message"
          filled
          clear-icon="mdi-close-circle"
          clearable
          label="Условие"
          type="text"
          :rules= "quadraticRules"
          @click:clear="clearMessage"
        ></v-text-field>

      </v-card-text>
      <v-card-actions>
        <v-btn @click="sendMessage" color="primary" :loading="loading" :disabled="loading" >
          Решить
        </v-btn>
      </v-card-actions>      
    </v-card>
  </v-form>  
</template>

<script>
  export default {
    data: () => ({
      valid: false,
      loading: false,
      type: "",
      message: "",
      error: ""
    }),
    computed: {
      isInputDisabled() {
        return this.type == "" ? true: false  
      },   
      linearRules() {
        return [
          v => !!v || 'Введите условия линейного уравнения, например: 2x-5=1',
          v => /([?<=+-])|((\d)?(\S)+)((\<\=|\<|\>|\=))(\d?\s)([?+-])+/.test(v) || 'Условия уравнения не верны'
        ]
      },
      quadraticRules() {
        return [
          v => !!v || 'Введите условия квадратного уравнения, например: a = 1, b = 3, c = 5',
          v => /([?<=+-])|((\d)?(\S)+)((\<\=|\<|\>|\=))(\d?\s)([?+-])+/.test(v) || 'Условия уравнения не верны'
        ]
      },
    },
    methods: {
      sendMessage() {
        if (this.valid && this.$refs.form.validate()) {
          this.loading = true;
          let data = {
            type: this.type,
            message: this.message
          }
          this.$emit('send-equation', data)
          this.loading = false
        }
      },
      getType(t) {
        this.clearMessage()
      },      
      clearMessage () {
        this.error = ''
        this.message = ''
      },
    },
  }
</script>