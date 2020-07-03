//
//  keyBoardView.h
//  P-Share
//
//  Created by 亮亮 on 16/4/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol keyBoardViewDelegate <NSObject>

- (void)passOnValueString:(NSString *)string;
- (void)changeSystemClick:(NSInteger)index;
- (void)deleteTextFieldTitle;

@end
@interface keyBoardView : UIView

@property (nonatomic,assign)id<keyBoardViewDelegate>delegate;
- (void)createkey;
- (void)createLastkey;
@end
