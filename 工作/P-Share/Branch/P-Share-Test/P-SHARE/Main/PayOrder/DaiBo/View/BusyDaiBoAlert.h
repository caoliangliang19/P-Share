//
//  BusyAlert.h
//  P-Share
//
//  Created by 亮亮 on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^turnBtn)();
typedef void (^cancleBtn)();
@interface BusyDaiBoAlert : UIView

- (void)tureBlock:(void(^)())tureBlock cancleBlock:(void(^)())cancleBlock;
- (void)show;
- (void)hide;
@property (copy , nonatomic)turnBtn tureBlock;
@property (copy , nonatomic)cancleBtn cancleBlock;
@property (weak, nonatomic) IBOutlet UILabel *carQuantityL;
@property (weak, nonatomic) IBOutlet UILabel *AppointmentL;

- (IBAction)cancleBtn:(UIButton *)sender;
- (IBAction)tureBtn:(UIButton *)sender;
- (IBAction)deleteBtn:(UIButton *)sender;


@end
