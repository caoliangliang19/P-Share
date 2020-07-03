//
//  UIColor+Category.h
//  KouDaiYun
//
//  Created by fay on 16/8/17.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)
/**
 *  16进制颜色转换
 */
+ (UIColor *)colorWithHexString: (NSString *)color;
@end
