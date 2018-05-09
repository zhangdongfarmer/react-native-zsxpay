import React, { NativeModules } from 'react-native';

export default class Pay {
    /******微信板块******/
    static wechat_pay(param) {
            NativeModules.ZSXPay.wechat_pay(param);
    }


    /******支付宝板块******/
    static alipay_pay(orderString) {
        NativeModules.ZSXPay.alipay_pay(orderString);
    }

    /******银联板块******/
    static up_pay(param) {
        NativeModules.ZSXPay.up_pay(param);
    }
}