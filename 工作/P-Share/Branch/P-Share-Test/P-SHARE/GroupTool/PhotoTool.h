//
//  PhotoTool.h
//  P-SHARE
//
//  Created by fay on 16/9/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTool : UIViewController
/**
 *  创建PhotoTool
 *
 *  @param isCamera yes:拍照 no:相册
 *
 *  @return
 */
+ (instancetype)createToolWithType:(BOOL)isCamera WithViewController:(UIViewController *)vc;
- (id)initWithType:(BOOL)isCamera WithViewController:(UIViewController *)vc;
- (void)setImagePickView;

@end
