//
//  SearchBarView.h
//  P-SHARE
//
//  Created by fay on 16/9/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseView.h"

@interface SearchBarView : BaseView
/**
 *  搜索结果回调
 */
@property (nonatomic,copy)void (^searchResultBlock)(SearchBarView *searchBarView,NSArray *resultArray);

- (void)endEdit;
- (void)beginEdit;

@end
