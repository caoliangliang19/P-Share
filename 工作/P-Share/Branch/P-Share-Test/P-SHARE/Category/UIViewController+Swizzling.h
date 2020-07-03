//
//  UIViewController+Swizzling.h
//  P-Share
//
//  Created by fay on 16/10/12.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Swizzling)
//@property (nonatomic,strong)NSMutableDictionary *taskQueue;

/**
 添加网络请求队列

 @param task 需要添加的队列
 */
- (void)addTask:(NSURLSessionDataTask *)task;
/**
 删除网络请求队列
 
 @param task 需要删除的队列
 */
- (void)removeTask:(NSURLSessionDataTask *)task;
/**
 返回网络请求队列所在容器
 */
- (NSMutableDictionary *)taskQueue;

/**
 判断是否有正在请求的网络队列

 @return yes:有 no:没有
 */
- (BOOL)hasRequestQueue;

/**
清空网络请求队列
 */
- (void)cancelRequest;

@end
