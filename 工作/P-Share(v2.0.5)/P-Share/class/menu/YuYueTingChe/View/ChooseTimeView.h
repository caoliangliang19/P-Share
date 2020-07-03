//
//  ChooseTimeView.h
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YuYueTimeModel;

typedef enum {
    ChooseTimeViewStyleUnSelect,
    ChooseTimeViewStyleSelect,
    
}ChooseTimeViewStyle;

@interface ChooseTimeView : UIView

@property (nonatomic,assign)ChooseTimeViewStyle style;
@property (nonatomic,strong)YuYueTimeModel *model;
@property (nonatomic,copy)void (^changeStyleBlock)(ChooseTimeView *);


@end
