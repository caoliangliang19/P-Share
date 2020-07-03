//
//  WechatTool.m
//  P-SHARE
//
//  Created by fay on 16/9/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "WechatTool.h"
#import "PayRequsestHandler.h"
@implementation WechatTool
//微信回调
-(void) onResp:(BaseResp*)resp
{
    MyLog(@"%d",resp.errCode);
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        switch (resp.errCode) {
            case WXSuccess:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"微信分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case WXErrCodeUserCancel:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"微信分享取消" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            default:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"微信分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
                
                break;
        }
    }
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:{
                MyLog(@"---微信--支付成功");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:WECHAT_PAY_NOTIFICATION object:@"success"];
                
                break;
            }
            default:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付失败" message:@"微信支付失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [[NSNotificationCenter defaultCenter] postNotificationName:WECHAT_PAY_NOTIFICATION object:@"fail"];

                MyLog(@"---微信--支付失败");
                
                
                
                break;
            }
        }
    }
    if([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{@"code":code};
            NSNotification *notification =[NSNotification notificationWithName:WECHAT_LOGIN_NOTIFICATION object:nil userInfo:dic];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
}


- (void)getAccess_token:(NSString *)code{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx7248073ee8171c2b",@"f6167b2ca139d51ba8653d8a7cc28888",code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                [self refreshAcressToken:dic[@"refresh_token"]];
            }
        });
    });
}
- (void)refreshAcressToken:(NSString *)string{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wx7248073ee8171c2b&grant_type=refresh_token&refresh_token=%@",string];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSString *access_token = [dic objectForKey:@"access_token"];
                NSString *openid = [dic objectForKey:@"openid"];
                [self getUserInfo:access_token opedID:openid];
                
            }
        });
        
    });
}
- (void)getUserInfo:(NSString *)accessToken opedID:(NSString *)openid{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openid];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (dic[@"openid"]) {

                    if (self.WechatToolSuccessBlock) {
                        self.WechatToolSuccessBlock(dic);
                    }
                    
                }else{
                }
            }
        });
        
    });
}


#pragma mark -- 微信支付
- (void)wechatToolPayWith:(NSDictionary *)dic
{
    if ([WXApi isWXAppInstalled]) {
        //创建支付签名对象
        PayRequsestHandler *req = [PayRequsestHandler alloc];
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];
        
        //配置微信回调URL
        self.weiXinNotiUrl = _WeChatUrl;
        
        
        NSString *priceStr = [NSString stringWithFormat:@"%.0f",[dic[@"orderPrice"] floatValue]*100];

        
        NSMutableDictionary *dict = [req sendPay_dictWithOrder_name:dic[@"orderName"] order_price:priceStr order_ID:dic[@"orderID"]];
        
        if(dict == nil){
            //错误提示
           #pragma mark -- 考虑订单为0元的情况  不可以一直提示订单重复
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单支付失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] postNotificationName:WECHAT_PAY_NOTIFICATION object:@"fail"];

        }else{
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
        }
    }else{
        

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未安装微信或版本不支持" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] postNotificationName:WECHAT_PAY_NOTIFICATION object:@"fail"];

        
    }

}
@end
