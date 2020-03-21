<template>
    <div class="new-curve">
        <van-form @submit="onSubmit">
            <van-field
                v-model="username"
                name="title"
                label="标题"
                placeholder="标题"
                label-width=40
                input-align='center'
                :rules="[{ required: true, message: '标题' }]"
            />
            <van-field
                v-model="password"
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
export default {
    name: 'newCurve',
    data() {
        return {
            username: '',
            password: '',
        };
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

            this.$emit('updateCurveFunc',newl)
        },
    },
}
</script>

<style lang="less">
@oringeColor :rgb(237, 223, 56);
@greenGrayColor: rgb(184, 199, 159);
@redColor: rgb(238, 67, 49);

.new-curve{
    margin: auto;
    padding: 10px;
    max-width: 600px;
}
</style>