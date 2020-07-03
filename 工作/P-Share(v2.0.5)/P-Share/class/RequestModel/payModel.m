//
//  payModel.m
//  P-Share
//
//  Created by fay on 16/1/15.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "payModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Order.h"
#import "OrderModel.h"
#import "payRequsestHandler.h"

@implementation payModel

- (void)payWithAlipayDic:(NSDictionary *)OrderDic CanOpenAlipay:(void (^)(BOOL isCan))open Completion:(void (^)(BOOL isSuccess))completion Fail:(void (^)(BOOL fail))fail
{
    
    NSURL *url = [NSURL URLWithString:[@"alipay://" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        
        if (open) {
            open(NO);
        }
        
        return;
    }
    
    AlipaySDK *alipay = [AlipaySDK defaultService];
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    /*=======================需要填写商户app申请的===================================*/
//    NSString *partner = @"2088021550883080";
//    NSString *seller = @"zhifu@forwell-parking.com";
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKMLgUUYUTqwDOWaEg3ZqZ9A5UBjP8KO+xdpTmc1zv1c5EpMXVdXD7P6OuKHHNUAhu4gICEiB7+bLDSkro9gLcl99vyzblbTXBI1iSlPSq3mKfP8SVh1ZGZh1FDIMDX7KCju8jEKU1oUtiZkIJaGKlH+fYigQhPf+yPaOGEOm17vAgMBAAECgYBIZBFPRk66ifQP9WpSr/O5+6xN/EMQ9T7S1DS1apSutZG+000WPFeCh3Whom/Qut0t2SGq1FswXYsxDHVcv01UVYNrsmOf/bszI04cG3LVVoxPdF6g+oNMvNLBlYznpo4VLmMUDnN63YsgH1QRg8FIB01pU+KGa/knnUB1yEMEsQJBANSICl5IxpsspRb0xUYKDVQErfpeOK5dC0A1UddQvkhuNg7J5nWhuKjucGd3vYpzZFVt0lLZ69ScYhfu7rJluQ0CQQDEZGVpBKxy20Ig8bA6vaxLiX+lIrJ2fZ+T21z4PcCemWYkF5bPQahPPW3brvsn2u5b7TyQV50fNEjR7cgUhIDrAkEAndbq3FrwJQ5jDUl7uSh9/Yf8LZUMQ3KWiHkQ7vfoWaKAQztvDK2ulsd+c1laSxiny0pkiWOO4bfCokOwwo0JgQJBALX4IE6yWecCab+Esbl7zY0gFfm4sItB0v55HyeUcEmD8TQ39zCKsZzaWlRXSbegD4N1ycwkoh0roN2C6QS50YkCQBIFFvVQeEy9tUfvX6eG+d+xhjUIaUOY/E4Oo3vi4fy0Vsbtx2AAJlgk8RhWEyS2fsXZ8h/HD0yAIjs5EDDlLnc=";
    
    NSString *partner = @"2088121588102143";
    NSString *seller = @"pay@p-share.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALFQALWFC64BQ/2y+nC8yUtoKxSMCAukCFRgbivbUC3GIfEw3kucaFkciOQCa552A4JcnUThohGXHmz9wDrlSfjmNbgDGsnkebib3S8dT8HlEIMqWGsx3a6UVPNbxZSaq9QCjR9/jYt9WBegh2aAjP9JL79Zvf4HZ5gKjcLwhV0xAgMBAAECgYAS9dsdjfyRvtDmcB0XsRhVV+5DZDX4CLJbU3R0fB82xdkbUX5z12XRIZwBxcB8UWJOrlii5P3Po7k9LmU/5wThyyT2OEPUj0eFChKMMwynVVt0DnCwAGkBOdvawE50H6O/zCJueYz9Awydzjzn0Sgn/NPHys77DIvyZ/o9L47xgQJBANxODmrSo/RsoMaUVswJltg5LGaboFx6+kZCfXJYa8Jx7QVjYDjfHCRFimpKuUIgPx8X67+czHszIKRDZTViiQ8CQQDOCq5fOHu97fVKfKJXYUJbDxrJaK9St/pWXIU/l6oVTvbGJBlul2aUVlHIjIdS4eVjhrVCy6Vv5QQdWor2TzW/AkEAv7EHqHmKggb3SnMOp1F8uL3e3ZVyzqWPGg2G3DUF5tZ8l+ClfDbeZM1BqEVGt7wZUHPfBQZpgpW1RFkEOpR3jwJACIXqlqfIfp/UUMN9F64/R3MFgaVh80MHCQGExY+pin4cuS+PGcMLjEFR2sDtbCFKEubkoqG38zv/ApPXQb8fEwJAbvYuhWdUVqjV4SE0ijgT2MNexC0RctieTEkYSrlLL0tPowHjCt1KjOrL0HSuO5vemGL8e7J+4WXSbbh/Z3zNSA==";
    

//       *============================================================================*/
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    //    order.tradeNO = self.parkInfoDict[@"order_id"]; //订单ID（由商家自行制定）
    order.tradeNO = _orderID; //订单ID（由商家自行制定）
    order.productName = _orderName; //商品标题
    order.productDescription = _orderDescribute; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",[_orderPrice floatValue]]; //商品价格
    
    order.notifyURL =  _AlipayUrl; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"wx0112a93a0974d61b";
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
                if (fail) {
                    fail(NO);
                }
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
                                MyLog(@"----支付宝支付成功-");
                                
                                if (completion) {
                                    completion(YES);
                                    
                                }
                            
                            }
                        }
                    }
                }
            }
        }];
    }

    
}

