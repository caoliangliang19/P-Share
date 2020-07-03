//
//  ShareView.h
//  P-SHARE
//
//  Created by 亮亮 on 16/9/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
@class ShareModel;

@interface ShareView : UIView
@property (nonatomic,strong)ShareModel *shareModel;

+ (ShareView *)createShareView;
- (void)ShareViewShow;
- (void)ShareViewHidden;

@end
