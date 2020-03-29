<template>
    <div class="cal-event">
        <div class="head-tap">
            <div class="cal-event-date-bt" :style="cal_event_date_bt_style">
                <van-button round type="default" @click="updateEventDate">
                    <span class="text-important-bol">{{date}} </span>
                </van-button>
            </div>
            <div class="del-event-container" v-if="editQ">
                <van-button round type="default" @click="delEvent">
                    <span class="text-important">删除</span>
                </van-button>
            </div>
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
            editQ: null
        };
    },
    computed:{
        cal_event_date_bt_style(){
            if(this.editQ){
                return "margin-left: 18%;"
            }else{
                return "margin-left: 1%;"
            }
        }
    },
    methods: {
        onSubmit(values) {
        // console.log('submit', values);
            let dt = new Date()
            let newl = genCurveList({
                date: dt.toLocaleDateString(),
                title: values.title,
                desc: values.desc,
                customClass:'lxj-highlight'
            })
            let _this = this
            if(this.editQ){
                axios.post("/edit_event",{
                    eventDate: _this.data, 
                    title: values.title,
                    contect: values.desc,
                    id: _this.id
                }).then(resp => {
                    if(resp && resp.data){
                        if(resp.data.status){
                            _this.title = ''
                            _this.desc = ''
                            _this.$emit('delEventFunc',_this.id)
                            _this.$emit('updateCurveFunc',newl)
                        }else{
                            if(resp.data.login){
                                this.$toast.fail("更新失败")
                            }else{
                                this.$toast.fail(resp.data.info)
                                _this.$parent.loginQ = true
                            }
                        }
                    }
                }).catch(err => {
                    console.log(err)
                    this.$toast.fail("服务器出错")
                })
            }else{
                axios.post("/new_event",{
                    eventDate: dt.toLocaleDateString(), 
                    title: values.title,
                    contect: values.desc
                }).then(resp => {
                    if(resp && resp.data){
                        if(resp.data.status){
                            _this.title = ''
                            _this.desc = ''
                            _this.$emit('updateCurveFunc',newl)
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
            this.$toast("暂时不支持修改日期")
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
                        _this.$emit('delEventFunc',_this.id)
                    }else{
                        this.$toast.fail("删除失败")
                    }
                })
                // _this.$parent.newShow = false
            }).catch(() => {
            //    _this.$parent.newShow = false
                _this.$emit("closeForm")
            });
            
            // let promise = new Promise(function(resolve) {
            //     setTimeout(function() {
            //         resolve();
            //     }, 500);
            // });

            //  promise.then(function(){
            //      _this.$parent.newShow = false
            //  })
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
</style>