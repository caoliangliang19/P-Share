//
//  GetCarAlert.h
//  P-Share
//
//  Created by 亮亮 on 16/4/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^turnBtn)();
typedef void (^cancleBtn)();

@interface GetCarAlert : UIView

@property (copy , nonatomic)turnBtn tureBlock;
@property (copy , nonatomic)cancleBtn cancleBlock;

- (void)tureBlock:(void(^)())tureBlock cancleBlock:(void(^)())cancleBlock;

- (void)show;
- (void)hide;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *getTimeL;

- (IBAction)goToPayFor:(UIButton *)sender;
- (IBAction)cancleBtn:(UIButton *)sender;
- (IBAction)deleteBtn:(UIButton *)sender;
@end
