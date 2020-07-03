//
//  DatePickView.h
//  P-Share
//
//  Created by 亮亮 on 16/8/1.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tureBlock)(NSString *,NSString *);

@interface DatePickView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *datePickView;
- (IBAction)tureBtn:(UIButton *)sender;

- (IBAction)cancleBtn:(UIButton *)sender;

- (void)show;
@property (nonatomic,copy)tureBlock myBlock;

@end
