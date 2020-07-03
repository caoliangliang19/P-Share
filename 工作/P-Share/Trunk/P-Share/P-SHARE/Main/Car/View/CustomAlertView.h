//
//  CustomAlertView.h
//  P-Share
//
//  Created by 亮亮 on 16/4/8.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickTure) ();
typedef void(^CancleBtn) ();

@interface CustomAlertView : UIView
{
    UILabel *_titleLable;
    UIButton *_button2;
    UIButton *_button3;
    UIView *_lineView1;
    UIView *_lineView2;
    UIView *_lineView3;
}

@property (nonatomic,copy)NSString *title;
@property (nonatomic,retain)UIControl *controlMe;
@property (nonatomic,copy)ClickTure myBlock;
@property (nonatomic,copy)CancleBtn canBlock;


- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)titleName;
- (void)myTitleText:(NSString *)title Block:(ClickTure)myBlock canBlock:(CancleBtn)canBlock;
- (void)showAlertView;
- (void)dismissAlertView;
@end
