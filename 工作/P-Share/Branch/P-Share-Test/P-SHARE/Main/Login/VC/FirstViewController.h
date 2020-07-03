//
//  FirstViewController.h
//  P-SHARE
//
//  Created by 亮亮 on 16/9/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^firstBlock)();

@interface FirstViewController : BaseViewController

@property (nonatomic , copy)firstBlock myBlock;

@end
