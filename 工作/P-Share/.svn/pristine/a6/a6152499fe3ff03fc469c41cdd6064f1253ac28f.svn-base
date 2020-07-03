//
//  PopView.m
//  farProgressView
//
//  Created by fay on 16/8/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PopView.h"
#import "TagLabel.h"

#import "UIView+Extension.h"
@interface PopView()
{
    UIImageView     *_imageView;
}
@end
@implementation PopView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
    
}
- (void)setupSubView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView = imageView;

    TagLabel *label = [[TagLabel alloc] initWithFrame:CGRectMake(0, 5, self.K_width, self.K_height - 5)];
    label.font = [UIFont systemFontOfSize:13];
    _numL = label;
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.text = @"0";
    label.textColor = [UIColor whiteColor];
    [self addSubview:imageView];
    [self addSubview:label];
    
}
- (void)setPopViewPosition:(PopViewPosition)popViewPosition
{
    _popViewPosition = popViewPosition;
    UIImage *image = [UIImage imageNamed:@"item_integral_bg"];
    if (popViewPosition == PopViewPositionTop) {
        _numL.frame = CGRectMake(0, 5, self.K_width, self.K_height - 5);
        _imageView.image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:image.size.height * 0.25];
    }else
    {
        _imageView.transform = CGAffineTransformMakeRotation(M_PI);
        _imageView.image = [image stretchableImageWithLeftCapWidth:0 topCapHeight:image.size.height * 0.25];
        _numL.frame = CGRectMake(0, 0, self.K_width, self.K_height - 5);
    }
}
@end
