//
//  UserCenterCell.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/11.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "UserCenterCell.h"


@interface UserCenterCell ()

@property (nonatomic , strong)NSMutableArray *titleTextA;

@end

@implementation UserCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSMutableArray *)titleTextA{
    if (_titleTextA == nil) {
        _titleTextA = [[NSMutableArray alloc] initWithObjects:@[@"游客"],@[@"我的收藏",@"我的订单",@"车辆管理",@"停车纪录"],@[@"我的钱包",@"推荐有礼"],@[@"设置"], nil];
    }
    return _titleTextA;
}
+(instancetype)installCellTableView:(UITableView *)tanleView{
    static NSString *identifier = @"message";
    UserCenterCell *cell = [tanleView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *leftImageV = [[UIImageView alloc] init];
        self.leftImageV = leftImageV;
        [self addSubview:leftImageV];
        
        UIImageView *rightImageV = [[UIImageView alloc] init];
        self.rightImageV = rightImageV;
        [self addSubview:rightImageV];
        
        UILabel *mainL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"000000"]  font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentRight numberOfLine:1];
        self.mainL = mainL;
        [self addSubview:mainL];
        
        UILabel *subL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor darkGrayColor]  font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentRight numberOfLine:1];
        self.subL = subL;
        [self addSubview:subL];
        
        UILabel *rightL = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"333333"]  font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight numberOfLine:1];
        self.rightL = rightL;
        [self addSubview:rightL];
        
        
    }
    return self;
}
- (void)setStyleCellIndexPath:(NSIndexPath *)indexPath{
    //头像Cell  普通Cell  钱包Cell
    self.leftImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"set%ld%ld",indexPath.section,indexPath.row]];
    self.mainL.text = self.titleTextA[indexPath.section][indexPath.row];
    self.rightImageV.image = [UIImage imageNamed:@"listRight"];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [UtilTool isVisitor];
        GroupManage *manage = [GroupManage shareGroupManages];
        if (manage.isVisitor == YES) {
           self.mainL.text = self.titleTextA[indexPath.section][indexPath.row];
            self.subL.text = @"登录帐号:";
        }else{
            self.mainL.text = [self getCustomerInfo:@"customerNickname"];
            self.subL.text = [NSString stringWithFormat:@"登录帐号:%@", [self getCustomerInfo:@"customerMobile"]];
        }
        [self.leftImageV sd_setImageWithURL:[NSURL URLWithString:[UtilTool getCustomerInfo:@"customerHead"]] placeholderImage:[UIImage imageNamed:@"item_Head-portrait_114"]];
       
       
        self.subL.hidden = NO;
        self.rightL.hidden = YES;
        [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(42);
        }];
        [self.mainL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftImageV.mas_right).offset(10);
            make.top.mas_equalTo(13);
        }];
        
        
    }else if (indexPath.section == 2 && indexPath.row == 0){
        self.subL.hidden = YES;
        self.rightL.hidden = NO;
        [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(17);
        }];
        [self.mainL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self.leftImageV.mas_right).offset(10);
        }];
        self.rightL.text = @"优惠劵、凭证";
        
    }else{
        self.subL.hidden = YES;
        self.rightL.hidden = YES;
        [self.leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(17);
        }];
        [self.mainL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self.leftImageV.mas_right).offset(10);
        }];
    }
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageV.mas_right).offset(10);
        make.bottom.mas_equalTo(-13);
    }];
    [self.rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(9);
    }];
    [self.rightL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self.rightImageV.mas_left).offset(-10);
    }];
}

- (NSString *)getCustomerInfo:(NSString *)customerInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:customerInfo];
}
@end
