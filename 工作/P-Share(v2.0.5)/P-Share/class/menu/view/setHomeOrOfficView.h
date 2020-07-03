//
//  setHomeOrOfficView.h
//  P-Share
//
//  Created by fay on 16/5/3.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setHomeOrOfficView : UIView
@property (nonatomic,copy)void (^setHomeOrOfficViewBlocl)(UIButton *btn);

- (void)showInView:(UIView *)view;
- (void)hide;

@end
