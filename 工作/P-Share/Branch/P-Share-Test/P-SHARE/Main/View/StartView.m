//
//  StartView.m
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "StartView.h"
@interface StartView()
{
    UIImage         *_selectImage;
    UIImage         *_unSelectImage;
    NSMutableArray  *_startArray;
    UIButton        *_globalBtn;
    UIButton        *_temBtn;
    BOOL            _alertIsShow;
    
    
}
@end
@implementation StartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createStart];
    }
    return self;
}
- (void)createStart
{
    _startArray = [NSMutableArray array];
    for (int i=0 ; i<5; i++) {
        UIButton *btn = [UIButton new];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(startBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        if (i==0) {
            _firstBtn = btn;
        }else if (i == 4) {
            _lastBtn = btn;
        }
        
        [self addSubview:btn];
        [_startArray addObject:btn];
    }
}

- (void)setStyle:(StartViewStyle)style
{
    _style = style;
    if (style == StartViewStyleSmall) {
        _startWidth = 24.0f;
        _startspace = 10.0f;
        _selectImage = [UIImage imageNamed:@"selectSmallStart_v2.0.1"];
        _unSelectImage = [UIImage imageNamed:@"unselectSmallStart_v2.0.1"];
    }else if (style == StartViewStyleBig){
        _startWidth = 36.0f;
        _startspace = 14.0f;
        _selectImage = [UIImage imageNamed:@"selectBigStart_v2.0.1"];
        _unSelectImage = [UIImage imageNamed:@"unselectBigStart_v2.0.1"];
    }
    [self layoutStart];
    
}
- (void)layoutStart
{
    [_startArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        [btn setBackgroundImage:_unSelectImage forState:(UIControlStateNormal)];
        [btn setBackgroundImage:_selectImage forState:(UIControlStateSelected)];

    }];

    [_startArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:_startWidth leadSpacing:0 tailSpacing:0];
    [_startArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(_startWidth);
        
    }];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self btnClick:_temBtn];
    }
    _alertIsShow = NO;
}

- (void)startBtnClick:(UIButton *)startBtn
{
    
    _temBtn = startBtn;
    
//    if (self.tagArray.count>0) {
//        
//        
//        
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            _alertIsShow = YES;
//            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"改变星星数量,会丢失已选的标签" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//            [alertV show];
//            [self addSubview:alertV];
//            
//        });
//        if (!_alertIsShow) {
//            [self btnClick:startBtn];
//        }
//        
//    }else
//    {
        [self btnClick:startBtn];
//    }
  
    
    
    
    
}

- (void)btnClick:(UIButton *)startBtn
{
    static NSInteger startNum = 0;
    
    if (startBtn.selected) {
        
        [_startArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
            if (btn.tag > startBtn.tag) {
                btn.selected = NO;
            }else
            {
                if (_globalBtn.tag == btn.tag) {
                    btn.selected = NO;
                }else
                {
                    btn.selected = YES;
                }
            }
        }];
        

        MyLog(@"startBtn.tag:   %ld",startBtn.tag-1);
        
        if (_globalBtn.tag == startBtn.tag) {
            startNum = startBtn.tag-1;
        }else
        {
            startNum = startBtn.tag;
        }
        
        _globalBtn = startBtn;

        
        
    }else
    {
        [_startArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
            if (btn.tag <= startBtn.tag) {
                btn.selected = YES;
            }else
            {
                btn.selected = NO;
            }
        }];
        _globalBtn = startBtn;

        MyLog(@"startBtn.tag:   %ld",startBtn.tag);
        startNum = startBtn.tag;
    }
    
    
    MyLog(@"tagArray.count:%ld",_tagArray.count);
    
    if (self.startViewClick) {
        self.lightingStartNum = startNum;
        self.startViewClick(startNum);
    }
    

}

- (void)setShowStyle:(StartViewShowStyle)showStyle
{
    _showStyle = showStyle;
    [_startArray enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        btn.userInteractionEnabled = NO;
        if (btn.tag <= _lightStartNum) {
            btn.selected = YES;
        }else
        {
            btn.selected = NO;
        }
    }];
    
}
@end
