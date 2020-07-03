//
//  HomeArray.m
//  P-Share
//
//  Created by fay on 16/4/6.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "HomeArray.h"

static HomeArray *homeArr = nil;

@implementation HomeArray
+ (HomeArray *)shareHomeArray
{
    @synchronized(self) {
        if (homeArr == nil) {
            homeArr = [[HomeArray alloc]init];
            
        }
    }
    
    return homeArr;
    
}

+ (id)alloc
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (homeArr == nil) {
            homeArr = [super alloc];
            
        }
    });
    
    return homeArr;
    
}


@end
