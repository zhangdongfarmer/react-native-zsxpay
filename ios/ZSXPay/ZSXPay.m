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

@implementation ZSXPay

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
    NSLog(@"");
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
RCT_EXPORT_METHOD(wechat_pay:(NSDictionary *)param) {
    [WXApi registerApp:@"wxff2f053dffe7c8b6"];
    if ([param isKindOfClass:[NSMutableDictionary class]] || [param isKindOfClass:[NSDictionary class]]) {
        PayReq *request       = [[PayReq alloc] init];
        request.partnerId     = [NSString stringWithFormat:@"%@1",param[@"partnerid"]];
        request.prepayId      = [NSString stringWithFormat:@"%@1",param[@"prepayid"]];
        request.package       = [NSString stringWithFormat:@"%@1",param[@"package"]];
        request.nonceStr      = [NSString stringWithFormat:@"%@1",param[@"noncestr"]];
        request.timeStamp     = [[NSDate date]timeIntervalSince1970];
        request.sign          = [NSString stringWithFormat:@"%@1",param[@"sign"]];
        [WXApi sendReq:request];
    }
}

RCT_EXPORT_METHOD(wechat_isWXAppInstalled:(RCTResponseSenderBlock)callback)
{
    callback(@[[NSNull null], @([WXApi isWXAppInstalled])]);
}
#pragma mark end

RCT_EXPORT_METHOD(alipay_pay:(NSString *)orderString) {
    if (orderString.length) {
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"testAlipayScheme" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

RCT_EXPORT_METHOD(up_pay:(NSDictionary *)param) {
    [[UPPaymentControl defaultControl] startPay:@"11" fromScheme:@"uppaywalletTest" mode:@"01" viewController:[UIApplication sharedApplication].delegate.window.rootViewController];
}

@end
