//
//  CodeTextCell.h
//  P-Share
//
//  Created by 亮亮 on 16/3/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QGPassWordTextField.h"
typedef void (^myTextFieldBlock)(NSArray *);

@interface CodeTextCell : UITableViewCell<UITextFieldDelegate>
{
    UILabel *_lable1;
    UILabel *_lable2;
}
@property (nonatomic,strong)QGPassWordTextField *pass;
@property (nonatomic,strong)QGPassWordTextField *pass1;

@property (nonatomic,copy)myTextFieldBlock myBlock;
@property (weak, nonatomic) IBOutlet UIView *grayView;




@end
