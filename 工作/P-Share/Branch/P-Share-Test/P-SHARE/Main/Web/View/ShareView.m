//
//  ShareView.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "ShareView.h"
#import "ShareModel.h"
#import "ShareEnginee.h"
@interface ShareView ()
{
    UIView *_grayView;
    UIView *_mainView;
    UIView *_infoView;
    UIAlertView *_alert;
    
}


@end

@implementation ShareView
+ (ShareView *)createShareView;
{

    return [[self alloc] initWithFrame:CGRectZero];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self setUpSubView];
    }
    return self;
}

- (void)setUpSubView
{
    CGFloat marginX = 8.0f;
    CGFloat marginY = 10.0f;
    UIView *grayView = [UIView new];
    _grayView = grayView;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShareViewHidden)];
    [grayView addGestureRecognizer:tapGesture];
    //    grayView.hidden = YES;
    grayView.backgroundColor = [UIColor blackColor];
    grayView.alpha = 0.3;
   
    
    UIView *mainView = [UIView new];
    _mainView = mainView;
    mainView.backgroundColor = [UIColor clearColor];
    [self addSubview:mainView];
    [mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(180);
        make.height.mas_equalTo(180);
    }];
    
    UIView *cancelView = [UIView new];
    cancelView.backgroundColor = [UIColor whiteColor];
    cancelView.layer.cornerRadius = 4;
    cancelView.layer.masksToBounds = YES;
    [mainView addSubview:cancelView];
    [cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(mainView.mas_left).offset(marginX);
        make.right.mas_equalTo(mainView.mas_right).offset(-marginX);
        make.bottom.mas_equalTo(mainView.mas_bottom).offset(-marginY);
        make.height.mas_equalTo(45);
    }];
    UIButton *cancelBtn = [UIButton new];
    [cancelBtn addTarget:self action:@selector(ShareViewHidden) forControlEvents:(UIControlEventTouchUpInside)];
    [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"007AFD"] forState:(UIControlStateNormal)];
    [cancelView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    UIView *infoView = [UIView new];
    _infoView = infoView;
    infoView.backgroundColor = [UIColor whiteColor];
    infoView.layer.cornerRadius = 4;
    infoView.layer.masksToBounds = YES;
    [mainView addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(cancelView.mas_top).offset(-marginY);
        make.trailing.mas_equalTo(cancelView.mas_trailing);
        make.leading.mas_equalTo(cancelView.mas_leading);
        make.height.mas_equalTo(115);
    }];
    
    [self setShareBtn];
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:grayView];
    [keyWindow addSubview:self];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.right.left.bottom.mas_equalTo(0);
    }];
    
}

- (void)setShareBtn
{
    
    UIButton *QQBtn = [UtilTool createBtnFrame:CGRectZero title:@"" bgImageName:@"iconfont-QQ" target:self action:@selector(shareClick:)];
    QQBtn.tag = 2;
    
    UIButton *WechatBtn = [UtilTool createBtnFrame:CGRectZero title:@"" bgImageName:@"iconfont-weixin" target:self action:@selector(shareClick:)];
    WechatBtn.tag = 0;
    
    UIButton *pengYouQuan = [UtilTool createBtnFrame:CGRectZero title:@"" bgImageName:@"iconfont-pengyouquan" target:self action:@selector(shareClick:)];
    pengYouQuan.tag = 1;
    NSArray *btnArr = @[WechatBtn,pengYouQuan,QQBtn];
    [_infoView addSubview:WechatBtn];
    [_infoView addSubview:pengYouQuan];
    [_infoView addSubview:QQBtn];

    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:49 leadSpacing:40 tailSpacing:40];
    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45/2);
        make.height.mas_equalTo(49);
        
    }];
    
    UILabel *weChatLabel = [UtilTool createLabelFrame:CGRectZero title:@"微信" textColor:[UIColor colorWithHexString:@"666666"] font:[UIFont systemFontOfSize:11] textAlignment:1 numberOfLine:1];
    UILabel *pengYouquanLabel = [UtilTool createLabelFrame:CGRectZero title:@"朋友圈" textColor:[UIColor colorWithHexString:@"666666"] font:[UIFont systemFontOfSize:11] textAlignment:1 numberOfLine:1];
    UILabel *QQLabel = [UtilTool createLabelFrame:CGRectZero title:@"QQ" textColor:[UIColor colorWithHexString:@"666666"] font:[UIFont systemFontOfSize:11] textAlignment:1 numberOfLine:1];
    
    [_infoView addSubview:weChatLabel];
    [_infoView addSubview:pengYouquanLabel];
    [_infoView addSubview:QQLabel];
    
    [weChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(WechatBtn.mas_centerX);
        make.top.mas_equalTo(WechatBtn.mas_bottom).offset(11);
    }];
    
    [pengYouquanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(pengYouQuan.mas_centerX);
        make.top.mas_equalTo(pengYouQuan.mas_bottom).offset(11);
    }];
    
    [QQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(QQBtn.mas_centerX);
        make.top.mas_equalTo(QQBtn.mas_bottom).offset(11);
    }];
    
}

- (void)ShareViewShow
{
    self.hidden = NO;
    _grayView.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1/0.55 options:0 animations:^{
            [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom).offset(0);

            }];
            [_mainView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
        }];
        
    });
    
}

- (void)ShareViewHidden
{
    
    [UIView animateWithDuration:0.5 animations:^{
        [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(180);
        }];
        [_mainView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
        _grayView.hidden = YES;
    }];
    
}

- (void)shareClick:(UIButton*)btn
{
    [self ShareViewHidden];
    
    MyLog(@"%ld",btn.tag);
    if (btn.tag == 0) {
//        微信朋友
        [ShareEnginee shareActivityWith:_shareModel shareType:1];
    }else if (btn.tag == 1){
//        朋友圈
        [ShareEnginee shareActivityWith:_shareModel shareType:2];

    }else
    {
//        QQ
        [ShareEnginee shareActivityWith:_shareModel shareType:0];

    }
}


@end
