//
//  subLabel.m
//  P-Share
//
//  Created by fay on 16/3/23.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "subLabel.h"
#import "WSBezier.h"

#define KMaxTimes 100

@implementation subLabel

NSMutableArray *totlePoints; //纪录所有的点。

WSBezier *bezier;  //通过 改变bezier 函数的参数  （也就是 四个 控制点）可以改变动画的样式 －

float _duration; // 动画 间隔
float _fromNum;
float _toNum;

float _lastTime; //纪录每一个点的 时刻

int _index;


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self _initBezier];
        [self _cleanVars];
    }
    
    return self;
}

- (void)_cleanVars{
    
    _lastTime = 0;
    _index = 0;
    self.text = @"0";
    
}


//初始化 控制点
- (void)_initBezier{
    
    
    bezier = [[WSBezier alloc] init];
}


- (void)animationFromnum:(float)fromNum toNum:(float)toNum duration:(float)duration{
    [self _initBezier];

    [self _cleanVars];
    
    _duration = duration;
    _fromNum = fromNum;
    _toNum = toNum;
    
    
    totlePoints = [NSMutableArray array];
    float dt = 1.0 / (KMaxTimes - 1);
    for (NSInteger i = 0; i < KMaxTimes; i ++ ) {
        
        WSPoint point = [bezier  pointWithdt:dt * i];
        
        
        float currTime = point.x * _duration;
        float currValue = point.y * (_toNum - _fromNum) + _fromNum;
        
        NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:currTime] , [NSNumber numberWithFloat:currValue], nil];
        [totlePoints addObject:array];
        
    }
    
    [self changeNumberBySelector];
    
}

- (void)changeNumberBySelector {
    if (_index>= KMaxTimes) {
        self.text = [NSString stringWithFormat:@"%.2f",_toNum];
        return;
    } else {
        NSArray *pointValues = [totlePoints objectAtIndex:_index];
        _index++;
        float value = [(NSNumber *)[pointValues objectAtIndex:1] intValue];
        float currentTime = [(NSNumber *)[pointValues objectAtIndex:0] floatValue];
        float timeDuration = currentTime - _lastTime;
        _lastTime = currentTime;
        self.text = [NSString stringWithFormat:@"%.2f",value];
        [self performSelector:@selector(changeNumberBySelector) withObject:nil afterDelay:timeDuration];
    }
}

@end
