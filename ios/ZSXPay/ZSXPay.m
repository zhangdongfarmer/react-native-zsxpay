//
//  ZSXPay.m
//  ZSXPay
//
//  Created by yh-zsx on 2018/5/8.
//  Copyright © 2018年 yh-zsx. All rights reserved.
//

#import "ZSXPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UPPaymentControl.h"

// Define error messages
#define NOT_REGISTERED (@"registerApp required.")
#define INVOKE_FAILED (@"WeChat API invoke returns false.")

@implementation ZSXPay {
    RCTResponseSenderBlock wxCallBack;
    RCTResponseSenderBlock upCallBack;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:@"RCTOpenURLNotification" object:nil];
    }
    return self;
}

- (BOOL)handleOpenURL:(NSNotification *)aNotification
{
    NSString * aURLString =  [aNotification userInfo][@"url"];
    NSURL * aURL = [NSURL URLWithString:aURLString];
    if ([aURL.host isEqualToString:@"safepay"]) { //支付宝
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:aURL standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    else if ([aURL.host isEqualToString:@"uppayresult"]) { //银联
        [[UPPaymentControl defaultControl] handlePaymentResult:aURL completeBlock:^(NSString *code, NSDictionary *data) {
            NSLog(@"%@",data);
        }];
    }
    
    if ([WXApi handleOpenURL:aURL delegate:self])
    {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark WXApiDelegate
-(void)onReq:(BaseReq *)req {
    NSLog(@"");
}

-(void)onResp:(BaseResp *)resp {
    wxCallBack(@[@(0)]);
}
#pragma mark end

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(pay:(NSString *)info) {
    NSLog(@"%@",info);
}
#pragma mark 微信接口
RCT_EXPORT_METHOD(wechat_registerAppWithAppId:(NSString *)appid :(RCTResponseSenderBlock)callback)
{
    callback(@[[WXApi registerApp:appid] ? [NSNull null] : INVOKE_FAILED]);
}
RCT_EXPORT_METHOD(wechat_pay:(NSDictionary *)param:(RCTResponseSenderBlock)callback) {
    wxCallBack = callback;
    if (( [param isKindOfClass:[NSMutableDictionary class]] || [param isKindOfClass:[NSDictionary class]] ) && param.allKeys.count) {
        PayReq *request       = [[PayReq alloc] init];
        request.partnerId     = [NSString stringWithFormat:@"%@",param[@"partnerid"]];
        request.prepayId      = [NSString stringWithFormat:@"%@",param[@"prepayid"]];
        request.package       = [NSString stringWithFormat:@"%@",param[@"package"]];
        request.nonceStr      = [NSString stringWithFormat:@"%@",param[@"noncestr"]];
        request.timeStamp     = [[NSString stringWithFormat:@"%@",param[@"timeStamp"]]intValue];
        request.sign          = [NSString stringWithFormat:@"%@",param[@"sign"]];
        [WXApi sendReq:request];
    }
    else {
        wxCallBack(@[@(-1)]);
    }
}

RCT_EXPORT_METHOD(wechat_isWXAppInstalled:(RCTResponseSenderBlock)callback)
{
    callback(@[@([WXApi isWXAppInstalled])]);
}
#pragma mark end

RCT_EXPORT_METHOD(alipay_pay:(NSString *)orderString:(NSString *)scheme:(RCTResponseSenderBlock)callback) {
    if (orderString.length) {
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:scheme callback:^(NSDictionary *resultDic) {
            callback(@[resultDic]);
        }];
    }
}

RCT_EXPORT_METHOD(up_pay:(NSDictionary *)param) {
    [[UPPaymentControl defaultControl] startPay:@"11" fromScheme:@"uppaywalletTest" mode:@"01" viewController:[UIApplication sharedApplication].delegate.window.rootViewController];
}

@end
