//
//  CoordinateModel.m
//  P-Share
//
//  Created by fay on 16/4/29.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CoordinateModel.h"
static CoordinateModel *model = nil;

@implementation CoordinateModel
+ (CoordinateModel *)shareCoodinateModel
{
    @synchronized(self) {
        if (model == nil) {
            model = [[CoordinateModel alloc] init];
            
        }
    }
    
    return model;
}

+ (id)alloc
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (model == nil) {
            model = [super alloc];
            
        }
    });
    
    return model;
    
}

@end
