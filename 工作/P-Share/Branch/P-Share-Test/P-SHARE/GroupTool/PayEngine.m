//
//  PayEngine.m
//  P-SHARE
//
//  Created by fay on 16/9/19.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PayEngine.h"
#import "WechatTool.h"
#import "AlipayTool.h"
@implementation PayEngine
+ (void)payOrderWithType:(PayEngineType)type WithDic:(NSDictionary *)dic
{
    if (type == PayEngineTypeWechat) {
        WechatTool *wechatTool = [[WechatTool alloc] init];
        wechatTool.WeChatUrl = [NSString stringWithFormat:@"%@payment/wechat/backpay_%@",SERVER_URL,[dic objectForKey:ORDER_TYPE]];
        [GroupManage shareGroupManages].wechatCallBackURL =  wechatTool.WeChatUrl;
        [wechatTool wechatToolPayWith:dic];
    }else if(type == PayEngineTypeAlipay)
    {
        AlipayTool *alipayTool = [[AlipayTool alloc] init];
        [GroupManage shareGroupManages].alipayCallBackURL = [NSString stringWithFormat:@"%@payment/alipay/backpay_%@",SERVER_URL,[dic objectForKey:ORDER_TYPE]];
        [alipayTool AlipayWithDic:dic];
    }
}

@end
