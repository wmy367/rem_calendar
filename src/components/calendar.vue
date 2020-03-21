<template>
  <div id="my_calendar">
        <div class="button-add">
            <van-button type="warning" round icon="plus" hairline @click="triggerShow" color="linear-gradient(0deg,rgb(237, 223, 56),rgb(238, 67, 49))"></van-button>
        </div>
         
        <vue-event-calendar ref="cachild" :events="curveEventsList">
             <template scope="props">
                <div v-for="(event, index) in props.showEvents" v-bind:key="'sub_k'+index" class="event-item">
                <!-- 这里拿到的是传入的单个event所有数据 -->
                <!-- {{event.desc}} -->
                    <div class="curver-container-wrapper">
                        <h3 class="title show-title">{{index}}. {{event.title}}</h3>
                        <p class="time">{{event.startDate}} 第{{event.circle+1}}天</p>
                        <p class="desc">{{event.desc}}</p>
                    </div>
                </div>
            </template>
        </vue-event-calendar>

        <van-dialog v-model="newShow" :showConfirmButton='false' closeOnPopstate closeOnClickOverlay :width="ccwidth">
            <!-- <img src="https://img.yzcdn.cn/vant/apple-3.jpg"> -->
            <newCurve v-on:updateCurveFunc="updateCurveFunc"/>
        </van-dialog>
       
  </div>
</template>

<script>

import {genCurveList} from "./../js/curve_event.js"
import newCurve from "./new_calender.vue"
export default {
    name: 'MyCalendar',
    components:{
        newCurve,
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
            cwidth: document.documentElement.clientclientWidth,
        }
    },
    methods: {
       triggerShow(){
           this.newShow = !this.newShow
       },
       updateCurveFunc(newl){
           let d = new Date()
           this.newShow = false
           this.curveEventsList = this.curveEventsList.concat(newl)
        //    console.log(d.toLocaleDateString())
           this.$EventCalendar.toDate(d.toLocaleDateString())
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
    width: 90% !important;
    margin-left: 5% !important;
    margin-right: 5% !important;
    // border-color:linear-gradient(180deg,@oringeColor,@redColor) !important;
    border-color: @redColor;
    background: linear-gradient(45deg,@redColor,@oringeColor 20%,@oringeColor 80%,@redColor) !important;
}
</style>
