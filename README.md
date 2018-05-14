# react-native-zsxpay
##简介
（测试阶段...）ReactNative 集成微信、支付宝、银联支付，可自动配置环境，当前只支持iOS
##安装配置

导入：
```npm install react-native-zsxpay``` 

自动配置环境：```react-native link``` or ```react-native link react-native-zsxpay```

####iOS：
#####1、添加所需依赖库：
```
CoreMotion.framework
CFNetwork.framework
Foundation.framework
UIKit.framework
CoreGraphics.framework
CoreText.framework
CoreTelephony.framework
QuartzCore.framework
SystemConfiguration.framework
libz.tbd
libc++.tbd
libsqlite3.0.tbd
Security.framework
```

#####2、Appdelegate.m加入
```
#import <React/RCTLinkingManager.h>
```

```
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  return [RCTLinkingManager application:application openURL:url
                      sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
  return [RCTLinkingManager application:application openURL:url options:options];
}
```
#####3、添加白名单
#####4、添加scheme
####Android：

##使用说明
```
import Pay from 'react-native-zsxpay';
```
###微信板块
####1、向微信终端程序注册第三方应用：
callback：成功返回null，失败返回错误信息

```
Pay.wechat_registerAppWithAppId('wxXXXXXXXXXXX',(callback)=>{
            if (result == null){
                this.setState({
                    registerRes:'已注册',
                })
            }
        })
```
####2、检查微信是否已被用户安装：
callback：微信已安装返回YES，未安装返回NO。

```
Pay.wechat_isWXAppInstalled((callback)=>{
            this.setState({
                wechatInstalled:result==true?'已安装':'未安装',
            })
        })
```
####3、发起微信支付：
callback：返回支付结果：0：成功； 1、失败；  2、失败；

```
Pay.wechat_pay({partnerId:'1',prepayId:'1',packageValue:'1',nonceStr:'1',timeStamp:'1',sign:'1',},(callback)=>{
            console.log(callback);
        });
```

###支付宝板块
callback：返回支付结果
####1、发起支付宝支付：
```
Pay.alipay_pay('orderString','zsxPayAlipayScheme',(result)=>{
            console.log(callback);
        });
```

###银联板块