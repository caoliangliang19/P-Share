//
//  CommentVC.h
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CommentVCStyleOne,
    CommentVCStyleTwo,
}CommentVCStyle;
@interface CommentVC : BaseViewController
@property (nonatomic,assign)CommentVCStyle style;
@property (nonatomic,strong)OrderModel *model;

@end
