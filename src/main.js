import Vue from 'vue'
import App from './App.vue'
import {Cell,Calendar,Button,Form,Field,Dialog} from 'vant'
import 'vue-event-calendar/dist/style.css'
import vueEventCalendar from 'vue-event-calendar'
import 'vant/lib/index.css'

Vue.config.productionTip = false

Vue.use(Calendar).use(Cell).use(Button).use(Form).use(Field).use(Dialog)
Vue.use(vueEventCalendar, {locale: 'zh'}) 

new Vue({
  render: h => h(App),
}).$mount('#app')
