import Vue from 'vue'
import App from './App.vue'
import axios from "axios"
import {Cell,Calendar,Button,Form,Field,Dialog,Toast,Notify,DatetimePicker} from 'vant'
import 'vue-event-calendar/dist/style.css'
import vueEventCalendar from 'vue-event-calendar'
import 'vant/lib/index.css'

// import ElementUI from 'element-ui'
// import 'element-ui/lib/theme-chalk/index.css'

Vue.config.productionTip = false

Vue.use(Calendar).use(Cell).use(Button).use(Form).use(Field).use(Dialog)
Vue.use(vueEventCalendar, {locale: 'zh'}) 
Vue.use(axios)
Vue.use(Notify)
Vue.use(Toast)
Vue.use(DatetimePicker)
// Vue.use(ElementUI)

new Vue({
  render: h => h(App),
}).$mount('#app')
