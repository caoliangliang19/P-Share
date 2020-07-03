//
//  CollectionHeadView.m
//  P-Share
//
//  Created by 亮亮 on 16/8/23.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CollectionHeadView.h"
#import "FayBaseProgress.h"
#import "SDImageCache.h"

@interface CollectionHeadView ()
{
    
}
@property (nonatomic,strong)FayBaseProgress *fayProgress;
@end

@implementation CollectionHeadView
+ (instancetype)viewWithCollectionViewHead:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath atCustomerDic:(NSDictionary *)customerDic;{
    static NSString *identifier = @"celliD";
    CollectionHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
    view.customerDic = customerDic;
    [view createDic];
    return view;
}
- (void)createDic{
    
//    CGFloat value = [self.customerDic[@"growthValue"] floatValue];
    CGFloat scale = SCREEN_WIDTH/375;
//    if (self.customerDic.count != 0 && _fayProgress == nil) {
//        _fayProgress = [[FayBaseProgress alloc]initWithFrame:CGRectMake(90, 35, 140*scale, 20) LineHeight:10.0f Progress:[self.customerDic[@"growthValue"] floatValue]/[self.customerDic[@"growthLower"] floatValue] space:8.0f ProgressValue:value FayBaseProgressStyle:FayBaseProgressStyleTop];
//  
//        _fayProgress.backgroundColor = [UIColor clearColor];
//        _fayProgress.imageSize = 16.0f;
//        _fayProgress.imageArray = @[@"Grade_Platinum_50",@"Grade_Platinum_50"];
//    }
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        BOOL  visitorBool = [userDefaults boolForKey:@"visitorBOOL"];
//    if (visitorBool == NO&&_fayProgress == nil) {
//        _fayProgress = [[FayBaseProgress alloc]initWithFrame:CGRectMake(90, 35, 140*scale, 20) LineHeight:10.0f Progress:0/100 space:8.0f ProgressValue:0 FayBaseProgressStyle:FayBaseProgressStyleTop];
//        _fayProgress.backgroundColor = [UIColor clearColor];
//        _fayProgress.imageSize = 16.0f;
//        _fayProgress.imageArray = @[@"Grade_Diamonds_34",@"Grade_GoldenCard_34",@"Grade_Diamonds_34",@"Grade_GoldenCard_34"];
//    }
    if (!_fayProgress) {
        _fayProgress = [[FayBaseProgress alloc]initWithFrame:CGRectMake(90, 35, 140*scale, 20) LineHeight:10.0f Progress:0.35 space:8.0f ProgressValue:1034 FayBaseProgressStyle:FayBaseProgressStyleTop];
        _fayProgress.backgroundColor = [UIColor clearColor];
        _fayProgress.imageSize = 16.0f;
        _fayProgress.imageArray = @[@"Grade_Platinum_50",@"Grade_Platinum_50",@"Grade_Platinum_50",@"Grade_Platinum_50"];
        
        [self.upView addSubview: self.fayProgress];
    }
   
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.cardL.layer.cornerRadius = 10.5f;
    self.cardL.clipsToBounds = YES;
    [UtilTool isVisitor];
    GroupManage *manage = [GroupManage shareGroupManages];
    if (manage.isVisitor == YES) {
        self.iPhoneL.text = @"游客";
    }else{
        self.iPhoneL.text = manage.user.customerMobile;
    }
     [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UtilTool getCustomerInfo:@"customerHead"]] placeholderImage:[UIImage imageNamed:@"item_Head-portrait_114"]];
    self.headImageView.userInteractionEnabled = YES;
    self.headImageView.layer.cornerRadius = 30.0f;
    self.headImageView.clipsToBounds = YES;
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onHeadImage)];
    [self.upView addGestureRecognizer:tap];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selector) name:LOGIN_SUCCESS object:nil];
}


- (void)selector{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UtilTool getCustomerInfo:@"customerHead"]] placeholderImage:[UIImage imageNamed:@"item_Head-portrait_114"]];
}
- (void)onHeadImage{
    if (self.personInfo) {
        self.personInfo();
    }
}
- (IBAction)moreBtn:(UIButton *)myButton;{
    if (self.headViewBlock) {
        self.headViewBlock(self.second);
    }
}
@end
