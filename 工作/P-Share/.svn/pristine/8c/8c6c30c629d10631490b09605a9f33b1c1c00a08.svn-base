//
//  KeyView.h
//  ETCP输入框
//
//  Created by 亮亮 on 16/8/31.
//  Copyright © 2016年 亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyViewDelegate <NSObject>

- (void)deleteKey;
- (void)addKeyText:(UIButton *)button;

@end

@interface KeyView : UIView

@property (nonatomic , strong)UIScrollView *scrollView;

@property (nonatomic , weak)id<KeyViewDelegate>delegate;

@end
