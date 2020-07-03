//
//  WebView.h
//  KouDaiYun
//
//  Created by fay on 16/8/17.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"

typedef enum {
    WebViewStatusStartLoad,
    WebViewStatusLoading,
    WebViewStatusEndLoad
}WebViewStatus;
@interface FayWebView : UIView
@property (nonatomic,strong)WebInfoModel *webModel;
@property (nonatomic,assign)WebViewStatus webStatus;
@property (nonatomic,copy)void (^webViewLoadStatus)(WebViewStatus status);
@property (nonatomic,strong)UIWebView *webView;
@end
