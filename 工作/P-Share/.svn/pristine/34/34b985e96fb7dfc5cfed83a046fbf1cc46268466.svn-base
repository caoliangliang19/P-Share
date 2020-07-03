//
//  YuYueTaoCanCell.m
//  P-Share
//
//  Created by fay on 16/5/20.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "YuYueTaoCanCell.h"
#import "YuYueTimeModel.h"
#define Margin      10

@interface YuYueTaoCanCell()

@property (nonatomic,strong)UIImageView *checkImage;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UILabel *label3;
@property (nonatomic,strong)UIImageView *image1;
@property (nonatomic,strong)UIImageView *image2;
@property (nonatomic,strong)UIImageView *image3;


@end

@implementation YuYueTaoCanCell
{
    NSMutableArray *_viewsArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
        
    }
    
    return self;
    
}

- (void)setUpView
{
    if (!_viewsArray) {
        _viewsArray = [NSMutableArray array];
    }
    UIImageView *checkImage = [UIImageView new];
    checkImage.image = [UIImage imageNamed:@"unselect"];
    _checkImage = checkImage;

    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    
    CGFloat textFont;
    if (SCREEN_WIDTH<=320) {
        textFont = 12;
    
    }else
    {
        textFont = 13;
    }
    
    UILabel *label1 = [self createTaoCanLabelWithTitle:@"" withFont:textFont];
    UILabel *label2 = [self createTaoCanLabelWithTitle:@"" withFont:textFont];
    UILabel *label3 = [self createTaoCanLabelWithTitle:@"" withFont:textFont];
    label1.textAlignment = 1;
    label2.textAlignment = 1;
    label3.textAlignment = 1;
    _label1 = label1;
    _label2 = label2;
    _label3 = label3;
    
    UILabel *priceLabel = [UILabel new];
    _priceLabel = priceLabel;
    _priceLabel.font = [UIFont systemFontOfSize:textFont];
    _priceLabel.text = @"";
    UIImageView *image1 =[UIImageView  new];
    UIImageView *image3 =[UIImageView  new];
    UIImageView *image2 =[UIImageView  new];
    _image1 = image1;
    _image2 = image2;
    _image3 = image3;
    
    image1.image = [UIImage imageNamed:@"plus_preferential"];
    image3.image = [UIImage imageNamed:@"equal_preferential"];
    
    
    [_viewsArray addObject:label1];
    [_viewsArray addObject:label2];
    [_viewsArray addObject:priceLabel];
    
    [self.contentView addSubview:line];
    [self.contentView addSubview:_checkImage];
    [self.contentView addSubview:label1];
    [self.contentView addSubview:label2];
    [self.contentView addSubview:image1];
    [self.contentView addSubview:image3];
    [self.contentView addSubview:priceLabel];
    
    WS(weakSelf)
    
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(20);
        make.right.mas_equalTo(weakSelf).offset(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(weakSelf).offset(-0.5);

    }];
    
    [_checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).mas_equalTo(15);
        make.centerY.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
     
}

- (void)setModel:(YuYueTimeModel *)model
{
    _model = model;
    NSMutableArray *dayArray = (NSMutableArray *)[model.week componentsSeparatedByString:@","];
    
    for (int i=0;i<dayArray.count;i++) {
        NSString *temStr = dayArray[i];
        NSString *newStr = [self getLastTag:temStr];
        [dayArray replaceObjectAtIndex:i withObject:newStr];
    }
    
    if (dayArray.count == 2) {
        self.style = YuYueTaoCanCellStyleOne;
        _label1.text = [NSString stringWithFormat:@" %@  ",dayArray[0]];
        _label2.text = [NSString stringWithFormat:@" %@  ",dayArray[1]];
    }else if(dayArray.count == 3)
    {
        self.style = YuYueTaoCanCellStyleTwo;
        _label1.text = [NSString stringWithFormat:@" %@  ",dayArray[0]];
        _label2.text = [NSString stringWithFormat:@" %@  ",dayArray[1]];
        _label3.text = [NSString stringWithFormat:@" %@  ",dayArray[2]];
    }
    _priceLabel.text = [NSString stringWithFormat:@"%@元",model.price];

    self.selectStyle = YuYueTaoCanCellSelectStyleUnSelect;
}

