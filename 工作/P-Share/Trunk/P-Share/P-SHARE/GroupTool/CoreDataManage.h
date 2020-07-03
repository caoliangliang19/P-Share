//
//  CoreDataManage.h
//  P-SHARE
//
//  Created by fay on 16/9/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManage : NSObject
+ (NSManagedObjectContext *)createMOC;

@end
