//
//  PopView.h
//  farProgressView
//
//  Created by fay on 16/8/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TagLabel;
typedef enum {
    PopViewPositionTop,
    PopViewPositionBottom,
}PopViewPosition;
@interface PopView : UIView
@property (nonatomic,assign)PopViewPosition popViewPosition;
@property (nonatomic,strong)TagLabel        *numL;

@end
