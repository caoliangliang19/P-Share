//
//  CollectionHeadView.h
//  P-Share
//
//  Created by 亮亮 on 16/8/23.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CollectionHeadView : UICollectionReusableView

+ (instancetype)viewWithCollectionViewHead:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath atCustomerDic:(NSDictionary *)customerDic;

@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *iPhoneL;
@property (weak, nonatomic) IBOutlet UIImageView *csrImage;
@property (weak, nonatomic) IBOutlet UILabel *csrL;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardL;

@property (strong , nonatomic)NSDictionary *customerDic;

@property (weak, nonatomic) IBOutlet UIView *downView;


@property (weak, nonatomic) IBOutlet UILabel *sectionTitleL;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic , assign)NSInteger second;

@property (nonatomic,copy)void(^headViewBlock)(NSInteger);
@property (nonatomic,copy)void(^personInfo)();

- (IBAction)moreBtn:(UIButton *)myButton;
@end
