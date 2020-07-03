//
//  WeChatController.m
//  P-Share
//
//  Created by 亮亮 on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "WeChatController.h"
#import "ParkingModel.h"

@interface WeChatController ()
{
    MBProgressHUD *_hud;
    UIAlertView *_alert;
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    NSString *_imagePath;
    
}
@end

@implementation WeChatController

- (void)viewDidLoad {
    ALLOC_MBPROGRESSHUD
    _twoCodeBtn.userInteractionEnabled = NO;
    _twoCodeBtn.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
    
    [super viewDidLoad];
    _model = [DataSource shareInstance].model;
    [self getWeChat2Dbarcode];
    [self createUI];
}
- (void)createUI{
    if (SCREEN_WIDTH < 375) {
        self.lable1LayOut.constant = 90;
    }else{
        self.lable1LayOut.constant = 99;
    }
    [self becomeCircular:self.lable1];
    [self becomeCircular:self.lable2];
    [self becomeCircular:self.lable3];
    self.twoCodeBtn.layer.cornerRadius = 5;
    self.twoCodeBtn.clipsToBounds = YES;
    self.twoCodeImage.image = [UIImage imageNamed:@"carMaster.jpg"];
}
- (void)becomeCircular:(UIView *)view{
    view.layer.cornerRadius = 12;
    view.clipsToBounds = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getWeChat2Dbarcode
{
    BEGIN_MBPROGRESSHUD
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_model.parkingId,@"parkingId",@"2.0.2",@"version", nil];
    
    [RequestModel requestPostInvoiceInfoWithURL:getCarlovQRCode WithDic:mutableDic Completion:^(NSDictionary *dic) {
        
        END_MBPROGRESSHUD
        _twoCodeBtn.userInteractionEnabled = YES;
        _twoCodeBtn.backgroundColor = NEWMAIN_COLOR;
        _imagePath = dic[@"qrcodeUrl"];
        [_twoCodeImage sd_setImageWithURL:[NSURL URLWithString:_imagePath] placeholderImage:[UIImage imageNamed:@"carMaster.jpg"]];
        
        
    } Fail:^(NSString *errror) {
        END_MBPROGRESSHUD
        ALERT_VIEW(errror);
        _alert = nil;
        
        
    }];
    
     
    
}

- (IBAction)twoCodeBtn:(UIButton *)sender {
    if ([MyUtil isBlankString:_imagePath] == YES) {
        ALERT_VIEW(@"未请求到图片");
    }else{
    UIImageWriteToSavedPhotosAlbum(self.twoCodeImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (IBAction)backFrom:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if(!error){
        MBPROGRESS_TITLE(@"保存成功");
       
    }else{
      MBPROGRESS_TITLE(@"保存失败");
    }
}
@end
