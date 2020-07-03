//
//  ShareView.m
//  P-Share
//
//  Created by fay on 16/8/10.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ShareView.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface ShareView()<TencentSessionDelegate>
{
    UIView *_grayView;
    UIView *_mainView;
    UIView *_infoView;
    UIAlertView *_alert;
}

@end

@implementation ShareView

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
    [self addSubview:grayView];
    [grayView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIView *mainView = [UIView new];
    _mainView = mainView;
    mainView.backgroundColor = [UIColor clearColor];
    [self addSubview:mainView];
    [mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom).priorityLow();
        make.top.mas_equalTo(self.mas_bottom).priorityHigh();
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
    [cancelBtn setTitleColor:[MyUtil colorWithHexString:@"007AFD"] forState:(UIControlStateNormal)];
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
    
   
    
}

- (void)setShareBtn
{

    UIButton *QQBtn = [MyUtil createBtnFrame:CGRectZero title:@"" bgImageName:@"iconfont-QQ" target:self action:@selector(shareClick:)];
    QQBtn.tag = 2;
    
    UIButton *WechatBtn = [MyUtil createBtnFrame:CGRectZero title:@"" bgImageName:@"iconfont-weixin" target:self action:@selector(shareClick:)];
    WechatBtn.tag = 0;
    
    UIButton *pengYouQuan = [MyUtil createBtnFrame:CGRectZero title:@"" bgImageName:@"iconfont-pengyouquan" target:self action:@selector(shareClick:)];
    pengYouQuan.tag = 1;
    NSArray *btnArr = @[WechatBtn,pengYouQuan,QQBtn];
    [_infoView sd_addSubviews:btnArr];
    
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:49 leadSpacing:40 tailSpacing:40];
    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45/2);
        make.height.mas_equalTo(49);
        
    }];
    
    UILabel *weChatLabel = [MyUtil createLabelFrame:CGRectZero title:@"微信" textColor:[MyUtil colorWithHexString:@"666666"] font:[UIFont systemFontOfSize:11] textAlignment:1 numberOfLine:1];
    UILabel *pengYouquanLabel = [MyUtil createLabelFrame:CGRectZero title:@"朋友圈" textColor:[MyUtil colorWithHexString:@"666666"] font:[UIFont systemFontOfSize:11] textAlignment:1 numberOfLine:1];
    UILabel *QQLabel = [MyUtil createLabelFrame:CGRectZero title:@"QQ" textColor:[MyUtil colorWithHexString:@"666666"] font:[UIFont systemFontOfSize:11] textAlignment:1 numberOfLine:1];
    [_infoView sd_addSubviews:@[weChatLabel,pengYouquanLabel,QQLabel]];
    
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

//    [imgArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:imgW leadSpacing:10 tailSpacing:90];

    
}

#pragma mark -- 点击分享
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_url,@"url",_titleStr,@"title",_imagePath,@"imagePath", nil];

- (void)shareClick:(UIButton*)btn
{
    MyLog(@"btnTag:%ld",btn.tag);
    switch (btn.tag) {
        case 0:
        {
            //            微信分享
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                WXMediaMessage *urlMessage = [WXMediaMessage message];
                urlMessage.title = [_dataDic objectForKey:@"title"];
                urlMessage.description = @" ";

                [urlMessage setThumbImage: [UIImage imageNamed:@"logoPshare"]];
                WXWebpageObject *webObject = [WXWebpageObject object];
                webObject.webpageUrl = [_dataDic objectForKey:@"url"];
                
                urlMessage.mediaObject = webObject;
                req.message = urlMessage;
                
                req.scene = WXSceneSession; //选择发送到朋友圈WXSceneTimeline，默认值为WXSceneSession发送到会话
                [WXApi sendReq:req];
            }else{
                ALERT_VIEW( @"您未安装微信或版本不支持");
                _alert = nil;
            }

        }
            break;
            
        case 1:
        {
            //            朋友圈分享
            
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                WXMediaMessage *urlMessage = [WXMediaMessage message];
                urlMessage.title = [_dataDic objectForKey:@"title"];
                urlMessage.description = @" ";

                [urlMessage setThumbImage: [UIImage imageNamed:@"logoPshare"]];
                WXWebpageObject *webObject = [WXWebpageObject object];
                webObject.webpageUrl = [_dataDic objectForKey:@"url"];
                urlMessage.mediaObject = webObject;
                req.message = urlMessage;
                req.scene = WXSceneTimeline; //选择发送到朋友圈WXSceneTimeline，默认值为WXSceneSession发送到会话
                [WXApi sendReq:req];
            }else{
                ALERT_VIEW( @"您未安装微信或版本不支持");
                _alert = nil;
            }

        }
            break;
            
        case 2:
        {
            //            QQ分享
            TencentOAuth *auth = [[TencentOAuth alloc] initWithAppId:@"1105233032"andDelegate:self];
            NSURL *previewURL = [NSURL URLWithString:[_dataDic objectForKey:@"imagePath"]];
            NSURL* url = [NSURL URLWithString:[_dataDic objectForKey:@"url"]];
            
            QQApiNewsObject* obj = [QQApiNewsObject objectWithURL:url title:[_dataDic objectForKey:@"title"] description:@"" previewImageURL:previewURL];
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:obj];
            
            QQApiSendResultCode send = [QQApiInterface sendReq:req];
            [self handleSendResult:send];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)ShareViewShow
{
    self.hidden = NO;
    _grayView.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1/0.55 options:0 animations:^{
            [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.mas_bottom).priorityHigh();
                make.top.mas_equalTo(self.mas_bottom).priorityLow();
            }];
            [_mainView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
        }];

    });
    
}

- (void)ShareViewHidden
{

    [UIView animateWithDuration:2 animations:^{
        [_mainView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).priorityLow();
            make.top.mas_equalTo(self.mas_bottom).priorityHigh();
        }];
        [_mainView layoutIfNeeded];
        _grayView.hidden = YES;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装QQ" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装QQ" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
       
        default:
        {
            break;
        }
    }
}

/**
处理来至QQ的响应
*/
- (void)onResp:(QQBaseResp *)resp{
    NSLog(@" ----resp %@",resp);
    
    // SendMessageToQQResp应答帮助类
    if ([resp.class isSubclassOfClass: [SendMessageToQQResp class]]) {  //QQ分享回应
       
        ALERT_VIEW(@"分享成功");
        _alert = nil;
        [self ShareViewHidden];
    }
}
@end
