//
//  TagModel.h
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagModel : NSObject
@property (nonatomic,strong)NSString *info;
@property (nonatomic,assign)BOOL isZan;
@property (nonatomic,assign)BOOL isSelect;

+ (TagModel *)shareTagModelWithDic:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;

@end
