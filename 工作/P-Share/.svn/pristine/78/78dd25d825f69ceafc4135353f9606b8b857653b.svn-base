//
//  WeChatController.m
//  P-Share
//
//  Created by 亮亮 on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "WeChatController.h"

@interface WeChatController ()
{
    MBProgressHUD *_hud;
    UIAlertView *_alert;
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    NSString *_imagePath;
    
}
@property (nonatomic,copy)NSDictionary *dataDic;

@end

@implementation WeChatController

- (void)viewDidLoad {
    self.title = @"微信社群";
    self.automaticallyAdjustsScrollViewInsets = YES;
    _twoCodeBtn.userInteractionEnabled = NO;
    _twoCodeBtn.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [super viewDidLoad];

    
    [self createUI];
}
- (void)createUI{
    
    _twoCodeBtn.userInteractionEnabled = YES;
    _twoCodeBtn.backgroundColor = KMAIN_COLOR;
    _imagePath = _dataDic[@"qrcodeUrl"];
    [_twoCodeImage sd_setImageWithURL:[NSURL URLWithString:_imagePath] placeholderImage:[UIImage imageNamed:@"carMaster.jpg"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (expectedSize > 0) {
            _twoCodeImage.loadProgerss = (CGFloat)receivedSize/expectedSize;
        }
        
        MyLog(@"receivedSize  %ld, expectedSize:%ld ",receivedSize,expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _twoCodeImage.image = image;
        
    }];

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

- (void)getWeChat2Dbarcode:(void (^)(WeChatController *weChatVC,BOOL haveImage,NSString *describute))completion;
{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:KCARLIFT_PARKINGID],@"parkingId",@"2.0.2",@"version", nil];
    
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(getCarlovQRCode) WithDic:mutableDic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        _dataDic = (NSDictionary *)responseObject;
        if (completion) {
            completion(self,YES,nil);
        }

       
    } error:^(NSString *error) {
        if (completion) {
            completion(self,NO,error);
        }

    } failure:^(NSString *fail) {
        if (completion) {
            completion(self,NO,fail);
        }
    }];
    
}

- (IBAction)twoCodeBtn:(UIButton *)sender {
    if ([UtilTool isBlankString:_imagePath] == YES) {
//        ALERT_VIEW(@"未请求到图片");
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
        [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"保存成功"];
//        MBPROGRESS_TITLE(@"保存成功");
       
    }else{
//      MBPROGRESS_TITLE(@"保存失败");
        [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"保存失败"];

    }
}
@end
