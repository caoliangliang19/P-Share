//
//  CarKindModel.h
//  P-Share
//
//  Created by fay on 16/4/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarKindModel : NSObject
@property (nonatomic,copy)NSString *ID,*nodeCode,*nodeName,*icon,*levels,*sort,*parentCode,*isLeaf,*isUsed;

@property (nonatomic,retain)NSMutableArray *carDataArray;


+ (CarKindModel *)shareCarKindModel:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;

@end
