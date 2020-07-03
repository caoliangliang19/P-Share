//
//  InvoiceView.h
//  P-Share
//
//  Created by 亮亮 on 16/4/11.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^cancleView)();
typedef void (^tureView)(NSString *,NSString *,NSString *);
@interface InvoiceView : UIView
@property (nonatomic ,copy)cancleView cancleBlock;
@property (nonatomic,copy)tureView tureBlock;
+(instancetype)shareInstance;



@property (nonatomic,copy)NSString *sendType;
@property (weak, nonatomic) IBOutlet UITextField *invHeadField;
@property (weak, nonatomic) IBOutlet UITextField *invAddressField;
@property (weak, nonatomic) IBOutlet UILabel *textLable;

@property (weak, nonatomic) IBOutlet UIView *selfTake;
@property (weak, nonatomic) IBOutlet UIImageView *selfTakeImage;

@property (weak, nonatomic) IBOutlet UIView *otherSend;
@property (weak, nonatomic) IBOutlet UIImageView *otherSendImage;
@property (weak, nonatomic) IBOutlet UIButton *surebtn;

- (IBAction)cancleBtn:(UIButton *)sender;

- (IBAction)tureBtn:(UIButton *)sender;

- (void)animatedIn;

- (void)animatedOut;
@end
