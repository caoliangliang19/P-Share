//
//  DBManager.h
//  Pop Daily
//
//  Created by qianfeng on 15/7/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagerModel.h"

@interface DBManager : NSObject

+ (DBManager *)sharedInstance;

- (void)addSearchtModel:(ManagerModel *)model;

- (NSArray *)searchAllModel;

- (void)deleteModel:(ManagerModel *)model;

- (BOOL)isModelExists:(ManagerModel *)model;

- (void)deleteAllModel;

@end
