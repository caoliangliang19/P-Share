//
//  NotificationCenter.m
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "NotificationCenter.h"

@implementation NotificationCenter

NSString *const KUSER_CHOOSE_PARKING                = @"parking";
NSString *const NETWORK_STATUS                      = @"networkStatus";
NSString *const KUSER_CHOOSE_CAR                    = @"car";
NSString *const KUSER_CHOOSE_CARTYPE                = @"CarSubKindVCChoseCarType";
NSString *const KUSER_CAR_CHANGE                    = @"UserCarChange";
NSString *const WECHAT_LOGIN_NOTIFICATION           = @"WeChatLoginNotifocation";
NSString *const LOGIN_SUCCESS                       = @"loginSuccess";
NSString *const LOGOUT_SUCCESS                      = @"logoutSuccess";
NSString *const KCUSTOMER_ID                        = @"customerId";
NSString *const KCUSTOMER_MOBILE                    = @"customerMobile";
NSString *const KHEADIMG_URL                        = @"customerHead";
NSString *const KCUSTOMER_NICKNAME                  = @"customerNickname";
NSString *const KCARLIFT_PARKINGID                  = @"carLiftParkingID";
NSString *const KCARLIFT_PARKINGNAME                = @"carLiftParkingName";
NSString *const KMAP_MOVE                           = @"mapMove";
NSString *const KMAP_BUBBLE_CLICK                   = @"mapBubbleClick";
NSString *const KUSER_HOMEPARK                      = @"homeParking";
NSString *const MapVC_WillAppear                    = @"MapVCWillAppear";



//支付相关
NSString *const ORDER_PRICE                         = @"orderPrice";
NSString *const ORDER_NAME                          = @"orderName";
NSString *const ORDER_DESCRIBUTE                    = @"orderDescribute";
NSString *const ORDER_ID                            = @"orderID";
NSString *const ORDER_TYPE                          = @"orderType";
NSString *const WECHAT_PAY_NOTIFICATION             = @"wechatPaynotifocation";
NSString *const ALIPAY_PAY_NOTIFICATION             = @"alipayPaynotifocation";
NSString *const KYUYUE_PAY_SUCCESS                  = @"kYuyuePaySuccess";
NSString *const KYCL_PAY_SUCCESS                    = @"kYCLPaySuccess";


NSString *const ALIPAY_PARTNER                      = @"2088121588102143";

NSString *const ALIPAY_SELLER                       = @"pay@p-share.com";

NSString *const ALIPAY_KEY                          = @"wx0112a93a0974d61b";

NSString *const JPUSH_KEY                           = @"68d3b6ab608d1635d484267a";

NSString *const ALIPAY_PRIVATE_KEY                  = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALFQALWFC64BQ/2y+nC8yUtoKxSMCAukCFRgbivbUC3GIfEw3kucaFkciOQCa552A4JcnUThohGXHmz9wDrlSfjmNbgDGsnkebib3S8dT8HlEIMqWGsx3a6UVPNbxZSaq9QCjR9/jYt9WBegh2aAjP9JL79Zvf4HZ5gKjcLwhV0xAgMBAAECgYAS9dsdjfyRvtDmcB0XsRhVV+5DZDX4CLJbU3R0fB82xdkbUX5z12XRIZwBxcB8UWJOrlii5P3Po7k9LmU/5wThyyT2OEPUj0eFChKMMwynVVt0DnCwAGkBOdvawE50H6O/zCJueYz9Awydzjzn0Sgn/NPHys77DIvyZ/o9L47xgQJBANxODmrSo/RsoMaUVswJltg5LGaboFx6+kZCfXJYa8Jx7QVjYDjfHCRFimpKuUIgPx8X67+czHszIKRDZTViiQ8CQQDOCq5fOHu97fVKfKJXYUJbDxrJaK9St/pWXIU/l6oVTvbGJBlul2aUVlHIjIdS4eVjhrVCy6Vv5QQdWor2TzW/AkEAv7EHqHmKggb3SnMOp1F8uL3e3ZVyzqWPGg2G3DUF5tZ8l+ClfDbeZM1BqEVGt7wZUHPfBQZpgpW1RFkEOpR3jwJACIXqlqfIfp/UUMN9F64/R3MFgaVh80MHCQGExY+pin4cuS+PGcMLjEFR2sDtbCFKEubkoqG38zv/ApPXQb8fEwJAbvYuhWdUVqjV4SE0ijgT2MNexC0RctieTEkYSrlLL0tPowHjCt1KjOrL0HSuO5vemGL8e7J+4WXSbbh/Z3zNSA==";



@end
