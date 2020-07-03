//
//  SetSecondController.h
//  P-SHARE
//
//  Created by 亮亮 on 16/9/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger , CLLSetControllerState){
    CLLSetControllerStateAdvice = 0,
    CLLSetControllerStateWe,
    CLLSetControllerStateHelp
    
};
@interface SetSecondController : BaseViewController

@property (nonatomic , assign)CLLSetControllerState state;

@end
