//
//  WechatTool.h
//  P-SHARE
//
//  Created by fay on 16/9/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface WechatTool : NSObject<WXApiDelegate>
- (void)getAccess_token:(NSString *)code;
- (void)wechatToolPayWith:(NSDictionary *)dic;

@property (nonatomic,copy)NSString *AlipayUrl,*WeChatUrl;
@property (nonatomic,copy)NSString *weiXinNotiUrl;

@property (nonatomic,copy)void (^WechatToolSuccessBlock)(NSDictionary *);
@property (nonatomic,copy)void (^WechatToolFailBlock)(NSString *);

@end
