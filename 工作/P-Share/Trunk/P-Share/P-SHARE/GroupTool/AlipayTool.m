//
//  AlipayTool.m
//  P-SHARE
//
//  Created by fay on 16/9/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "AlipayTool.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AlipayTool
- (void)AlipayWithDic:(NSDictionary *)dic
{
    NSURL *url = [NSURL URLWithString:[@"alipay://" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您未安装支付宝或版本不支持" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] postNotificationName:ALIPAY_PAY_NOTIFICATION object:@"fail"];

        return;
    }
    
    AlipaySDK *alipay = [AlipaySDK defaultService];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    /*=======================需要填写商户app申请的===================================*/
    
    NSString *partner       = ALIPAY_PARTNER;
    NSString *seller        = ALIPAY_SELLER;
    NSString *privateKey    = ALIPAY_PRIVATE_KEY;
    //*============================================================================*/
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = dic[ORDER_ID]; //订单ID（由商家自行制定）
    order.productName = dic[ORDER_NAME]; //商品标题
    order.productDescription = dic[ORDER_DESCRIBUTE]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[dic[ORDER_PRICE] floatValue]]; //商品价格
    order.notifyURL =  [GroupManage shareGroupManages].alipayCallBackURL; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = ALIPAY_KEY;
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        [alipay payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            if ([resultDic[@"resultStatus"] isEqualToString:@"6001"]) {
                MyLog(@"--支付宝-支付失败--%@",resultDic[@"memo"]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付失败" message:resultDic[@"memo"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [[NSNotificationCenter defaultCenter] postNotificationName:ALIPAY_PAY_NOTIFICATION object:@"fail"];


            }else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
                NSArray *resultStringArray =[resultDic[@"result"]componentsSeparatedByString:@"&"];
                for (NSString *str in resultStringArray)
                {//             success=\"true\"
                    NSString *newstring = nil;
                    newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
                    for (int i = 0 ; i < [strArray count] ; i++)
                    {
                        NSString *st = [strArray objectAtIndex:i];
                        if ([st isEqualToString:@"success"])
                        {
                            if ([[strArray objectAtIndex:1] isEqualToString:@"true"]) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:ALIPAY_PAY_NOTIFICATION object:@"success"];

                                MyLog(@"----支付宝支付成功-");
                                                                
                            }
                        }
                    }
                }
            }
        }];
    }

}
@end
