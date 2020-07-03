//
//  TimePickerView.h
//  P-Share
//
//  Created by 亮亮 on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cencleBlock)();
@interface RenewTime : UIView

@property(nonatomic,copy) void (^renewTimeCallBackBlock)(NSDictionary *);
@property(nonatomic,copy) cencleBlock cblock;
- (void)show;
- (void)hide;
- (IBAction)tureBtn:(UIButton *)sender;
- (IBAction)cancleBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *dataPickView;

@end
