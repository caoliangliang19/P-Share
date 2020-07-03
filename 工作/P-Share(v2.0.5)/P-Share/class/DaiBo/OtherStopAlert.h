//
//  OtherStopAlert.h
//  P-Share
//
//  Created by 亮亮 on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^turnBtn)();
typedef void (^cancleBtn)();
@interface OtherStopAlert : UIView
//弹出
- (void)show;
//消失
- (void)hide;
//返回主页Block 和进入订单Block
- (void)tureBlock:(void(^)())tureBlock cancleBlock:(void(^)())cancleBlock;
@property (copy , nonatomic)turnBtn tureBlock;
@property (copy , nonatomic)cancleBtn cancleBlock;


@property (weak, nonatomic) IBOutlet UILabel *getCarTimeL;
@property (weak, nonatomic) IBOutlet UILabel *reckonMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *carMasterPhone;

- (IBAction)cancleBtn:(id)sender;
- (IBAction)backToHeadView:(UIButton *)sender;
- (IBAction)lookUpOrder:(UIButton *)sender;


@end
