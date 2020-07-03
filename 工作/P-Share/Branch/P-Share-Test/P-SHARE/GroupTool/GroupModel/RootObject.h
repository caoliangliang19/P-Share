//
//  RootObject.h
//  P-SHARE
//
//  Created by fay on 16/8/30.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootObject : NSObject
/**
 *  类方法,根据kvc对对象赋值
 *
 *  @param dic 赋值字典
 *
 *  @return 返回对象
 */
+ (instancetype)shareObjectWithDic:(NSDictionary *)dic;
/**
 *  重载init方法
 */
- (id)initWithDic:(NSDictionary *)dic;

@end