- (NSString *)getLastTag:(NSString *)str
{
    
    if ([str isEqualToString:@"周六"]||[str isEqualToString:@"周日"]) {
        return [NSString stringWithFormat:@"%@(全天)",str];
    }else
    {
        return [NSString stringWithFormat:@"%@(当晚)",str];
    }
    
}

- (UILabel *)createTaoCanLabelWithTitle:(NSString *)title withFont:(CGFloat)font
{
    UILabel *temLabel = [UILabel new];
    temLabel.text = @"周五(晚)";
//    temLabel.text = title;
    temLabel.textAlignment = 1;
    temLabel.font = [UIFont systemFontOfSize:font];
    temLabel.layer.borderWidth = 1;
    temLabel.layer.cornerRadius = 10;
    temLabel.layer.masksToBounds = YES;
    return temLabel;
    
}

- (void)setStyle:(YuYueTaoCanCellStyle)style
{
    _style = style;
    CGFloat space;
    if (SCREEN_WIDTH<=320) {
        space = 1;
    }else
    {
        space = 3;
    }
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_checkImage.mas_trailing).mas_equalTo(Margin);
        make.centerY.mas_equalTo(_checkImage);
        make.height.mas_equalTo(24);
//        make.width.mas_equalTo(80);
        
    }];
    
    [_image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_label1.mas_trailing).mas_offset(space);
        make.centerY.mas_equalTo(_label1);
        make.size.mas_equalTo(CGSizeMake(16, 16));

    }];
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_image1.mas_trailing).mas_offset(space);
        make.centerY.mas_equalTo(_label1);
        make.height.mas_equalTo(24);
//        make.width.mas_equalTo(80);
    }];
    
    
    if (style == YuYueTaoCanCellStyleOne) {
        
//        两个
        _label3.hidden = YES;
        _image2.hidden = YES;
        
        [_image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_label2.mas_trailing).mas_offset(space);
            make.centerY.mas_equalTo(_label1);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_image3.mas_trailing).mas_offset(space);
            make.centerY.mas_equalTo(_label1);
            make.width.mas_lessThanOrEqualTo(100);
        }];

        
    }else if (style == YuYueTaoCanCellStyleTwo){
        
//       三个
        _label3.hidden = NO;
        _image2.hidden = NO;
        _label3.text = @"12323";
        _image2.image = [UIImage imageNamed:@"plus_preferential"];

        
        [_viewsArray addObject:_label3];
        [self.contentView addSubview:_image2];
        [self.contentView addSubview:_label3];
        
        [_image2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_label2.mas_trailing).mas_offset(space);
            make.centerY.mas_equalTo(_label1);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_image2.mas_right).mas_equalTo(space);
            make.centerY.mas_equalTo(_label1);
            make.height.mas_equalTo(24);
//            make.width.mas_equalTo(80);
        }];
        
        [_image3 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_label3.mas_trailing).mas_offset(space);
            make.centerY.mas_equalTo(_label1);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_image3.mas_trailing).mas_offset(space);
            make.centerY.mas_equalTo(_label1);
            make.width.mas_lessThanOrEqualTo(100);
        }];

    }
    [self layoutIfNeeded];
}
- (void)setSelectStyle:(YuYueTaoCanCellSelectStyle)selectStyle
{
    _selectStyle = selectStyle;

    if (selectStyle == YuYueTaoCanCellSelectStyleUnSelect) {
        
        for (UILabel *label in _viewsArray) {
            label.textColor = [UIColor colorWithHexString:@"aaaaaa"];
            label.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
        }
        _checkImage.image = [UIImage imageNamed:@"unselect"];

    }else if (selectStyle == YuYueTaoCanCellSelectStyleSelected){
        for (UILabel *label in _viewsArray) {
            label.textColor = [UIColor colorWithHexString:@"696969"];
            label.layer.borderColor = KMAIN_COLOR.CGColor;
        }
        _checkImage.image = [UIImage imageNamed:@"selected"];

    }
    
}
@end
