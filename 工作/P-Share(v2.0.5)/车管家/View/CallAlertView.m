//
//  CallAlertView.m
//  P-Share
//
//  Created by fay on 16/1/14.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "CallAlertView.h"

@implementation CallAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    _callBtn.layer.borderColor = NEWMAIN_COLOR.CGColor;
    _callBtn.layer.borderWidth = 3;
    
    
}
- (IBAction)callBtnClick:(UIButton *)sender {
    if (self.callServer) {
        self.callServer();
        
    }
}


@end
