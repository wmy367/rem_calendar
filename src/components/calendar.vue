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
                            <div class="time right-tap">
                                {{event.startDate}} 第<span class="text-important">{{event.circle+1}}</span>天
                                <van-checkbox @click="done_chkbx(event)" class="done-checkbx" v-model="event.done" checked-color="rgb(238, 67, 49)" >完成</van-checkbox>
                            </div>
                            <p class="desc">{{event.desc}}</p>
                        </div>
                    </div>
                </template>
            </vue-event-calendar>

            <van-dialog v-model="newShow" :showConfirmButton='false' closeOnPopstate closeOnClickOverlay :width="ccwidth">
                <!-- <img src="https://img.yzcdn.cn/vant/apple-3.jpg"> -->
                <!-- <newCurve v-on:updateCurveFunc="updateCurveFunc"/> -->
                <calEvent ref="childEvent" 
                v-on:updateCurveX="updateCurveX" 
                v-on:updateCurveFunc="updateCurveFunc" 
                v-on:delEventFunc="delEventFunc" 
                v-on:closeForm="closeForm" />
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
            // demoEvents: [ {
            //     id: 1,
            //     date: '2020/04/18',
            //     title: '学习',
            //     desc: '英语第一节',
            //     eventType: 'curve',
            //     doneList: {0: true,1: false},
            //     customClass: 'lxj-highlight' // Custom classes to an calendar cell
            // },
            // {
            //     id:2,
            //     date: '2020/04/28',
            //     title: '金融',
            //     desc: '模型',
            //     eventType: 'curve',
            //     doneList: {0: true,1: false},
            //     customClass: 'lxj-highlight' // Custom classes to an calendar cell
            // }],
            demoEvents:[],
            curveEventsList:[],
            newShow: false,
            cwidth: document.documentElement.clientWidth,
            cheight: document.documentElement.clientHeight,
            loginQ: false,
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
                _this.$refs.childEvent.eventType = 'curve'
                _this.$refs.childEvent.circle = 0
                _this.$refs.childEvent.yesCurve = true
                _this.$refs.childEvent.done = false
            })
       },
       updateCurveFunc(newl){
           let d = new Date()
           this.newShow = false
           
           this.curveEventsList = this.curveEventsList.concat(newl)
        //    console.log(d.toLocaleDateString())
           this.$EventCalendar.toDate(d.toLocaleDateString())
           this.chkEventNotDone()
       },
       updateCurveX(newl){
           let d = new Date()
           this.newShow = false
           
           this.curveEventsList = this.curveEventsList.concat(genCurveList(newl))
        //    console.log(d.toLocaleDateString())
           this.$EventCalendar.toDate(d.toLocaleDateString())
           this.chkEventNotDone()
       },
       delEventFunc(id,noOrigin){
           var newCurveLL = []
           for(let eEle of this.curveEventsList){
               if(eEle.id != id){
                   newCurveLL.push(eEle)
               }

               if(noOrigin && eEle.circle == 0){
                   newCurveLL.push(eEle)
                   this.eventType = 'normal'
               }
           }
           this.curveEventsList = newCurveLL
           this.chkEventNotDone()
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
            this.$EventCalendar.toDate(devent.date)
            let _this = this;

            let promise = new Promise(function(resolve) {
                // console.log(_this.$refs)
                setTimeout(function() {
                    // console.log(_this.$refs)
                    resolve(devent);
                }, 300);
            });

            promise.then(function(de){
                // console.log(de);
                _this.$refs.childEvent.id = de.id 
                _this.$refs.childEvent.title = de.title
                _this.$refs.childEvent.desc = de.desc
                _this.$refs.childEvent.date = de.date
                _this.$refs.childEvent.editQ = true
                _this.$refs.childEvent.eventType = de.eventType
                _this.$refs.childEvent.circle = de.circle
                _this.$refs.childEvent.yesCurve = de.eventType=="curve"
                _this.$refs.childEvent.done = de.done
            })
       },
       // 检查今天以前的没有完成的任务 
       chkEventNotDone(){
            // let td = new Date();

            var dateTime = new Date()
            dateTime=dateTime.setDate(dateTime.getDate()-1)
            dateTime=new Date(dateTime)

           for(let eEle of this.curveEventsList){
            //    console.log(eEle.done)
               if(!eEle.done){
                   if(dateTime > (new Date(eEle.date))){
                       eEle.customClass = 'lxj-not-done-highlight'
                   }
               }
           }
       },
       singleChkEventNotDone(event){
           var dateTime = new Date()
            dateTime=dateTime.setDate(dateTime.getDate()-1)
            dateTime=new Date(dateTime)
            event.customClass = 'lxj-highlight'
            if(!event.done){
                if(dateTime > (new Date(event.date))){
                    event.customClass = 'lxj-not-done-highlight'
                }
            }
       },
       closeForm(){
           this.newShow = false
       },
       toTargetdayShow(dStr){
            // let d = new Date()
            console.log(dStr)
            this.$EventCalendar.toDate(dStr)
       },
       done_chkbx(event){
            // console.log(event)
            // let copy_event = JSON.parse(JSON.stringify(event)) 
            let _this = this
            let promise = new Promise(function(resolve) {
                // console.log(_this.$refs)
                setTimeout(function() {
                    // console.log(_this.$refs)
                    resolve(event);
                }, 300);
            });

            promise.then(function(de){
                _this.done_chkbx_core(de)
            })
       },
       done_chkbx_core(event){
            var dateTime;
            if(event.origin){
                event.circle = 0
            }
            dateTime = new Date(event.date)
            dateTime=dateTime.setDate(dateTime.getDate() - event.circle)
            dateTime=new Date(dateTime)

            let doneHash = {}
            if(event.origin){
                doneHash[0] = event.done ? true : false
            }else{
                doneHash[event.circle] = event.done ? true : false
            }
            // console.log(copy_event)
            // console.log(doneHash)

            let _this = this
            axios.post("/edit_event",{
                eventDate: dateTime.toLocaleString(),
                id: event.id,
                doneList: doneHash,
            }).then(resp => {
                if(resp && resp.data){
                    if(resp.data.status){
                         _this.singleChkEventNotDone(event)
                        if(event.done){
                            this.$toast.success(event.title + " 完成")
                        }else{
                            this.$toast.success(event.title + " 未完成")
                        }
                    }else{
                        if(resp.data.login){
                            this.$toast.fail("更新失败 "+resp.data.info)
                        }else{
                            this.$toast.fail(resp.data.info)
                            _this.loginQ = true
                        }
                    }
                }
            })
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
                        _this.chkEventNotDone()
                    }
                }
            }
        }).catch(err => {
            console.log("无法连接服务器")
            console.log(err)
        })
        
        this.chkEventNotDone()
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
@ziColor: rgb(55, 238, 49);
#my_calendar{
    padding: 0.8em;
}

.lxj-highlight{
    span{
        // background-color: aquamarine !important;
        border-color: @redColor !important;
    }
}

.lxj-not-done-highlight{
    span{
        // background-color: aquamarine !important;
        border-color: @ziColor !important;
        z-index: 100;
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
.right-tap{
    display: -webkit-box;
}
.done-checkbx{
    margin-left: 2%;
}

</style>
