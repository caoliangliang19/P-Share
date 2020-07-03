//
//  CLLTextView.h
//  ETCP输入框
//
//  Created by 亮亮 on 16/8/30.
//  Copyright © 2016年 亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLTextView : UIView
@property (nonatomic,copy)void (^CLLTextViewBlock)(NSString *);

- (void)onShow;
- (void)onHidden;

@property (nonatomic,copy)NSString *carNum;

@end
