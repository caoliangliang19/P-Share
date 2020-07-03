//
//  WebViewController.h
//  P-Share
//
//  Created by fay on 16/1/20.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,WebViewControllerType) {
    WebViewControllerTypeUnNeedShare = 0,
    WebViewControllerTypeNeedShare,
};
@interface WebViewController : UIViewController
@property (nonatomic,retain)NSString *url;
@property (nonatomic,copy)NSString *kind;
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,copy)NSString *imagePath;
@property (nonatomic,assign)WebViewControllerType type;


@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (weak, nonatomic) IBOutlet UIView *shareView;


@end
