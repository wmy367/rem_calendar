<template>
    <div class="calendar-login">
        <van-form @submit="onSubmit">
            <van-field
                v-model="username"
                name="username"
                label="用户名"
                placeholder="用户名"
                label-width=60
                input-align='center'
                :rules="[{ required: true, message: '用户名' }]"
            />
           <van-field
                v-model="password"
                type="password"
                name="password"
                label="密码"
                placeholder="密码"
                label-width=60
                input-align='center'
                :rules="[{ required: true, message: '请填写密码' }]"
            />
            <div style="margin: 16px;">
                <van-button round block type="default" native-type="submit-cc" color="linear-gradient(to right,rgb(238, 67, 49),rgb(237, 223, 56) 25%,rgb(237, 223, 56) 92%,rgb(238, 67, 49))">
                    <span style="color:#000;">提交</span>
                </van-button>
            </div>
            <div class="login-up-contarner">
                <a href="#" @click="activeLoginUp"> <span class="text-important">注册</span> </a>
            </div>
        </van-form>
    </div>
</template>

<script>
import axios from 'axios'
import {genCurveList} from "./../js/curve_event.js"
export default {
    name: 'calendarLogin',
    data(){
        return{
            username: null,
            password: null
        }
    },
    methods:{
        onSubmit(value){
            let _this = this
            axios.post('/login',{username: value.username,password: value.password}).then(resp =>{
                if(resp && resp.data){
                    if(resp.data.status && resp.data.login){
                        this.$toast.success("登陆成功")
                        _this.$parent.loginQ = true;
                        // console.log(resp.data)
                        _this.$parent.curveEventsList = []

                        for(let de of resp.data.events){
                            de['customClass'] = 'lxj-highlight'
                            // console.log(de)
                            _this.$parent.curveEventsList = _this.$parent.curveEventsList.concat(genCurveList(de))
                        }
                    }else{
                        this.$toast.fail(resp.data.info)
                    }
                }else{
                    this.$toast.fail("服务器错误响应")
                }
            }).catch(err =>{
                console.log(err)
                this.$toast.fail("连接服务器失败")
            })
        },
        activeLoginUp(){
            console.log("login up")
            this.$parent.loginUpQ = true;
        }
    }
}
</script>
<style lang="less">
@redColor: rgb(238, 67, 49);
.calendar-login{
    margin: auto;
    // padding-top: 30%;
    max-height: 300px;
    max-width: 300px;
}
.login-up-contarner{
    // text-align: right;
    // margin-right: 22%;
    color: @redColor;
    font-size: small;
}
.text-important{
    color: @redColor;
}
</style>