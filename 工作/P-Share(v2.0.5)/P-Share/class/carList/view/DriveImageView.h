//
//  DriveImageView.h
//  P-Share
//
//  Created by 亮亮 on 16/7/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DriveImageView : UIView
- (instancetype)initWithController:(UIViewController *)controller;
- (instancetype)initWithView:(UIView *)mainView;
- (void)show;
- (void)hide;
@end
