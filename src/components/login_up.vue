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
            <van-field
                v-model="password_comfirm"
                type="password"
                name="password_comfirm"
                label="密码确认"
                placeholder="密码确认"
                label-width=60
                input-align='center'
                :rules="[{ required: true, validator: validatorPw,message: '密码不匹配' }]"
            />
            <div style="margin: 16px;">
                <van-button round block type="default" native-type="submit-cc" color="linear-gradient(to right,rgb(238, 67, 49),rgb(237, 223, 56) 10%,rgb(237, 223, 56) 85%,rgb(238, 67, 49))">
                    <span style="color:#000;">提交</span>
                </van-button>
            </div>
        </van-form>
    </div>
</template>

<script>

import axios from 'axios'
// import  Notify from 'vant'
// import  Toast from 'vant'

export default {
    name: 'calendarLoginUp',
    data(){
        return{
            username: null,
            password: null,
            password_comfirm: null,
        }
    },
    methods:{
        onSubmit(value){
            // console.log(value)
            // Toast.success("909090")
            // this.$notify('通知内容');
            let _this = this
            axios.post("/loginup",{username: value.username,password: value.password,password_comfirm: value.password_comfirm}).then(resp => {
                // console.log(resp.data)
                // this.$toast.success("909090")
                if(resp.data){
                    if(resp.data.status){
                    //创建用户成功
                        this.$toast.success("创建用户成功")
                        _this.$parent.loginQ = true
                        _this.$parent.loginUpQ = false
                    }else{
                        this.$toast.fail(resp.data.info)
                        // this.$toast.fail("创建用户不成功")
                    }
                }else{
                    this.$toast.fail("创建用户不成功")
                }
            }).catch(err => {
                console.log(err)
                this.$toast.fail("服务器出错")
            })
        },
        validatorPw(val){
            return this.password == this.password && val;
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