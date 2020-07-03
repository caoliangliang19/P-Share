//
//  OldYuYueViewController.h
//  P-SHARE
//
//  Created by fay on 2016/11/11.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseViewController.h"

@interface OldYuYueViewController : BaseViewController

@end
@interface OldYuYueViewController (LoadData)

- (void)loadData;
- (void)requestYuYueTingChaTaoCanWithDay:(YuYueTimeModel *)timeModel;

@end
