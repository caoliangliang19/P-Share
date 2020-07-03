//
//  fayBaseProgress.h
//  farProgressView
//
//  Created by fay on 16/8/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    FayBaseProgressStyleTop,
    FayBaseProgressStyleBottom,
}FayBaseProgressStyle;
@interface FayBaseProgress : UIView
/**
 *  进度 0-1
 */
@property (nonatomic,assign)float progress;
/**
 *  进度值数字
 */
@property (nonatomic,assign)float value;
/**
 *  等级图片大小 默认 30
 */
@property (nonatomic,assign)float imageSize;

/**
 *  背景颜色
 */
@property (nonatomic,strong)UIColor *bgColor;

/**
 *  进度颜色
 */
@property (nonatomic,strong)UIColor *tintColor;
/**
 *  线高
 */
@property (nonatomic,assign)CGFloat lineHeight;

/**
 *  图片数组
 */
@property (nonatomic,strong)NSArray *imageArray;

@property (nonatomic,assign)FayBaseProgressStyle fayBaseProgressStyle;

/**
 *  构造方法
 *
 *  @param progress             进度
 *  @param FayBaseProgressStyle 类型
 */
- (instancetype)initWithFrame:(CGRect)frame LineHeight:(CGFloat)lineHeight Progress:(CGFloat)progress space:(CGFloat)spaceY ProgressValue:(CGFloat)value FayBaseProgressStyle:(FayBaseProgressStyle)fayBaseProgressStyle;


@end
