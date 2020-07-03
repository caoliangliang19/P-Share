//
//  UserCenterCell.h
//  P-SHARE
//
//  Created by 亮亮 on 16/11/11.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UserCenterCell : UITableViewCell

@property (nonatomic , strong)UILabel     *mainL;
@property (nonatomic , strong)UILabel     *subL;
@property (nonatomic , strong)UIImageView *leftImageV;
@property (nonatomic , strong)UIImageView *rightImageV;
@property (nonatomic , strong)UILabel     *rightL;

+(instancetype)installCellTableView:(UITableView *)tanleView;

- (void)setStyleCellIndexPath:(NSIndexPath *)indexPath;

@end
