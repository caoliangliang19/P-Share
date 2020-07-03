//
//  subLabel.m
//  P-Share
//
//  Created by fay on 16/3/23.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "TagLabel.h"
#import "POPNumberAnimation.h"

#define KMaxTimes 100

@interface TagLabel ()<POPNumberAnimationDelegate>
@property (nonatomic,strong) POPNumberAnimation *numberAnimation;
@end
@implementation TagLabel
- (void)animationFromnum:(float)fromNum toNum:(float)toNum duration:(float)duration{
    self.numberAnimation = [[POPNumberAnimation alloc] init];
    self.numberAnimation.delegate        = self;
    self.numberAnimation.fromValue      = fromNum;
    self.numberAnimation.toValue        = toNum;
    
    self.numberAnimation.duration       = duration;
    self.numberAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.69 :0.11 :0.32 :0.88];
    [self.numberAnimation saveValues];
    [self.numberAnimation startAnimation];

    
}
#pragma mark --- POPNumberAnimationDelegate
- (void)POPNumberAnimation:(POPNumberAnimation *)numberAnimation currentValue:(CGFloat)currentValue
{
    
    MyLog(@"currentValue --->%lf",currentValue);
    // Init string.
    NSString *numberString = [NSString stringWithFormat:@"%.1f", currentValue];
    self.text = numberString;
    
}


@end
