<template>
    <div class="cal-event">
        <div class="head-tap">
            <van-row>
                <van-col span="6"  >
                    <van-button round type="default" icon="arrow-left"  @click="updateEventDateY">
                    </van-button>
                </van-col>
                <van-col span="12" >
                    <div class="cal-event-date-bt" :style="cal_event_date_bt_style">
                        <van-button round type="default" @click="updateEventDate">
                            <span class="text-important-bol">{{date}} </span>
                        </van-button>
                    </div>
                </van-col>
                <van-col span="6">
                    <van-button round type="default" icon="arrow"  @click="updateEventDateT">
                    </van-button>
                </van-col>
            </van-row>
        </div>
        <div class="head-tap">
            <van-row>
                <van-col span="8">
                    <div class="curve-event-container">
                        <van-checkbox v-model="yesCurve" checked-color="rgb(238, 67, 49)">记忆曲线</van-checkbox>
                    </div>
                </van-col>
                <van-col span="8">
                    <div class="curve-event-container">
                        <van-checkbox v-model="done" checked-color="rgb(238, 67, 49)" >完成</van-checkbox>
                    </div>
                </van-col>
                <van-col span="8">
                    <div class="del-event-container" v-if="editQ">
                        <van-button round type="default" @click="delEvent">
                            <span class="text-important">删除</span>
                        </van-button>
                    </div>
                </van-col>
            </van-row>
        </div>
        <van-form @submit="onSubmit">
            <van-field
                v-model="title"
                name="title"
                label="标题"
                placeholder="标题"
                label-width=40
                input-align='center'
                :rules="[{ required: true, message: '标题' }]"
            />
            <van-field
                v-model="desc"
                type="textarea"
                name="desc"
                label="内容"
                placeholder="内容"
                autosize
                label-width=40
                input-align='center'
                :rules="[{ required: false, message: '内容' }]"
            />
            <div style="margin: 16px;">
                <van-button round block type="default" native-type="submit-cc" color="linear-gradient(to right,rgb(238, 67, 49),rgb(237, 223, 56) 5%,rgb(237, 223, 56) 75%,rgb(238, 67, 49))">
                    <span style="color:#000;">提交</span>
                </van-button>
            </div>
        </van-form>
    </div>
