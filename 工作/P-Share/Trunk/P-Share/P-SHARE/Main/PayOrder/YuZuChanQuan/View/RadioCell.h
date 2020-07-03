//
//  RadioCell.h
//  P-SHARE
//
//  Created by fay on 16/9/5.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioCell : UITableViewCell
@property (nonatomic,strong)UIImageView *leftImageV;
@property (nonatomic,strong)UILabel     *titleL;
@property (nonatomic,assign)BOOL        isSelect;

@end
