//
//  UIAlertController+supportedInterfaceOrientations.m
//  P-SHARE
//
//  Created by fay on 16/9/12.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "UIAlertController+supportedInterfaceOrientations.h"

@implementation UIAlertController (supportedInterfaceOrientations)
/**
 *  解决UIAlertController:supportedInterfaceOrientations was invoked recursively!
 *
 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#endif

@end
