//
//  FayTextField.m
//  P-SHARE
//
//  Created by fay on 16/9/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "FayTextField.h"
#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 40  //每一个输入框的高度
@interface FayTextField ()
@property (nonatomic,strong)NSMutableArray *dotArray;

@end
@implementation FayTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //输入的文字颜色为白色
        self.textColor = [UIColor clearColor];
        //输入框光标的颜色为白色
        self.tintColor = [UIColor clearColor];
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.layer.borderColor = [KLINE_COLOR CGColor];
        self.layer.borderWidth = 1;
    }
    return self;
}
- (void)setUpSubView
{
    //每个密码输入框的宽度
    CGFloat width = self.frame.size.width / kDotCount;
    CGFloat hight = self.frame.size.height;
    //生成分割线
    for (int i = 0; i < kDotCount ; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, 1, K_Field_Height)];
        lineView.tag = 10+i;
        lineView.backgroundColor = KLINE_COLOR;
        [self addSubview:lineView];
    }
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    [self.dotArray removeAllObjects];
    for (int i = 0; i < kDotCount ; i++) {
        UIView *dotView = [UIView new];
        dotView.bounds = CGRectMake(0, 0, kDotSize.width, kDotSize.height);
        dotView.center = CGPointMake(width/2 + width * i, hight/2);
        dotView.backgroundColor = [UIColor blackColor];
        dotView.tag = i;
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
    
}
/**
 *  重置显示的点
 */
- (void)setText:(NSString *)text
{
    MyLog(@"%@",text);
    
    for (UIView *dotView in self.dotArray) {
        if (dotView.tag < text.length) {
            dotView.hidden = NO;
        }else
        {
            dotView.hidden = YES;
        }
    }
    
    if (text.length == kDotCount) {
        MyLog(@"输入完毕");
//        [self resignFirstResponder];
    }
}

- (void)frame:(NSString *)identfier;{
    CGFloat width = self.frame.size.width / kDotCount;
    
    for (int i = 0; i < kDotCount ; i++) {
        UIView *lineView = [self viewWithTag:10+i];
        lineView.frame = CGRectMake(i * width, 0, 1, 30);
    }
}
@end
