//
//  CustomAlertView.m
//  P-Share
//
//  Created by 亮亮 on 16/4/8.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#define  FLableHight    44
#define  AlertWidth     ([UIScreen mainScreen].bounds.size.width-94)
#define  SLableWight    AlertWidth-28
#define  lineVHight     1
#define  buttonHight    44
#define  buttonWitch    AlertWidth/2
#import "CustomAlertView.h"
@implementation CustomAlertView


@synthesize controlMe = _controlMe;

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)titleName {
    if (self = [super initWithFrame:frame]) {
        [self initTheInterFace:titleName];
        
    }
    return self;
}

- (void)initTheInterFace:(NSString *)titleName{
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
   //第一个控件
    UILabel *titleNameL = [UtilTool createLabelFrame:CGRectMake(0, FLableHight-30, AlertWidth, 30) title:titleName textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    [self addSubview:titleNameL];
   //第三个控件
    
    _titleLable = [UtilTool createLabelFrame:CGRectZero title:self.title textColor:[UIColor colorWithHexString:@"696969"] font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft numberOfLine:0];
    

    [self addSubview:_titleLable];
    
    UIButton *button1 = [UtilTool createBtnFrame:CGRectMake(AlertWidth-25, 10, 15, 15) title:nil bgImageName:@"payViewCancel" target:self action:@selector(onClickDismiss)];

    //第四个，第五个控件Button
    [self addSubview:button1];
    _button2 = [UtilTool createBtnFrame:CGRectZero title:@"拒绝" bgImageName:nil target:self action:@selector(onRefuse)];
    [_button2 setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
    _button2.titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_button2];
    _button3 = [UtilTool createBtnFrame:CGRectZero title:@"同意" bgImageName:nil target:self action:@selector(onCertain)];
     [_button3 setTitleColor:[UIColor colorWithHexString:@"39d5b8"] forState:UIControlStateNormal];
     _button3.titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_button3];
    //第二个控件
    _lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, FLableHight, AlertWidth, lineVHight)];
    _lineView1.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self addSubview:_lineView1];
    //第四个控件
    _lineView2 = [[UIView alloc]initWithFrame:CGRectZero];
    _lineView2.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self addSubview:_lineView2];
    //第六个控件
    _lineView3 = [[UIView alloc]initWithFrame:CGRectZero];
    _lineView3.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self addSubview:_lineView3];
    //背景
    _controlMe = [[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _controlMe.backgroundColor = [UIColor blackColor];
    _controlMe.alpha = 0.5;
    
    
    
}
- (void)animatedIn{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)animatedOut{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.controlMe) {
                [self.controlMe removeFromSuperview];
                
            }
            [self removeFromSuperview];
        }
    }];
}

- (void)myTitleText:(NSString *)title Block:(ClickTure)myBlock canBlock:(CancleBtn)canBlock{
    self.title = title;
    self.myBlock = myBlock;
    self.canBlock = canBlock;
}

- (void)showAlertView;{
    MyLog(@"%@====",self.title);
     CGRect rect = [self.title boundingRectWithSize:CGSizeMake(SLableWight, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    _titleLable.text = self.title;
    _titleLable.numberOfLines = 0;
    
    if (rect.size.height+40 > 120) {
        _titleLable.frame = CGRectMake(14, FLableHight+lineVHight, SLableWight,rect.size.height+40);
        _lineView2.frame = CGRectMake(0, FLableHight+lineVHight+rect.size.height+40, AlertWidth, lineVHight);
        _button2.frame = CGRectMake(0, FLableHight+lineVHight+rect.size.height+40+lineVHight, buttonWitch, buttonHight);
         _button3.frame = CGRectMake(buttonWitch, FLableHight+lineVHight+rect.size.height+40+lineVHight, buttonWitch, buttonHight);
        _lineView3.frame = CGRectMake(buttonWitch, FLableHight+lineVHight+rect.size.height+40+lineVHight, lineVHight, buttonHight);
    }else{
    _titleLable.frame = CGRectMake(10, FLableHight+lineVHight, SLableWight, 120);
     _lineView2.frame = CGRectMake(0, FLableHight+lineVHight+120, AlertWidth, lineVHight);
    _button2.frame = CGRectMake(0, FLableHight+lineVHight+120+lineVHight, buttonWitch, buttonHight);
    _button3.frame = CGRectMake(buttonWitch,FLableHight+lineVHight+120+lineVHight, buttonWitch, buttonHight);
    _lineView3.frame = CGRectMake(buttonWitch, FLableHight+lineVHight+120+lineVHight, lineVHight, buttonHight);
    }
//    _button2
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (self.controlMe)
    {
        [keywindow addSubview:self.controlMe];
    }
    [keywindow addSubview:self];
    
    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                              keywindow.bounds.size.height/2.0f);
    if (rect.size.height+40 > 120) {
         self.bounds = CGRectMake(0, 0, AlertWidth, FLableHight+lineVHight+rect.size.height+40+lineVHight+buttonHight);
    }else{
        self.bounds = CGRectMake(0, 0, AlertWidth, FLableHight+lineVHight+120+lineVHight+buttonHight);
    }
   
    [self animatedIn];
}
- (void)dismissAlertView;{
    [self animatedOut];
}

- (void)onClickDismiss{
    if (self.canBlock) {
        self.canBlock();
    }
     }
- (void)onRefuse{
    if (self.canBlock) {
        self.canBlock();
    }
}
- (void)onCertain{
    if (self.myBlock) {
        self.myBlock();
    }
}
@end
