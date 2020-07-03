//
//  PersonCenterCell.h
//  P-SHARE
//
//  Created by 亮亮 on 16/9/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCenterCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *logoImageView;
@property (nonatomic,strong)UILabel *titieL;
@property (nonatomic,strong)UILabel *detailL;
@property (nonatomic,copy)NSIndexPath *indexPath;

- (void)setIndexPath:(NSIndexPath *)indexPath setMoney:(NSMutableArray *)moneyArray;
//+ (instancetype)instranceWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;


@end
