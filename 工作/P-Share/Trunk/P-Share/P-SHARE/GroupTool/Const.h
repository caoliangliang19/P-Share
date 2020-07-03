//
//  Const.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#ifndef Const_h
#define Const_h

//全局类
#import <Masonry.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "IQKeyboardManager.h"
#import "POPBasicAnimation.h"
#import "WZLSerializeKit.h"
#import "POP.h"
#import "HttpUtil.h"
#import "UMMobClick/MobClick.h"
#import "JQIndicatorView.h"


#import "UIColor+Category.h"
#import "UIView+CateGory.h"
#import "UIButton+EdgeInsets.h"
#import "NSString+Encryption.h"

#import "QiYuTool.h"
#import "LoginVC.h"
#import "BaseViewController.h"
#import "GroupManage.h"
#import "UtilTool.h"
#import "User.h"
#import "Parking.h"
#import "Car.h"
#import "OrderModel.h"
#import "CoordinateModel.h"
#import "NetWorkInterface.h"
#import "NetWorkEngine.h"
#import "NotificationCenter.h"
#import "PayCenterViewController.h"
#import "MapSearchModel.h"
#import "CoreDataManage.h"
#import "WebViewController.h"
#import "WebInfoModel.h"
//宏
//-----------------自定义输出
#ifdef DEBUG
#define MyLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define MyLog(format, ...)
#endif
//-----------------

#define SCREEN_WIDTH     ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT    ([UIScreen mainScreen].bounds.size.height)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
//------颜色
#define KMAIN_COLOR ([UIColor colorWithHexString:@"#39D5B8"])
#define KLINE_COLOR ([UIColor colorWithHexString:@"#E1E1E1"])


#define KBG_COLOR ([UIColor whiteColor])




#endif /* Const_h */
