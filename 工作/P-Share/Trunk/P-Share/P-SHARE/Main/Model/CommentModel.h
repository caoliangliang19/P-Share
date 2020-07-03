//
//  CommentModel.h
//  P-Share
//
//  Created by fay on 16/6/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic,copy)NSMutableArray    *startOne,
                                            *startTwo,
                                            *startThree,
                                            *startFour,
                                            *startFive;
+ (CommentModel *)shareCommentModelWithDic:(NSDictionary *)dic;
- (id)initWithDic:(NSDictionary *)dic;

@end
