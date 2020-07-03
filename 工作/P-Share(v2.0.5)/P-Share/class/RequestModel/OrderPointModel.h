//
//  OrderPointModel.h
//  P-Share
//
//  Created by fay on 16/3/31.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPointModel : NSObject
@property (nonatomic,assign)NSInteger   equity,//产权
                                        monthly,//月租
                                        paker;// 代泊

+ (OrderPointModel *)shareOrderPointModelWithDic:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;
+ (id)shareOrderPoint;

@end
