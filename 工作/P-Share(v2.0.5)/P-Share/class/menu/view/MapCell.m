//
//  TableViewCell.m
//  P-Share
//
//  Created by fay on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "MapCell.h"

@implementation MapCell

- (void)awakeFromNib {
    // Initialization code
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithKind:(CellKind)kind
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.style = CellStyleUnSelect;
        __weak typeof(self) weakSelf = self;
        self.imgV = [[UIImageView alloc]init];
        self.imgV.image = [UIImage imageNamed:@"sportcar"];
        
        [self addSubview:_imgV];
        if (kind == CellCellKindCarNum) {
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(12);
                make.centerY.mas_equalTo(weakSelf);
                make.width.mas_equalTo(weakSelf).multipliedBy(0.1);
                make.height.mas_equalTo(_imgV.mas_width).multipliedBy(0.714);
            }];
            
            _selectImgV = [[UIImageView alloc]init];

            [self.contentView addSubview:_selectImgV];
            
            [_selectImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-14);
                make.centerY.mas_equalTo(_imgV);
                make.size.mas_equalTo(CGSizeMake(16, 16));
                
            }];

        }else if (kind == CellCellKindParking){
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(12);
                make.centerY.mas_equalTo(weakSelf);
                make.size.mas_equalTo(CGSizeMake(8, 15));
            }];
        }
        
        _infoL = [[UILabel alloc]init];
        _infoL.textColor = [MyUtil colorWithHexString:@"696969"];
        _infoL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_infoL];
        [_infoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgV.mas_right).offset(14);
            make.centerY.mas_equalTo(_imgV);
            make.size.width.mas_equalTo(245);
        }];
        
    }
    return self;
    
}


- (void)setStyle:(CellStyle)style
{
    _style = style;
    switch (_style) {
        case CellStyleSelect:
        {
            
            _selectImgV.image = [UIImage imageNamed:@"selected"];
            
        }
            break;
            
        case CellStyleUnSelect:
        {
            
            _selectImgV.image = [UIImage imageNamed:@"unselect"];
            
        }
            break;
            
        default:
            break;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
