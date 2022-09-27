<template>
  <div id="app">
    <amplify-authenticator>
      <div>
        <h1>Todo App</h1>
        <div class="add-task-wrapper">
          <input type="text" v-model="newTaskInput" @keydown.enter="addTask" />
          <button @click="addTask">Add task</button>
        </div>
        <div class="task" v-for="task in tasks" :key="task.taskId">
          <span>{{ task.title }}</span>
          <span class="delete">
            <button @click="removeTask(task.taskId)">X</button>
          </span>
        </div>
      </div>
      <amplify-sign-out></amplify-sign-out>
    </amplify-authenticator>
  </div>
</template>

<script>
import { Auth } from 'aws-amplify'
import { onAuthUIStateChange } from '@aws-amplify/ui-components'
import axios from 'axios'

export default {
  name: 'App',
  data() {
    return {
      newTaskInput: '',
      tasks: [],
      user: undefined,
      authState: undefined,
      unsubscribeAuth: undefined
    }
  },
  created() {
    this.unsubscribeAuth = onAuthUIStateChange((authState, authData) => {
      this.authState = authState
      this.user = authData
    })
    this.getTasks()
  },
  methods: {
    addTask: async function() {
      await Auth.currentSession()
        .then(data => {
          const idToken = data.getIdToken().getJwtToken()
          const payload = {
            title: this.newTaskInput
          }
          axios.post('https://gl0q295fo1.execute-api.ap-northeast-1.amazonaws.com/production/tasks', payload, {
            headers: {
              Authorization: idToken,
              'content-type': 'application/json'
            }
          }).then(response => {
            this.tasks.push(response.data)
          }).catch(error => {
            console.error(error)
          })
        })

      this.newTaskInput = ''
    },
    getTasks: function() {
      Auth.currentSession()
        .then(data => {
          console.log(this.newTaskInput)
          const idToken = data.getIdToken().getJwtToken()
          axios.get('https://gl0q295fo1.execute-api.ap-northeast-1.amazonaws.com/production/tasks', {
            headers: {
              Authorization: idToken
            }
          }).then(response => {
            this.tasks = response.data
          }).catch(error => {
            console.error(error)
          })
        })
    },
    removeTask(taskId) {
      Auth.currentSession()
        .then(data => {
          const idToken = data.getIdToken().getJwtToken()
          axios.delete(`https://gl0q295fo1.execute-api.ap-northeast-1.amazonaws.com/production/tasks/${taskId}`, {
            headers: {
              Authorization: idToken
            }
          }).then(response => {
            console.log(response)
            this.tasks = this.tasks.filter(task => task.taskId !== response.data.taskId)
          }).catch(error => {
            console.error(error)
          })
        })
    }
  },
  beforeDestroy() {
    this.unsubscribeAuth()
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
  max-width: 500px;
  margin: 0 auto;
}

button, input {
  border-radius: 5px;
  padding: 5px 10px;
  border: 1px solid #aaa;
  margin: 5px;
}

.add-task-wrapper {
  display: flex;
}

.add-task-wrapper input {
  flex: 1;
}

.task {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #eee;
  border-radius: 5px;
  margin: 5px 10px;
  padding: 5px 10px;
}
</style>
