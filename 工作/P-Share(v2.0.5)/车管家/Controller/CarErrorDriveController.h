//
//  CarErrorDriveController.h
//  P-Share
//
//  Created by 亮亮 on 16/1/14.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarErrorDriveController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIPickerView *placePickerView;
@property (weak, nonatomic) IBOutlet UILabel *carErrorPlace;
@property (weak, nonatomic) IBOutlet UILabel *telePhone;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
- (IBAction)firstButton:(id)sender;
- (IBAction)secondButton:(id)sender;
- (IBAction)lastBlueButton:(id)sender;

- (IBAction)backBtnClick:(UIButton *)sender;
@end