- (void)payWithWeChatDic:(NSDictionary *)OrderDic CanOpenWeChat:(void (^)(BOOL isCan))open Completion:(void (^)(BOOL isSuccess))completion Fail:(void (^)(BOOL fail))fail
{
    if ([WXApi isWXAppInstalled]) {
        //创建支付签名对象
        payRequsestHandler *req = [payRequsestHandler alloc];
        //初始化支付签名对象
        [req init:APP_ID mch_id:MCH_ID];
        //设置密钥
        [req setKey:PARTNER_ID];       
        
        //配置微信回调URL
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        app.weiXinNotify_url = _WeChatUrl;
        
        //    1445159356  1445159567  1445159595  1445159612
        //获取到实际调起微信支付的参数后，在app端调起支付
        //    NSMutableDictionary *dict = [req sendPay_dict];
        
        NSString *priceStr = [NSString stringWithFormat:@"%.0f",[_orderPrice floatValue]*100];        
        NSMutableDictionary *dict = [req sendPay_dictWithOrder_name:_orderName order_price:priceStr order_ID:_orderID];
        
        if(dict == nil){
            //错误提示
            if (fail) {
                fail(NO);
            }
#pragma mark -- 考虑订单为0元的情况  不可以一直提示订单重复
            
        }else{
            //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
            
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
            if (completion) {
                completion(YES);
            }
        }
    }else{
//        ALERT_VIEW(@"您未安装微信或版本不支持");
        
        if (open) {
            open(NO);
        }
    
    }

}

#pragma mark --优惠／临停支付失败调用

- (void)payFailWithDic:(NSDictionary *)dic;
{
    NSString *urlString = [PAYFAIL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    RequestModel *model = [RequestModel new];
    [model getRequestWithURL:urlString WithDic:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            
            if ([dict[@"code"] isEqualToString:@"000000"])
            {
                MyLog(@"success");
                
            }else{
                MyLog(@"fail");
                
            }
        }

    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
}

#pragma mark -- 检查优惠券是否可用
- (void)checkCouponIsUsed:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail
{
    
    NSString *url = [COUPONISUES stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    RequestModel *model = [RequestModel new];
    [model getRequestWithURL:url WithDic:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject);
        }

    } error:^(NSString *error) {
        if (fail) {
            fail(error);
        }
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
    }];
    

}

#pragma mark -- 获取停车码
- (void)requestTingCheMaWith:(NSDictionary *)dic Completion:(void (^)(NSDictionary *dic))completion Fail:(void (^)(NSString *error))fail
{
    NSString *urlString = [GET_PAYMENT_CODE stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    RequestModel *model = [RequestModel new];
    
    [model getRequestWithURL:urlString WithDic:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = responseObject;
            if (completion) {
                completion(dict);
            }
            
        }

    } error:^(NSString *error) {
        if (fail) {
            fail(error);
        }
    } failure:^(NSString *failInfo) {
        if (fail) {
            fail(failInfo);
        }
    }];
}


@end
