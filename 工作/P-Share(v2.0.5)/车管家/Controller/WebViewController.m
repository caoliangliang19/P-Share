//
//  WebViewController.m
//  P-Share
//
//  Created by fay on 16/1/20.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "WebViewController.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "ShareView.h"


@interface WebViewController ()<UIWebViewDelegate>
{
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    UIAlertView *_alert;
    UIWebView *_webView;
    NSURLRequest * _request;
    NSDictionary *_dataDic;
    NSString *_temSerVerID;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shareImageV;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_type == WebViewControllerTypeNeedShare) {
        _shareBtn.hidden = NO;
        _shareImageV.hidden = NO;
    }else
    {
        _shareBtn.hidden = YES;
        _shareImageV.hidden = YES;
    }
    
    _bgView.hidden = YES;
    _shareView.hidden = YES;
    
    if ([SERVER_ID isEqualToString:@"139.196.24.16"]) {
        _temSerVerID = @"www.i-ubo.cn";
    }else
    {
        _temSerVerID = @"www.p-share.com";
    }
    
    if (_titleStr.length > 0) {
        _titleL.text = _titleStr;

    }else
    {
        _titleL.text = @"详情";

    }
    
    if ([_url isEqualToString:@""]) {
        _infoL.hidden = YES;
        _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"活动不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alert show];
        return;
    }
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    [self.view addSubview:_bgView];
    [self.view addSubview:_shareView];
    
    
    _webView.scalesPageToFit = YES;
    NSURL *url;
    if ([_kind isEqualToString:@"file"]) {
        url = [NSURL fileURLWithPath:_url];
    }else
    {
        url = [NSURL URLWithString:_url];
        
    }
   _request = [NSURLRequest requestWithURL:url];
    _webView.delegate = self;
    
    [_webView loadRequest:_request];
    ALLOC_MBPROGRESSHUD;
    
}
#pragma mark -- 是否需要分享

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    _bgView.hidden = YES;
    _shareView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWebView) name:@"webView" object:nil];
    
}

- (void)refreshWebView
{
    
    if ([_url containsString:@"itunes.apple.com"]) {
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[NewMapHomeVC class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }else
    {
        [_webView loadRequest:_request];

    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    _alert = nil;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    BEGIN_MBPROGRESSHUD;

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    END_MBPROGRESSHUD;
    
    [_webView stringByEvaluatingJavaScriptFromString:@"XinLang()"];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *urlstr = request.URL.absoluteString;
    
    NSRange range = [urlstr rangeOfString:@"exportfunction://"];
    
    if(range.length!=0)
    {
        NSString *temStr = [urlstr substringFromIndex:(range.location+range.length)];
        
        NSMutableArray *urls = (NSMutableArray*)[temStr componentsSeparatedByString:@"/"];
        
        NSString *method = [NSString stringWithFormat:@"%@:",urls[0]];
        
        SEL selctor = NSSelectorFromString(method);
        
        [urls removeObjectAtIndex:0];
        NSInteger length;
        if ([method isEqualToString:@"share:"]) {
            length = 6;
        }else
        {
            length = 11;
        }
        
        NSString *paramStr = [temStr substringFromIndex:length];
        
//取消警告
# pragma clang diagnostic push
# pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [self performSelector:selctor withObject:paramStr];
        
    }
    return YES;
}

- (void)pasteboard:(NSString *)pasteStr
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:pasteStr];
    
    ALERT_VIEW(@"复制成功");
    _alert = nil;
    
    
}

- (void)share:(NSString *)str
{
    _bgView.hidden = NO;
    _shareView.hidden = NO;
    
    NSString *transString = [NSString stringWithString:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [transString dataUsingEncoding:NSUTF8StringEncoding];
    _dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    END_MBPROGRESSHUD;
    
}

//微信会话分享
- (IBAction)weiXinShareBtnClick:(id)sender {
    
    
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [_dataDic objectForKey:@"title"];
        urlMessage.description = [_dataDic objectForKey:@"desc"];
        [urlMessage setThumbImage: [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/share/%@",SERVER_ID,[_dataDic objectForKey:@"img"]]]]]];
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = [NSString stringWithFormat:@"http://%@/share/%@",_temSerVerID,[_dataDic objectForKey:@"link"]];
        
        
        urlMessage.mediaObject = webObject;
        req.message = urlMessage;
        
        req.scene = WXSceneSession; //选择发送到朋友圈WXSceneTimeline，默认值为WXSceneSession发送到会话
        [WXApi sendReq:req];
    }else{
        ALERT_VIEW( @"您未安装微信或版本不支持");
        _alert = nil;
    }
}
//微信朋友圈分享
- (IBAction)pengYouShareBtnClick:(id)sender {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [_dataDic objectForKey:@"title"];
        urlMessage.description = [_dataDic objectForKey:@"desc"];
        [urlMessage setThumbImage: [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/share/%@",_temSerVerID,[_dataDic objectForKey:@"img"]]]]]];
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = [NSString stringWithFormat:@"http://%@/share/%@",SERVER_ID,[_dataDic objectForKey:@"link"]];
        urlMessage.mediaObject = webObject;
        req.message = urlMessage;
        req.scene = WXSceneTimeline; //选择发送到朋友圈WXSceneTimeline，默认值为WXSceneSession发送到会话
        [WXApi sendReq:req];
    }else{
        ALERT_VIEW( @"您未安装微信或版本不支持");
        _alert = nil;
    }
}
//微博分享
- (IBAction)weiboShareBtnClick:(id)sender {
    if ([WeiboSDK isCanShareInWeiboAPP]) {
        //新浪分享
        WBMessageObject *message = [WBMessageObject message];
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = [_dataDic objectForKey:@"title"];
        webpage.description = [_dataDic objectForKey:@"desc"];
        NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"logoPshare"]);
        webpage.thumbnailData = data;
        
        webpage.webpageUrl = [NSString stringWithFormat:@"http://%@/share/%@",_temSerVerID,[_dataDic objectForKey:@"link"]];
        message.mediaObject = webpage;
        
        WBSendMessageToWeiboRequest *requestObject = [WBSendMessageToWeiboRequest requestWithMessage:message];
        requestObject.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:requestObject];
    }else{
        ALERT_VIEW( @"您未安装新浪微博或版本不支持");
        _alert = nil;
    }
}

- (IBAction)shareBtnClick:(id)sender {
    ShareView *shareView;
    if (!shareView) {
        shareView = [[ShareView alloc] init];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_url,@"url",_titleStr,@"title",_imagePath,@"imagePath", nil];
        shareView.dataDic = dic;
        [self.view addSubview:shareView];
        [shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    
    [shareView ShareViewShow];
}


- (void)dealloc
{
    MyLog(@"webView  dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
