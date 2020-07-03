//
//  YuYueTimeModel.h
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YuYueTimeModel : NSObject
@property (nonatomic,copy)NSString *week;//该套餐包含的时间
@property (nonatomic,copy)NSString *price;
//选择时间部分
@property (nonatomic,copy)NSString *date;
@property (nonatomic,copy)NSString *endTime;
@property (nonatomic,copy)NSString *startTime;
//选择套餐部分
@property (nonatomic,copy)NSString *Id;
@property (nonatomic,copy)NSString *parkingId;
@property (nonatomic,copy)NSString *week1;//该套餐属于的时间
@property (nonatomic,copy)NSString *parkingName;

@property (nonatomic,assign)BOOL isSelect;


+ (YuYueTimeModel *)shareYuYUeTimeModel:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;


@end

