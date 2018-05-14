import React, { NativeModules } from 'react-native';

export default class Pay {
    /***************** 微信版块 *****************/

    /** WXApi的成员函数，向微信终端程序注册第三方应用。
     *
     * appid 微信开发者ID
     * callback 成功返回null，失败返回错误信息。
     */
    static wechat_registerAppWithAppId(appid,callback) {
        NativeModules.ZSXPay.wechat_registerAppWithAppId(appid,callback);
    }

    /** 微信支付
     *
     * param 参数
     * 传入参数示例
     * {
        partnerId:data.partnerId,
        prepayId: data.prepayId,
        packageValue: data.data.packageValue,
        nonceStr: data.data.nonceStr,
        timeStamp: data.data.timeStamp,
        sign: data.data.sign,
       }
     *
     * @return 返回支付结果
     */
    static wechat_pay(param,callback) {
        NativeModules.ZSXPay.wechat_pay(param,callback);
    }

    /** 检查微信是否已被用户安装
     *
     * @return 微信已安装返回true，未安装返回false
     */
    static wechat_isWXAppInstalled(callback) {
        NativeModules.ZSXPay.wechat_isWXAppInstalled(callback);
    }


    /***************** 支付宝版块 *****************/
    /** 支付宝支付
     *
     *@return 返回支付结果
     */
    static alipay_pay(orderString,scheme,callback) {
        NativeModules.ZSXPay.alipay_pay(orderString,scheme,callback);
    }

    /***************** 银联版块 *****************/
    static up_pay(param) {
        NativeModules.ZSXPay.up_pay(param);
    }
}