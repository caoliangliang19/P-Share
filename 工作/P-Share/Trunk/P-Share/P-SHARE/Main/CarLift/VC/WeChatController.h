//
//  WeChatController.h
//  P-Share
//
//  Created by 亮亮 on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewAddProgress.h"
@interface WeChatController : BaseViewController
@property (nonatomic,strong)Parking *model;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lable1LayOut;
@property (weak, nonatomic) IBOutlet UIButton *twoCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;
@property (weak, nonatomic) IBOutlet ImageViewAddProgress *twoCodeImage;
- (IBAction)twoCodeBtn:(UIButton *)sender;
- (IBAction)backFrom:(UIButton *)sender;
- (void)getWeChat2Dbarcode:(void (^)(WeChatController *weChatVC,BOOL haveImage,NSString *describute))completion;

@end
