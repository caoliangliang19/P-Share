//
//  CommentModel.m
//  P-Share
//
//  Created by fay on 16/6/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CommentModel.h"
#import "TagModel.h"

@implementation CommentModel
+ (CommentModel *)shareCommentModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
}
- (id)initWithDic:(NSDictionary *)dic
{
    if (self == [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"start1"] || [key isEqualToString:@"start2"]|| [key isEqualToString:@"start3"]||[key isEqualToString:@"start4"]||[key isEqualToString:@"start5"]) {
        NSMutableArray *temArray = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            TagModel *model = [TagModel shareTagModelWithDic:dic];
            [temArray addObject:model];
        }

        if ([key isEqualToString:@"start1"]) {
            self.startOne = temArray;
        }else if ([key isEqualToString:@"start2"]){
            self.startTwo = temArray;
        }else if ([key isEqualToString:@"start3"]){
            self.startThree = temArray;
        }else if ([key isEqualToString:@"start4"]){
            self.startFour = temArray;
        }else if ([key isEqualToString:@"start5"]){
            self.startFive = temArray;
        }
    }
}

@end
