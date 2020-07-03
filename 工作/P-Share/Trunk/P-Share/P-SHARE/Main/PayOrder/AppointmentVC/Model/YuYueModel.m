//
//  YuYueModel.m
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "YuYueModel.h"
//#import "TextCell.h"
#import "OldTextCell.h"
#import "YuYueTimeModel.h"
@implementation YuYueModel

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        _cellHeight = [UtilTool getStringHeightWithString:self.sharePriceComment Font:14 MaxWitdth:SCREEN_WIDTH-40]+20;
         return _cellHeight;
    }
    
    return _cellHeight;
    
}

- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}
+ (YuYueModel *)shareYuYueModelWithDic:(NSDictionary *)dic
{
    return [[self alloc] initWithDic:dic];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"week"]) {
        NSMutableArray *weekArray = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            YuYueTimeModel *model = [YuYueTimeModel shareObjectWithDic:dic];
            [weekArray addObject:model];
        }
        self.weekArray = weekArray;
    }
    
    if ([key isEqualToString:@"packagePrice"]) {
        YuYueTimeModel *model = [YuYueTimeModel shareObjectWithDic:value[@"packagePrice"][0]];
        _descributeModel = model;
    }
}

@end
