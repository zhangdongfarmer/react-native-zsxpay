/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View
} from 'react-native';
import Pay from 'react-native-zsxpay';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {
    constructor(props){
        super(props);
        this.state = {
            wechatInstalled:'未检测',
            registerRes:'未注册',
        }
    }
    wechatInstalledAction(){
        Pay.wechat_isWXAppInstalled((result)=>{
            this.setState({
                wechatInstalled:result==true?'已安装':'未安装',
            })
        })
    }
    wechatRegisterApp(){
        Pay.wechat_registerAppWithAppId('wxff2f053dffe7c8b6',(result)=>{
            if (result == null){
                this.setState({
                    registerRes:'已注册',
                })
            }
        })
    }
    wechatpay(){
        Pay.wechat_pay({partnerId:'1',prepayId:'1',packageValue:'1',nonceStr:'1',timeStamp:'1',sign:'1',},(callback)=>{
            console.log(callback);
        });
    }
    alipay(){
        Pay.alipay_pay('Hello','zsxPayAlipayScheme',(result)=>{
            console.log(result);
        });
    }
    uppay(){
        Pay.up_pay({info:'Hello'});
    }
    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome} onPress={()=>this.wechatInstalledAction()}>
                    微信安装：{this.state.wechatInstalled}
                </Text>
                <Text style={styles.welcome} onPress={()=>this.wechatRegisterApp()}>
                    注册微信AppId：{this.state.registerRes}
                </Text>
                <Text style={styles.welcome} onPress={()=>this.wechatpay()}>
                    wechat_pay
                </Text>
                <Text style={styles.welcome} onPress={()=>this.alipay()}>
                    alipay_pay
                </Text>
                <Text style={styles.welcome} onPress={()=>this.uppay()}>
                    up_pay
                </Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});
