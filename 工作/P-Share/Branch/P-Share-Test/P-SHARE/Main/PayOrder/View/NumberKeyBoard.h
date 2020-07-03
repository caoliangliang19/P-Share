//
//  NumberKeyBoard.h
//  P-SHARE
//
//  Created by fay on 16/9/21.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@protocol NumberKeyBoardDelegate <NSObject>

- (void)numberKeyBoardChange:(NSString *)number;


@end
@interface NumberKeyBoard : BaseView

@property (nonatomic,assign)id <NumberKeyBoardDelegate>delegate;
+ (instancetype)createNumberKeyBoard;

@end
