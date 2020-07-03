//
//  CollectionCell.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/17.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "CollectionCell.h"


@interface CollectionCell ()

@property (nonatomic , strong)UIView *grayView;

@end

@implementation CollectionCell




+ (instancetype)intranceDataCollectionCell:(UITableView *)tableView{
    static NSString *identiffer = @"CollectionCellID";
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identiffer];
    if (cell == nil) {
        cell = [[CollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identiffer];
    }
    return cell;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"ebebeb"];
        self.grayView = bgView;
        [self addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor redColor];
        self.parkImageV = imageView;
        [self addSubview:imageView];
        UILabel *lable = [UtilTool createLabelFrame:CGRectZero title:@"河北省东部" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft numberOfLine:0];
        self.parkNameL = lable;
        [self addSubview:lable];
        UILabel *lable1 = [UtilTool createLabelFrame:CGRectZero title:@"上海市1111" textColor:[UIColor colorWithHexString:@"555555"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft numberOfLine:0];
        self.addressL = lable1;
        [self addSubview:lable1];
        UILabel *lable2 = [UtilTool createLabelFrame:CGRectZero title:@"123.345Km" textColor:[UIColor colorWithHexString:@"555555"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft numberOfLine:0];
        self.distanceL = lable2;
        [self addSubview:lable2];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navigation_b"] forState:UIControlStateNormal];
        [button setTitle:@"导航" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 20, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(25, 0, 0, 15);
        [button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigateL = button;
        [self addSubview:button];
        
    }
    return self;
}
- (void)onClick{
    if (self.ClickBtnClick) {
        self.ClickBtnClick(self.index);
    }
}
- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 106/255.0, 218/255.0, 193/255.0, 1);

    CGContextSetLineWidth(ctx, 5);
    const CGPoint points[] = {CGPointMake(15, 5),CGPointMake(15, 48)};
    CGContextStrokeLineSegments(ctx, points, 2);
    
    [KLINE_COLOR setStroke];
    CGContextFillPath(ctx);
     CGContextSetLineWidth(ctx, 1);
    const CGPoint points1[] = {CGPointMake(SCREEN_WIDTH-55, 10),CGPointMake(SCREEN_WIDTH-55, 43)};
    CGContextStrokeLineSegments(ctx, points1, 2);
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
   
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    [self.parkImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(28);
        make.height.width.mas_equalTo(40);
    }];
    [self.parkNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(self.parkImageV.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-57);
    }];
    [self.addressL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12);
        make.left.mas_equalTo(self.parkImageV.mas_right).offset(10);
        make.height.mas_equalTo(15);
    }];
    [self.navigateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(63);
    }];
    [self.distanceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12);
        make.right.mas_equalTo(self.navigateL.mas_left).offset(-5);
        make.height.mas_equalTo(15);
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
