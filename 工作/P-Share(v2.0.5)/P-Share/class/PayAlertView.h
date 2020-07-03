//
//  PayAlertView.h
//  P-Share
//
//  Created by fay on 16/4/11.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayAlertView : UIView


@property (nonatomic,copy)void (^payBlock)();
@property (nonatomic,copy)void (^cancelBlock)();
@property (nonatomic,retain)UILabel *payMoney;
@property (nonatomic,retain)UILabel *actureMoney;
@property (nonatomic,retain)UIControl *control;

- (instancetype)initWithFrame:(CGRect)frame WithPayMoney:(NSString *)payMoney ActureMoney:(NSString *)money;

- (void)animatedIn;
- (void)animatedOut;

@end
