//
//  QQTool.h
//  P-SHARE
//
//  Created by fay on 16/9/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import<TencentOpenAPI/QQApiInterface.h>
@interface QQTool : NSObject<QQApiInterfaceDelegate,TencentSessionDelegate>

@property (nonatomic,copy)void (^QQToolLoginCallBack)(NSDictionary *dic);



- (void)QQLogin;
- (void)QQBegin;

@end
