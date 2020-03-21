<template>
  <div id="app">
    <!-- <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld msg="Welcome to Your Vue.js App"/> -->
    <MyCalendar />
  </div>
</template>

<script>
// import HelloWorld from './components/HelloWorld.vue'
import MyCalendar from './components/calendar.vue'

export default {
  name: 'App',
  components: {
    // HelloWorld,
    MyCalendar
  },
  mounted: function(){
      let d = new Date()
      this.$EventCalendar.toDate(d.toLocaleDateString())
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
  margin-top: 30px;
  margin-bottom: 30px;
}
</style>
