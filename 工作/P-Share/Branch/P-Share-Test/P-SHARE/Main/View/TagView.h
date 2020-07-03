//
//  TagView.h
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    TagViewStyleSet,
    TagViewStyleShow
}TagViewStyle;

@interface TagView : UIView
@property (nonatomic,strong) NSMutableArray             *dataArray;
@property (nonatomic,strong) NSMutableArray             *dataArrayTwo;
@property (nonatomic,strong) NSMutableArray             *tagOneArray,
                                                        *tagTwoArray;
@property (nonatomic,assign)TagViewStyle                style;

@end