</template>
<script>
import {genCurveList} from "./../js/curve_event.js"
import axios from 'axios'
export default {
    name: 'calEvent',
    data() {
        return {
            title: '',
            desc: '',
            date: (new Date()).toLocaleDateString(),
            id: '',
            circle: 0,
            editQ: null,
            eventType: true,
            yesCurve: true,
            done: false
        };
    },
    computed:{
        cal_event_date_bt_style(){
            if(this.editQ){
                return "margin-left: 0%;"
            }else{
                return "margin-left: 0%;"
            }
        },
    },
    methods: {
        onSubmit(values) {
        // console.log('submit', values);

            var dateTime;
            dateTime = new Date(this.date)
            dateTime=dateTime.setDate(dateTime.getDate() - this.circle)
            dateTime=new Date(dateTime)
            

    
            let dt = new Date()
            let newl = genCurveList({
                date: dt.toLocaleDateString(),
                title: values.title,
                desc: values.desc,
                customClass:'lxj-highlight'
            })
            let _this = this
            let doneHash = {}
            doneHash[this.circle] = _this.done

            if(this.editQ){
                axios.post("/edit_event",{
                    eventDate: dateTime.toLocaleDateString(), 
                    title: values.title,
                    contect: values.desc,
                    id: _this.id,
                    doneList: doneHash,
                    eventType: _this.yesCurve ? "curve" : "normal"
                }).then(resp => {
                    if(resp && resp.data){
                        if(resp.data.status){
                            _this.title = ''
                            _this.desc = ''

                            _this.$emit('delEventFunc',_this.id)
                            newl = resp.data.event
                            // console.log(newl)
                            _this.$emit('updateCurveX',newl)
                        }else{
                            if(resp.data.login){
                                this.$toast.fail("更新失败 "+resp.data.info)
                            }else{
                                this.$toast.fail(resp.data.info)
                                _this.$parent.loginQ = true
                            }
                        }
                    }
                    _this.$emit("closeForm")
                    // _this.$emit("toTargetdayShow",_this.date)
                }).catch(err => {
                    console.log(err)
                    this.$toast.fail("服务器出错")
                    _this.$emit("closeForm")
                    // _this.$emit("toTargetdayShow",_this.date)
                })
            }else{
                axios.post("/new_event",{
                    eventDate: dt.toLocaleDateString(), 
                    title: values.title,
                    contect: values.desc,
                    eventType: _this.yesCurve ? "curve" : "normal"
                }).then(resp => {
                    if(resp && resp.data){
                        if(resp.data.status){
                            _this.title = ''
                            _this.desc = ''
                            newl = resp.data.event
                            _this.$emit('updateCurveX',newl)
                        }else{
                            this.$toast.fail("创建失败")
                        }
                    }
                }).catch(err => {
                    console.log(err)
                    this.$toast.fail("服务器出错")
                })
            }
            
        },
        updateEventDate(){
            this.$toast("修改时间请点击两边箭头")
        },
        updateEventDateT(){
            var dateTime;
            dateTime = new Date(this.date)
            dateTime=dateTime.setDate(dateTime.getDate()+1)
            dateTime=new Date(dateTime)
            this.date = dateTime.toLocaleDateString()
        },
         updateEventDateY(){
            var dateTime = new Date(this.date)
            dateTime=dateTime.setDate(dateTime.getDate()-1)
            dateTime=new Date(dateTime)
            this.date = dateTime.toLocaleDateString()
        },
        delEvent(){
            // this.$toast("删除" + this.id)
            let _this = this
            this.$dialog.confirm({
                title: '删除',
                message: this.title
            }).then(() => {
                axios.post("/del_event",{
                    id: _this.id
                }).then(resp => {
                    if(resp.data && resp.data.status){
                        this.$toast.success("删除成功")
                        _this.$emit("closeForm")
                        // _this.$emit("toTargetdayShow",_this.date)
                        _this.$emit('delEventFunc',_this.id)
                    }else{
                        this.$toast.fail("删除失败")
                    }
                })
                // _this.$parent.newShow = false
            }).catch(() => {
            //    _this.$parent.newShow = false
                _this.$emit("closeForm")
                // _this.$emit("toTargetdayShow",_this.date)
            });
            
            // let promise = new Promise(function(resolve) {
            //     setTimeout(function() {
            //         resolve();
            //     }, 500);
            // });

            //  promise.then(function(){
            //      _this.$parent.newShow = false
            //  })
        },
        triCurve(){
            let _this = this
            var dateTime = new Date(this.date)
            console.log(this.date)
            console.log(this.circle)
            dateTime=dateTime.setDate(dateTime.getDate()-this.circle)
            dateTime=new Date(dateTime)

            let newl = genCurveList({
                date: dateTime.toLocaleDateString(),
                title: _this.title,
                desc: _this.desc,
                customClass:'lxj-highlight',
                eventType: !_this.yesCurve ? "curve" : "normal"
            })

            // console.log(_this.id)
            _this.$emit('delEventFunc',_this.id)

            _this.$emit('updateCurveFunc',newl)
        }
    },
    
}
</script>

<style lang="less">
@oringeColor :rgb(237, 223, 56);
@greenGrayColor: rgb(184, 199, 159);
@redColor: rgb(238, 67, 49);

.cal-event{
    margin: auto;
    padding: 10px;
    max-width: 600px;
}
.cal-event-date-bt{
    color: @redColor;
    display: inline-block;
}

.text-important{
    color: @redColor;
}
.text-important-bol{
    color: @redColor;
    font-size: large;
    display: inline-block;
}
.del-event-container{
    margin-right: 5%;
    // display: inline-block;
    float: right;
}
.head-tap{
    // display: inline;
    width: inherit;
}

.head-tap-right{
    margin-right: 5%;
    // display: inline-block;
    float: right;
    width: inherit;
}

.curve-event-container{
    margin-top: 9%;
    // display: inline-block;
    float: left;
    font-size: small;
}
</style>