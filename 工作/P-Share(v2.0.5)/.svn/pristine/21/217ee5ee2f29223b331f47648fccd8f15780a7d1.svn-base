//
//  walletPayView.m
//  P-Share
//
//  Created by fay on 16/3/24.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "walletPayView.h"
#import "QGPassWordTextField.h"


@implementation walletPayView

- (void)awakeFromNib{
    [_miMaT removeFromSuperview];
    [self loadMimaLabel];
    
}

- (void)loadMimaLabel
{
    [_mimaLabel removeFromSuperview];
    
    _mimaLabel = [[QGPassWordTextField alloc]init];
    
    _mimaLabel.passWordCount = 6;
    
    [self.mimaView addSubview:_mimaLabel];
    
    __weak typeof(self)weakSelf = self;
    [_mimaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.mimaView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(240);
    }];

}

- (void)drawRect:(CGRect)rect
{
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
}


@end
