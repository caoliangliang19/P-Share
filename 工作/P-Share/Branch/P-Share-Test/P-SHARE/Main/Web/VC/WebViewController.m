//
//  WebViewController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "WebViewController.h"
#import "ShareView.h"
#import "ShareModel.h"
#import "WebInfoModel.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "FayWebView.h"

@interface WebViewController ()<NJKWebViewProgressDelegate,UIWebViewDelegate>
{
    FayWebView      *_webView;
    NSURLRequest    * _request;
    NSDictionary    *_dataDic;
    ShareView       *_shareView;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
    
}
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];

    if (_webModel.urlType == URLTypeNet) {
        [self loadWebViewProgress];
    }

}

- (void)setWebModel:(WebInfoModel *)webModel
{
    _webModel = webModel;
    self.title = webModel.title;
    if (webModel.shareType == WebInfoModelTypeShare) {
        [self createRightBarItem];
        [self loadWebViewProgress];
    }
    
}


#pragma mark - 创建WebView
- (void)createWebView{
    FayWebView *webView = [[FayWebView alloc] init];
    webView.webModel = _webModel;
    _webView = webView;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.left.bottom.mas_equalTo(0);
    }];
}

- (void)loadWebViewProgress
{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 3.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.progress = 0.0f;
    _progressView.progressBarView.backgroundColor = [UIColor whiteColor];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}
- (void)createRightBarItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    button.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"share"];
    [button addSubview:imageView];
    [button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
   
}
#pragma mark -- 点击分享
- (void)share:(UIButton *)btn{
    
    ShareModel *shareModel = [ShareModel new];
    shareModel.title = _webModel.title;
    if (![UtilTool isBlankString:_webModel.descibute]) {
        shareModel.describute = _webModel.descibute;
    }else
    {
        shareModel.describute = @"";

    }
    shareModel.url = _webModel.url;
    shareModel.imagePath = _webModel.imagePath;
    if (!_shareView) {
        _shareView = [ShareView createShareView];
    }
    _shareView.shareModel = shareModel;
    
    [_shareView ShareViewShow];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_webView.webView stringByEvaluatingJavaScriptFromString:@"XinLang()"];
    
}
- (void)pasteboard:(NSString *)pasteStr
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:pasteStr];
    [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"复制成功"];
    
}


#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
}

@end
