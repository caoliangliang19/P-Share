//
//  ADView.h
//  P-Share
//
//  Created by fay on 16/5/21.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADView : UIView
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)UIImageView *adImageView;
@property (nonatomic,copy)void (^ImageTapBlock)();


@end
