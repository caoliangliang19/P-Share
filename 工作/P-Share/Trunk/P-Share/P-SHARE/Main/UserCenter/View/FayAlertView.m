//
//  FayAlertView.m
//  P-Share
//
//  Created by fay on 16/8/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "FayAlertView.h"
@interface FayAlertView()
{
    NSString    *_title,
                *_sureBtnTitle,
                *_cancelBtnTitle;
    
    id          _describute;
    UIView      *_bgView;
    UILabel     *_mainL,*_subL;
    
    
}

@end

@implementation FayAlertView

- (instancetype)initWithNormalTitle:(NSString *)title
                         describute:(NSString *)describute
                       sureBtnTitle:(NSString *)sureBtnTitle
                     cancelBtnTitle:(NSString *)cancelBtnTitle
{
    if (self == [super init]) {
        _title = title;
        _describute = describute;
        _sureBtnTitle = sureBtnTitle;
        _cancelBtnTitle = cancelBtnTitle;
        [self setUpSubViewNeedMutableStr:NO];
        
    }
    return self;
}

- (instancetype)initWithMutableAttributestrTitle:(NSString *)title
                                      describute:(NSMutableAttributedString *)describute
                                    sureBtnTitle:(NSString *)sureBtnTitle
                                  cancelBtnTitle:(NSString *)cancelBtnTitle
{
    if (self == [super init]) {
        _title = title;
        _describute = describute;
        _sureBtnTitle = sureBtnTitle;
        _cancelBtnTitle = cancelBtnTitle;
        [self setUpSubViewNeedMutableStr:YES];
    }
    return self;
}

- (void)setUpSubViewNeedMutableStr:(BOOL)need
{
    self.backgroundColor = [UIColor whiteColor];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *bgView = [UIView new];
    _bgView = bgView;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [keyWindow addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    UILabel *mainL = [UtilTool createLabelFrame:CGRectZero title:_title textColor:[UIColor colorWithHexString:@"000000"]  font:[UIFont systemFontOfSize:18] textAlignment:1 numberOfLine:0];
    mainL.numberOfLines = 0;
    _mainL = mainL;
    [self addSubview:mainL];
    CGFloat marginY = 10;
    [mainL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.left.mas_equalTo(marginY);
        make.right.mas_equalTo(-marginY);
    }];
    
    UILabel *subL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"757575"] font:[UIFont systemFontOfSize:13] textAlignment:1 numberOfLine:0];
    _subL.textAlignment = 1;
    subL.numberOfLines = 0;
    _subL = subL;
    if (need) {
        subL.attributedText = (NSAttributedString *)_describute;
//        subL.text = (NSString *)_describute;

    }else
    {
        subL.text = (NSString *)_describute;

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:subL.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0f];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [subL.text length])];
        subL.attributedText = attributedString;
    }
    [self addSubview:subL];
    [subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mainL.mas_bottom).offset(20);
        make.leading.mas_equalTo(mainL.mas_leading);
        make.trailing.mas_equalTo(mainL.mas_trailing);
    }];
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor colorWithHexString:@"dadade"];
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_subL.mas_bottom).offset(20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    UIButton *sureBtn = [UIButton new];
    sureBtn.tag = 0;
    [sureBtn addTarget:self action:@selector(alertBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setTitle:_sureBtnTitle forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"39d5b8"] forState:(UIControlStateNormal)];
    [self addSubview:sureBtn];
    if (![UtilTool isBlankString:_cancelBtnTitle]) {
        UIButton *cancelBtn = [UIButton new];
        cancelBtn.tag = 1;
        [cancelBtn setTitle:_cancelBtnTitle forState:(UIControlStateNormal)];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [cancelBtn addTarget:self action:@selector(alertBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];

        [self addSubview:cancelBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(cancelBtn.mas_left);
            make.top.mas_equalTo(lineV.mas_bottom);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(cancelBtn.mas_width);
        }];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sureBtn.mas_right);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(lineV.mas_bottom);
            make.height.mas_equalTo(sureBtn.mas_height);
        }];
        UIView *subLineView = [UIView new];
        subLineView.backgroundColor = [UIColor colorWithHexString:@"dadade"];
        [self addSubview:subLineView];
        [subLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineV.mas_bottom);
            make.height.mas_equalTo(sureBtn.mas_height);
            make.left.mas_equalTo(sureBtn.mas_right);
            make.width.mas_equalTo(1);
        }];
        [cancelBtn layoutIfNeeded];
        [sureBtn layoutIfNeeded];
        MyLog(@"%@  %@",cancelBtn,sureBtn);
    }else
    {
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineV.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }
    
    [keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(keyWindow.mas_centerX);
        make.centerY.mas_equalTo(keyWindow.mas_centerY);
//        make.size.mas_equalTo(CGSizeMake(200, 400));
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(_mainL.mas_top).offset(-20);
        make.bottom.mas_equalTo(sureBtn.mas_bottom);
    }];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    [self layoutIfNeeded];

    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)alertBtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
    [_bgView removeFromSuperview];
    if (btn.tag == 0) {
        if (self.sureBlock) {
            self.sureBlock();
        }
    }else
    {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
}

@end
