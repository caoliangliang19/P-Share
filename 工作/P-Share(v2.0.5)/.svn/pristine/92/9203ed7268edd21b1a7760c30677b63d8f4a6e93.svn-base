//
//  SearchVC.h
//  P-Share
//
//  Created by fay on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerModel.h"


@interface SearchVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *familyParking;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic,copy) NSString *parkingName;


@property (nonatomic,copy)void (^SearchVCBlock)(ManagerModel *model);
- (IBAction)cencleBtn:(UIButton *)sender;

- (IBAction)familyParking:(UIButton *)sender;


@end
