<template>
  <div id="my_calendar">
      <div v-if="loginQ" class="loginQ-y">
            <div class="button-add">
                <van-button type="warning" round icon="plus" hairline @click="triggerShow" color="linear-gradient(0deg,rgb(237, 223, 56),rgb(238, 67, 49))"></van-button>
            </div>
            
            <vue-event-calendar ref="cachild" :events="curveEventsList">
                <template scope="props">
                    <div v-for="(event, index) in props.showEvents" v-bind:key="'sub_k'+index" class="event-item">
                    <!-- 这里拿到的是传入的单个event所有数据 -->
                    <!-- {{event.desc}} -->
                        <div class="curver-container-wrapper">
                            <h3 class="title show-title" @click="editEvent(event)">{{index}}. {{event.title}}</h3>
                            <p class="time">{{event.startDate}} 第<span class="text-important">{{event.circle+1}}</span>天</p>
                            <p class="desc">{{event.desc}}</p>
                        </div>
                    </div>
                </template>
            </vue-event-calendar>

            <van-dialog v-model="newShow" :showConfirmButton='false' closeOnPopstate closeOnClickOverlay :width="ccwidth">
                <!-- <img src="https://img.yzcdn.cn/vant/apple-3.jpg"> -->
                <!-- <newCurve v-on:updateCurveFunc="updateCurveFunc"/> -->
                <calEvent ref="childEvent" v-on:updateCurveFunc="updateCurveFunc" v-on:delEventFunc="delEventFunc" v-on:closeForm="closeForm" />
            </van-dialog>
      </div>
      <div v-else :style="loginQ_N" >
          <div v-if="loginUpQ">
              <calendarLoginUp />
          </div>
          <div v-else >
            <calendarLogin />
          </div>
      </div>
       
  </div>
</template>

<script>

import {genCurveList} from "./../js/curve_event.js"
// import newCurve from "./new_calender.vue"
import calEvent from "./cal_event.vue"
import calendarLogin from "./login.vue"
import calendarLoginUp from "./login_up.vue"
import axios from 'axios'
// import Toast from 'vant'

export default {
    name: 'MyCalendar',
    components:{
        // newCurve,
        calEvent,
        calendarLogin,
        calendarLoginUp
    },
    data () {
        return {
            demoEvents: [ {
                date: '2020/03/18',
                title: '学习',
                desc: '英语第一节',
                customClass: 'lxj-highlight' // Custom classes to an calendar cell
            },
            {
                date: '2020/03/28',
                title: '金融',
                desc: '模型',
                customClass: 'lxj-highlight' // Custom classes to an calendar cell
            }],
            curveEventsList:[],
            newShow: false,
            cwidth: document.documentElement.clientWidth,
            cheight: document.documentElement.clientHeight,
            loginQ: null,
            loginUpQ: null,
            editEventQ: null
        }
    },
    methods: {
       triggerShow(){
           this.newShow = !this.newShow
           let _this = this;

            let promise = new Promise(function(resolve) {
                setTimeout(function() {
                    resolve();
                }, 300);
            });

            promise.then(function(){
                _this.$refs.childEvent.id = ''
                _this.$refs.childEvent.title = ''
                _this.$refs.childEvent.desc = ''
                _this.$refs.childEvent.data = (new Date()).toLocaleDateString()
                _this.$refs.childEvent.editQ = false
            })
       },
       updateCurveFunc(newl){
           let d = new Date()
           this.newShow = false
           
           this.curveEventsList = this.curveEventsList.concat(newl)
        //    console.log(d.toLocaleDateString())
           this.$EventCalendar.toDate(d.toLocaleDateString())
       },
       delEventFunc(id){
           var newCurveLL = []
           for(let eEle of this.curveEventsList){
               if(eEle.id != id){
                   newCurveLL.push(eEle)
               }
           }
           this.curveEventsList = newCurveLL
       },
       editEvent(devent){
           this.newShow = true
        //    console.log(devent)
        //    console.log(this)
        //    console.log(this.$refs)
        //    this.$refs.childEvent.id = event.id
        //    this.$refs.childEvent.title = event.title
        //    this.$refs.childEvent.desc = event.desc
        //    this.$refs.childEvent.date = event.date
            let _this = this;

            let promise = new Promise(function(resolve) {
                setTimeout(function() {
                    console.log(_this.$refs)
                    resolve(devent);
                }, 300);
            });

            promise.then(function(de){
                _this.$refs.childEvent.id = de.id 
                _this.$refs.childEvent.title = de.title
                _this.$refs.childEvent.desc = de.desc
                _this.$refs.childEvent.data = de.date
                _this.$refs.childEvent.editQ = true
            })
       },
       closeForm(){
           this.newShow = false
       }
    },
    computed:{
        ccwidth(){
            if(document.documentElement.clientWidth > 800){
                return 700
            }else if(document.documentElement.clientWidth > 450){
                return document.documentElement.clientWidth - 10;
            }else{
                return document.documentElement.clientWidth - 40;
            }
        },
        loginQ_N: function(){
            return 'padding-top:'+ document.documentElement.clientHeight / 3 + "px;"+'max-height:'+ document.documentElement.clientHeight + "px;"
        }
    },
    created: function(){
    //   this.$refs.cachild.selectedDayEvents.events = []
        for(let de of this.demoEvents){
            // console.log(genCurveList(de))
            this.curveEventsList = this.curveEventsList.concat(genCurveList(de))
        }
        // this.curveEventsList = []
        // console.log(this.curveEventsList)

        // this.post("/acklogin",{}).then(function(resp){
        //     console.log(resp)
        // }).catch(err => {
        //     console.log(err)
        // })
        let _this = this
        axios.post("/acklogin",{}).then(resp => {
            // console.log(resp)
            if(resp && resp.data){
                if(resp.data.login && resp.data.status){
                    _this.loginQ = true
                    _this.curveEventsList = []
                    // console.log(resp.data)
                    for(let de of resp.data.events){
                        // console.log(de)
                        de['customClass'] = 'lxj-highlight'
                        _this.curveEventsList = _this.curveEventsList.concat(genCurveList(de))
                    }
                }
            }
        }).catch(err => {
            console.log(err)
        })
        
    },
    updated(){
        let d = new Date()
        this.$EventCalendar.toDate(d.toLocaleDateString())
    }
}
</script>

<style lang="less">
/* #app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
} */


@oringeColor :rgb(237, 223, 56);
@greenGrayColor: rgb(184, 199, 159);
@redColor: rgb(238, 67, 49);

#my_calendar{
    padding: 0.8em;
}

.lxj-highlight{
    span{
        // background-color: aquamarine !important;
        border-color: @redColor !important;
    }
}
.selected-day{
    span{
        background: linear-gradient(45deg,@redColor,@oringeColor) !important;
    }
}
.show-title{
    margin-left: 10%;
    text-align: left;
}

.button-add{
    margin-left: 15px;
    float: left;
    top: 50%;
}
.events-wrapper{
    border-radius: 20px !important;
    border-style: solid;
    border-width: 2px;
    // width: 90% !important;
    // margin-left: 5% !important;
    // margin-right: 5% !important;
    // border-color:linear-gradient(180deg,@oringeColor,@redColor) !important;
    border-color: @redColor;
    background: linear-gradient(45deg,@redColor,@oringeColor 20%,@oringeColor 80%,@redColor) !important;
}
.text-important{
    color: @redColor;
}

</style>
