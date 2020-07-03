//
//  phoneView.h
//  P-Share
//
//  Created by fay on 16/3/31.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface phoneView : UIView

@property (nonatomic,copy)void (^cancelView)();
@property (nonatomic,copy)void (^nextVC)();
- (instancetype)init;
- (void)show;
- (void)hide;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *textCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *getTextCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (nonatomic,copy)NSString *name;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
