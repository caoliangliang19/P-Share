//
//  walletView.m
//  P-Share
//
//  Created by fay on 16/3/23.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "walletView.h"

@implementation walletView


- (void)drawRect:(CGRect)rect {
    
    _payBtn.layer.cornerRadius = 4;
    _payBtnWidth.constant = SCREEN_WIDTH * 0.46;
    _moneyViewWidth.constant = SCREEN_WIDTH * 0.565;
    
//    if (SCREEN_WIDTH == 320) {
//        rect.size.height = 550;
//    }
//    self.frame = rect;
   
}



@end
