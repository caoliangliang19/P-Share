//
//  PersonSaveController.m
//  P-SHARE
//
//  Created by 亮亮 on 16/11/14.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PersonSaveController.h"
#import "SaveInfoView.h"

@interface PersonSaveController ()
<   UIActionSheetDelegate,
    UIImagePickerControllerDelegate,//调用相机和相册
    UINavigationControllerDelegate  //调用相机和相册
>

{
    BOOL _fromCamera;
}
@property (nonatomic , strong)SaveInfoView *saveInfo;

@property (nonatomic , assign)BOOL isFirst;

@property (nonatomic , assign)UIImageView *headImageView;

@property (nonatomic , strong)UIImageView *naviImageView;

@end

@implementation PersonSaveController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationUI];
    [self createOtherUI];
}
- (void)createNavigationUI{
    _isFirst = NO;
    self.title = @"个人中心";

    UIBarButtonItem *rightBarItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"editing"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    
    self.navigationItem.rightBarButtonItem = rightBarItem;
}


    
- (void)share:(UIBarButtonItem *)btnItem{
    
    self.saveInfo.pickView.hidden = YES;
    if (_isFirst == NO) {
        btnItem.image = [UIImage imageNamed:@"tick"];
        self.saveInfo.myType = ControllerTypeSave;
        _isFirst = YES;
    }else{
        btnItem.image = [UIImage imageNamed:@"editing"];
        self.saveInfo.myType = ControllerTypeModify;
        _isFirst = NO;
        [self saveInfoNet];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.saveInfo.pickView.hidden = YES;
}
- (void)createOtherUI{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self getCustomerInfo:@"customerHead"]] placeholderImage:[UIImage imageNamed:@"item_Head-portrait_114"]];
    imageView.userInteractionEnabled = YES;
    self.headImageView = imageView;
    imageView.layer.cornerRadius = 45;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
   
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [self.view addSubview:lineView];
    
    SaveInfoView *saveInfo = [[SaveInfoView alloc] init];
    saveInfo.backgroundColor = [UIColor clearColor];
    self.saveInfo = saveInfo;
    saveInfo.myType = ControllerTypeModify;
    [self.view addSubview:saveInfo];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(20);
        make.height.width.mas_equalTo(90);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(180);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    [saveInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(181);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT - 245);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeadImageV)];
    [imageView addGestureRecognizer:tap];
}
- (void)onHeadImageV{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择照片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}
- (void)saveInfoNet{
    NSString  *sex = @"3";
    if ([self.saveInfo.sexBtn.currentTitle isEqualToString:@"男"]) {
        sex = @"1";
    }else if ([self.saveInfo.sexBtn.currentTitle isEqualToString:@"女"]){
        sex = @"2";
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",@"2.0.4",@"version",self.saveInfo.nameTextField.text,@"customerNickname",sex,@"customerSex",self.saveInfo.jobTextField.text,@"customerJob",self.saveInfo.cityBtn.currentTitle,@"customerRegion",self.saveInfo.e_mailTextField.text,@"customerEmail", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(updateCustomerInfo) WithDic:dict needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject[@"data"];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:dict[@"customerNickname"] forKey:@"customerNickname"];
            [userDefault setObject:dict[@"customerJob"] forKey:@"customerJob"];
            [userDefault setObject:dict[@"customerRegion"] forKey:@"customerRegion"];
            [userDefault setObject:dict[@"customerEmail"] forKey:@"customerEmail"];
            [userDefault setObject:dict[@"customerSex"] forKey:@"customerSex"];
            [userDefault setObject:dict[@"customerCardId"] forKey:@"customerCardId"];
      
        [userDefault synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_SUCCESS object:nil];
        
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)getCustomerInfo:(NSString *)customerInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:customerInfo];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhotoByCamera];
            _fromCamera = YES;
            break;
        case 1:
            [self takePhotoByLibrary];
            _fromCamera = NO;
            break;
        default:
            break;
    }
}
- (void)takePhotoByCamera{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void)takePhotoByLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
        UIImage *image = nil;
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //如果是拍照则保存到相册
        if (_fromCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
        //图片剪切
        CGSize imagesize = image.size;
        imagesize.height =400;
        imagesize.width =400;
        //对图片大小进行压缩--
        image = [self imageWithImage:image scaledToSize:imagesize];
        
        //        NSData *imageData = UIImagePNGRepresentation(image);
        //        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        //        [userDefault setObject:imageData forKey:customer_head];
        //        [self.myPicture setImage:image];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        [self updataUserInfoWithPost:imageData];
        
        //通知发送消息，更新侧滑页头像
        //        NSNotification *notification = [[NSNotification alloc]initWithName:@"updataSideMenuHeader" object:nil userInfo:nil];
        //        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}
- (void)updataUserInfoWithPost:(NSData *)imageData
{
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UtilTool getCustomId],@"customerId",@"2.0.4",@"version", nil];
    ////    CUSTOMERMOBILE(customer_id)
    //
    //
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
    
    //@"http://192.168.1.124:9090/share/other/customer/updateCustomerInfo"
    [manager POST:APP_URL(updateImage) parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //第四个参数:@"image/png"
        //第三个参数:随便给一个名字以.png结尾
        //第二个参数:参数名
        //        NSDate *nowData = [NSDate date];
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        //        NSString *imageName = [formatter stringFromDate:nowData];
        
        [formData appendPartWithFileData:imageData name:@"myFiles" fileName:@"" mimeType:@"image/jpeg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            
            
            if ([dict[@"errorNum"] isEqualToString:@"0"])
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *infoDict = dict[@"data"];
                [userDefaults setObject:infoDict[@"customerId"] forKey:@"customerId"];
                
                if ([infoDict[@"customerHead"] length] > 5) {
                    
                    [userDefaults setObject:infoDict[@"customerHead"] forKey:@"customerHead"];
                }
                [userDefaults synchronize];
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[UtilTool getCustomerInfo:@"customerHead"]] placeholderImage:[UIImage imageNamed:@"item_Head-portrait_114"]];
                [[NSNotificationCenter defaultCenter]postNotificationName:LOGIN_SUCCESS object:nil];
                
            }else{
                MyLog(@"头像上传失败");
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"头像上传失败");
        
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (!error) {
        
    }
    else
    {
        
    }
}
- (void)leftBarButtonClick:(UIBarButtonItem *)item
{
    if (_isFirst == YES) {
        [UtilTool creatAlertController:self title:@"提示" describute:@"是否放弃编辑" sureClick:^{
             [self.rt_navigationController popViewControllerAnimated:YES];
        } cancelClick:^{
            
        }];
        return;
    }
    [super leftBarButtonClick:item];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
