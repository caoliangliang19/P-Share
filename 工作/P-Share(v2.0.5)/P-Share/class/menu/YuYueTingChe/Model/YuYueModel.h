//
//  YuYueModel.h
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TextCell;
@class YuYueTimeModel;

@interface YuYueModel : NSObject
@property (nonatomic,copy)NSString  *sharePriceComment;
@property (nonatomic,strong)NSArray *weekArray;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong)TextCell *cell;
@property (nonatomic,strong)YuYueTimeModel *descributeModel;

- (id)initWithDic:(NSDictionary *)dic;
+ (YuYueModel *)shareYuYueModelWithDic:(NSDictionary *)dic;



@end
