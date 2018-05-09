//
//  ZSXPay.h
//  ZSXPay
//
//  Created by yh-zsx on 2018/5/8.
//  Copyright © 2018年 yh-zsx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import "WXApi.h"

@interface ZSXPay : NSObject<RCTBridgeModule,WXApiDelegate>

@end
