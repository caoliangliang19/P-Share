//
//  LocationTool.m
//  P-Share
//
//  Created by fay on 16/7/26.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "LocationTool.h"

static LocationTool *tool = nil;

@implementation LocationTool
+ (LocationTool *)shareLocationTool
{
   
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!tool) {
            tool = [[LocationTool alloc] init];
        }
    });
    
    return tool;
    
}
@end
