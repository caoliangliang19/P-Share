//
//  MapBottomView.h
//  P-SHARE
//
//  Created by fay on 16/8/31.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseView.h"

@interface MapBottomViews : BaseView

/**
 *  用来保存最上方的view
 */
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *bottomView;


- (void)refreshBottomViewsData;

@end
