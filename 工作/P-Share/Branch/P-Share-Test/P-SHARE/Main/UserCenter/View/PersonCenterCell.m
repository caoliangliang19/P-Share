//
//  PersonCenterCell.m
//  P-SHARE
//
//  Created by 亮亮 on 16/9/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PersonCenterCell.h"

@interface PersonCenterCell ()
{
   
    UIView *_lineView;
    
}



@property (nonatomic,strong)NSArray *titleArray;
@end

@implementation PersonCenterCell
//+ (instancetype)instranceWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;{
//    PersonCenterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellID" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
//    
//    
//    return cell;
//}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         self.backgroundColor = [UIColor whiteColor];
        [self createCellUI];
    }
    return self;
}
- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@[@"生日礼包",@"专享礼包",@"新人礼包",@"会员特价"],@[@"待付款",@"待评价",@"全部订单",@"我的凭证"],@[@"余额",@"优惠劵"]];
    }
    return _titleArray;
}
- (void)setIndexPath:(NSIndexPath *)indexPath setMoney:(NSMutableArray *)moneyArray{
    _logoImageView.image =[UIImage imageNamed:[NSString stringWithFormat:@"Image_%ld%ld",indexPath.section,indexPath.row]];
    _titieL.text = self.titleArray[indexPath.section][indexPath.row];
   
    if (indexPath.section == 2) {
        
      
        self.detailL.hidden = NO;
        _lineView.hidden = NO;
        [_logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(15);
            make.height.width.mas_equalTo(30);
        }];
        [_titieL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_logoImageView.mas_right).offset(5);
            make.top.mas_equalTo(19);
            make.height.mas_equalTo(20);
        }];
        [_detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_logoImageView.mas_right).offset(5);
            make.bottom.mas_equalTo(-19);
            make.height.mas_equalTo(20);
        }];
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.bottom.mas_equalTo(-18);
            make.left.mas_equalTo(self.mas_right).offset(-1);
            make.width.mas_equalTo(1);
        }];
        if (self.indexPath.row == 1) {
            if (moneyArray.count > 0) {
                 _detailL.text = [NSString stringWithFormat:@"%@张",moneyArray[indexPath.row]];
            }
           
            _lineView.hidden = YES;
        }else{
            if (moneyArray.count > 0) {
                _detailL.text = [NSString stringWithFormat:@"%@元",moneyArray[indexPath.row]];
            }
            
        }
        
    }else{
        
        self.detailL.hidden = YES;
        _lineView.hidden = YES;
        [_logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(15);
            make.height.width.mas_equalTo(30);
        }];
        [_titieL mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_logoImageView.mas_bottom).offset(8);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
    }
}
#pragma mark -
#pragma mark - 添加UI控件
- (void)createCellUI{
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc]init];
        [self addSubview:_logoImageView];
    }
    if (_titieL == nil) {
        _titieL = [[UILabel alloc]init];
        _titieL.font = [UIFont systemFontOfSize:13];
        _titieL.backgroundColor = [UIColor clearColor];
        _titieL.textAlignment = NSTextAlignmentCenter;
        _titieL.textColor = [UIColor colorWithHexString:@"000000"];
        [self addSubview:_titieL];
    }
    if (_detailL == nil) {
        _detailL = [[UILabel alloc]init];
        _detailL.font = [UIFont systemFontOfSize:13];
        _detailL.backgroundColor = [UIColor clearColor];
        _detailL.text = @"副标题";
        _detailL.textAlignment = NSTextAlignmentCenter;
        _detailL.textColor = [UIColor colorWithHexString:@"959595"];
        [self addSubview:_detailL];
    }
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"959595"];
        [self addSubview:_lineView];
    }
   
   
}
@end
