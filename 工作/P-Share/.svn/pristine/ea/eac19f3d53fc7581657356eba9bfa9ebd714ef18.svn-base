//
//  GroupManage.m
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "GroupManage.h"

//创建静态对象，防止外部访问
static GroupManage *_manage;
@implementation GroupManage

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (_manage == nil) {
            _manage = [super allocWithZone:zone];
        }
        return _manage;
    }
    // 也可以使用一次性代码
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (_manage == nil) {
//            _manage = [super allocWithZone:zone];
//        }
//    });
//    return _manage;
}

+ (instancetype)shareGroupManages
{
    return [[self alloc] init];
    
}

-(id)copyWithZone:(NSZone *)zone
{
    return _manage;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _manage;
}

- (void)groupHubShow
{
    [self.hub show:YES];
    self.grayView.layer.zPosition = 1001;
    self.hub.layer.zPosition = 1001;
    [self.grayView.superview bringSubviewToFront:self.grayView];
    [self.hub.superview bringSubviewToFront:self.hub];
    self.hub.hidden = NO;
    self.grayView.hidden = NO;

}
- (void)groupHubHidden
{
    [self.hub show:NO];
    self.hub.hidden = YES;
    self.grayView.hidden = YES;
}

- (MBProgressHUD *)hub
{
    if (!_hub) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
        _grayView.backgroundColor = [UIColor clearColor];
        [keyWindow addSubview:_grayView];
       _hub = [[MBProgressHUD alloc] initWithView:keyWindow];
       _hub.opacity = 0.6;
       _hub.labelText = @"加载中...";
       _hub.labelFont = [UIFont systemFontOfSize:13];
       _hub.activityIndicatorColor = KMAIN_COLOR;
        [_grayView addSubview:self.hub];
        _grayView.hidden = YES;
    }
    return _hub;
}

- (void)groupAlertShowWithTitle:(NSString *)title
{
    do{
        [self.alertHud show:YES];
        self.alertHud.labelText=title;
        self.alertHud.removeFromSuperViewOnHide = NO;
        [self.alertHud hide:YES afterDelay:1];
    }while(0);
}
- (MBProgressHUD *)alertHud
{
    if (!_alertHud) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _alertHud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        _alertHud.mode = MBProgressHUDModeText;
        _alertHud.margin = 10.f;
        _alertHud.alpha = 0.5;
        _alertHud.layer.zPosition = 1001;

//        _alertHud.color = [UIColor colorWithHexString:@"eeeeee"];
//        _alertHud.labelFont = [UIFont systemFontOfSize:14];
//        _alertHud.labelColor = [UIColor darkTextColor];
//        _alertHud.yOffset = -250.f;
    }
    [_alertHud.superview bringSubviewToFront:_alertHud];
    return _alertHud;
}

- (BOOL)isVisitor
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (![UtilTool isBlankString:[userDefault objectForKey:@"customerId"]]) {
        return NO;
    }else
    {
        return YES;        
    }
}

- (User *)user
{
    if (!_user) {
        
        WZLSERIALIZE_UNARCHIVE(_user, @"user", [UtilTool createFilePathWith:@"user"]);
        
    }
    return _user;
}
- (void)setCarLiftParking:(Parking *)carLiftParking
{
    _carLiftParking = carLiftParking;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:carLiftParking.parkingId forKey:KCARLIFT_PARKINGID];
    [userDefault setObject:carLiftParking.parkingName forKey:KCARLIFT_PARKINGNAME];
    [userDefault synchronize];
}
@end
