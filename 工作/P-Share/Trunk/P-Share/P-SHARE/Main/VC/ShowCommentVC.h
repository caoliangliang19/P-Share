//
//  ShowCommentVC.h
//  P-Share
//
//  Created by fay on 16/6/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ShowCommentVCStyleOne,
    ShowCommentVCStyleTwo,
}ShowCommentVCStyle;
@interface ShowCommentVC : BaseViewController
@property (nonatomic,assign)ShowCommentVCStyle style;
@property (nonatomic,strong)OrderModel *model;

@end
