//
//  ServerInfoModel.h
//  P-Share
//
//  Created by fay on 16/1/21.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerInfoModel : NSObject
@property (nonatomic,copy)NSString *srvName,*srvId,*intro;
@property (nonatomic,retain)NSArray *srvBilling;

+ (ServerInfoModel *)shareModelWithDic:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;


@end
