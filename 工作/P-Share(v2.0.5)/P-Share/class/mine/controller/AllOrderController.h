//
//  AllOrderController.h
//  P-Share
//
//  Created by 亮亮 on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrderController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *orderScrollView;
@property (weak, nonatomic) IBOutlet UIButton *allOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *noPayForBtn;
@property (weak, nonatomic) IBOutlet UIButton *noAssessBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedLayout;
- (IBAction)stopCarProveBtn:(UIButton *)sender;
- (IBAction)backFome:(id)sender;
@end
