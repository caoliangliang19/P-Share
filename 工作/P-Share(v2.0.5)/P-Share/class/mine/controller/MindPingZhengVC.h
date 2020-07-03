//
//  MindPingZhengVC.h
//  P-Share
//
//  Created by fay on 16/3/9.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MindPingZhengVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *proveScrollView;
@property (weak, nonatomic) IBOutlet UIButton *noUserBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesUserBtn;
@property (weak, nonatomic) IBOutlet UIButton *noHaveBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedLayout;
- (IBAction)stopCarProveBtn:(UIButton *)sender;

@end
