//
//  TextViewCell.h
//  P-SHARE
//
//  Created by fay on 16/9/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell
@property (nonatomic,copy)void (^textFieldCellCallBackBlock)(UITextField *);

@property (nonatomic,strong)UITextField *textField;

@end
