//
//  AddCarInfoViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/7.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "AddCarInfoViewController.h"
#import "DriveImageView.h"
#import "NewCarListVC.h"
#import "DatePickView.h"
#import "CustomAlertView.h"

@interface AddCarInfoViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    
    MBProgressHUD *_hud;
    UIView *_keyView;
    
    NSInteger _selectIndex;
    
    UIScrollView *_scrollView;
    
    
    UIAlertView *_alert;
    BOOL _select;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
    NSString *_driveTime1;
    
    
    NSMutableArray *_buttonArray;
    
    NSInteger _IsAutoPay;
    
    BOOL _fromCamera;
    
    NSString *_tradeName;
    NSString *_carBrand;
    NSString *_carSeries;
    NSString *_displacement;
    NSString *_styleYear;
    NSString *_intakeType;
   
    
    
}
@property (nonatomic,copy)NSString *lastNumLable;
@property (nonatomic,copy)NSString *lastNumLable1;

@property (nonatomic,copy)NSString *NumLable1;
@property (nonatomic,copy)NSString *NumLable2;
@property (nonatomic,copy)NSString *NumLable3;
@property (nonatomic,copy)NSString *NumLable4;
@property (nonatomic,copy)NSString *NumLable5;



@end

@implementation AddCarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createScrollView];
    [self setUI];
    [self createMyKeyBoard];
    [self createShuzhiBoard];
    ALLOC_MBPROGRESSHUD;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    
    
}
- (void)createScrollView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.carScrollView.delegate = self;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.carScrollView addGestureRecognizer:recognizer];
    _select = NO;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 250);
    [self.view addSubview:_scrollView];
}
- (void)touchScrollView
{
    [self hideKeyBoard];
    if (self.carScrollView.contentOffset.y == 380) {
//        [self hightLayout:0];
        self.carScrollView.contentOffset = CGPointMake(0, 700-(SCREEN_HEIGHT-64));
    }
    [self.view endEditing:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCarType:) name:@"CarSubKindVCChoseCarType" object:nil];
   
    
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)getCarType:(NSNotification *)notifitation
{
    NSDictionary *dict = notifitation.userInfo;
    _carBrand = dict[@"carBrand"];
    _tradeName = dict[@"tradeName"];
    _carSeries = dict[@"carSeries"];
    _displacement = dict[@"displacement"];;
    _styleYear = dict[@"styleYear"];
    _intakeType = dict[@"intakeType"];
    NSString *styleYear =[NSString stringWithFormat:@"%@年产",dict[@"styleYear"]];
    NSString *displacementShow = dict[@"displacementShow"];
    if ([MyUtil isBlankString:_carSeries] == YES) {
        _carSeries = @"";
    }
    if ([MyUtil isBlankString:displacementShow] == YES) {
        displacementShow = @"";
        _displacement = @"";
        _intakeType = @"";
    }
    if ([MyUtil isBlankString:_styleYear] == YES) {
        styleYear = @"";
    }
    NSString *typeBtn = [NSString stringWithFormat:@"%@ %@ %@ %@",dict[@"carBrand"],_carSeries,displacementShow,styleYear];
     [_carTypeBtn setTitle:typeBtn forState:(UIControlStateNormal)];
   
   
   
   //NSString *cccc = [cut substringToIndex:[cut length] - 1];
}
#pragma mark - 
#pragma mark - 更新画面
- (void)setUI
{
   
    self.kiloTextField.delegate = self;
    self.enginTextField.delegate = self;
    self.carFrameTextField.delegate = self;
    [self createLableText];
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = NEWMAIN_COLOR;
    
    self.sureBtn.backgroundColor = NEWMAIN_COLOR;
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.layer.masksToBounds = YES;
    //监听键盘变化,
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledBeginChanged:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEndChanged:) name:UITextFieldTextDidEndEditingNotification object:nil];
    _buttonArray = [NSMutableArray array];
    //从更多页面进入 model有值的情况
    if (self.model) {
        [self addCarNumber:self.model.carNumber];
        self.kiloTextField.text = self.model.travlledDistance;
        if ([MyUtil isBlankString:self.model.carUseDate] == YES) {
            [self.driveTime setTitle:@"请选择您爱车的上路时间" forState:(UIControlStateNormal)];
            _driveTime1 = self.model.carUseDate;
        }else{
             [self.driveTime setTitle:self.model.carUseDate forState:(UIControlStateNormal)];
             _driveTime1 = self.model.carUseDate;
        }
        self.carFrameTextField.text = self.model.frameNum;
        self.enginTextField.text = self.model.engineNum;
        if ([MyUtil isBlankString:self.model.carModel[@"carBrand"]] == NO) {
            NSDictionary *dict = self.model.carModel;
             NSString *styleYear = [NSString stringWithFormat:@"%@年产",dict[@"styleYear"]];
            if ([MyUtil isBlankString:dict[@"styleYear"]] == YES) {
                  styleYear = @"";
            }
            
            NSString *typeBtn = [NSString stringWithFormat:@"%@ %@ %@ %@",dict[@"carBrand"],dict[@"carSeries"],dict[@"displacementShow"],styleYear];
            //有车型的时候不能修改  当无车型的时候可以修改
            if ([MyUtil isBlankString:dict[@"carBrand"]] == YES) {
                 _carTypeBtn.userInteractionEnabled = YES;
            }else{
                 _carTypeBtn.userInteractionEnabled = NO;
            }
            [_carTypeBtn setTitle:typeBtn forState:(UIControlStateNormal)];
          
            _carBrand = dict[@"carBrand"];
            _tradeName = dict[@"tradeName"];
            _carSeries = dict[@"carSeries"];
            _displacement = dict[@"displacement"];
            _styleYear = dict[@"styleYear"];
            _intakeType = dict[@"intakeType"];
        }
        if ([self.model.carIsAutoPay integerValue] == 1) {
            [self.isPayMoney setTitle:@"已开启钱包自动支付" forState:UIControlStateNormal];
            [self.isPayMoney setTitleColor:[MyUtil colorWithHexString:@"39D5B8"] forState:UIControlStateNormal];
            self.paySwitch.on = YES;
            _IsAutoPay = 1;
           
        }else
        {
            [self.isPayMoney setTitle:@"未开启钱包自动支付" forState:UIControlStateNormal];
            [self.isPayMoney setTitleColor:[MyUtil colorWithHexString:@"A7A7A7"] forState:UIControlStateNormal];
             self.paySwitch.on = NO;
            _IsAutoPay = 0;
            
        }
        
    }else{
        //从添加页面进入  model无值的情况
        _IsAutoPay = 0;
        _selectIndex = 100;
        [self showKeyView:100];
        UILabel *pwdLable = [self.view viewWithTag:_selectIndex];
        pwdLable.layer.borderColor = NEWMAIN_COLOR.CGColor;
         pwdLable.layer.borderWidth = 1;
        _carTypeBtn.userInteractionEnabled = YES;
    }
   
    
}
- (void)addCarNumber:(NSString *)carNumber;{
    for (NSInteger i = 0; i < carNumber.length; i++) {
        NSString *subStr = [carNumber substringWithRange:NSMakeRange(i, 1)];
        UILabel *pwdLable = [self.view viewWithTag:100+i];
        pwdLable.text = subStr;
    }
}

#pragma mark -
#pragma mark - 键盘 改变通知 弹键盘
-(void)textFiledBeginChanged:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[UITextField class]]) {
        UITextField *textField = notification.object;
        
        if (textField == self.carFrameTextField) {
        
            [self hideKeyBoard];
           self.carScrollView.contentOffset = CGPointMake(0, 380);
        }else if (textField == self.enginTextField){
         
            [self hideKeyBoard];
             self.carScrollView.contentOffset = CGPointMake(0, 380);
        }else if (textField == self.kiloTextField){
             [self hideKeyBoard];
        }
       
    }
    
}
-(void)textFiledEndChanged:(NSNotification *)notification
{
      if ([notification.object isKindOfClass:[UITextField class]]) {
        UITextField *textField = notification.object;
        if (textField == self.carFrameTextField) {
            
          

            self.carScrollView.contentOffset = CGPointMake(0, 700-(SCREEN_HEIGHT-64));
            
        }else if (textField == self.enginTextField){
           

            self.carScrollView.contentOffset = CGPointMake(0, 700-(SCREEN_HEIGHT-64));
           
        }
        
    }
    
}
#pragma mark - 
#pragma mark - createLable输入框
- (void)createLableText{
    for (int i = 0; i < 7; i++) {
        UILabel *pwdLabel = [[UILabel alloc] init ];
        if(i == 0||i == 1){
            pwdLabel.frame = CGRectMake(20+i*30, 10, 30, 30);
        }else{
            pwdLabel.frame = CGRectMake(40+i*30, 10, 30, 30);
        }
        pwdLabel.layer.borderColor = [MyUtil colorWithHexString:@"ebebeb"].CGColor;
        pwdLabel.userInteractionEnabled = YES;
        pwdLabel.textAlignment = NSTextAlignmentCenter;//居中
        pwdLabel.tag = 100+i;
        pwdLabel.layer.borderWidth = 1;
        [self.carNumView addSubview:pwdLabel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClack:)];
        [pwdLabel addGestureRecognizer:tap];
    }
    UIView *blueView = [[UIView alloc]initWithFrame:CGRectMake(80+5, 20, 10, 10)];
    blueView.backgroundColor = NEWMAIN_COLOR;
    blueView.layer.cornerRadius = 5;
    blueView.clipsToBounds = YES;
    [self.carNumView addSubview:blueView];
    
}
#pragma mark - 
#pragma mark - lableText点击事件
- (void)onClack:(UIGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    _keyView.hidden = NO;
    _selectIndex = gesture.view.tag;
    for (int i = 0; i < 7; i++) {
        UILabel *pwdLable = [self.view viewWithTag:100+i];
        
        
        if (gesture.view.tag == pwdLable.tag) {
            pwdLable.layer.borderColor = NEWMAIN_COLOR.CGColor;
            pwdLable.layer.borderWidth = 1;
            
            if (pwdLable.tag == 101) {
                MyLog(@"pwdLable.tag == 101");
            }else
            {
                MyLog(@"pwdLable.tag != 101");

            }
            
        }else{
            pwdLable.layer.borderColor = [MyUtil colorWithHexString:@"ebebeb"].CGColor;
            pwdLable.layer.borderWidth = 1;
        }
    }
    MyLog(@"%lf",_scrollView.frame.origin.y);
   
        if (gesture.view.tag == 100) {
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }else{
            [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        
        }
    [self showKeyView:gesture.view.tag];
   
    
}
- (void)showKeyView:(NSInteger)tag{
    [UIView animateWithDuration:0.3 animations:^{
            _scrollView.frame = CGRectMake(0, SCREEN_HEIGHT-250, SCREEN_WIDTH, 250);
        } completion:^(BOOL finished) {
            
        }];
  
}

#pragma mark -
#pragma mark - 自定义车牌号键盘
- (void)createMyKeyBoard
{
    
    CGFloat widthBtn = (SCREEN_WIDTH - 4 - 36)/10;
    CGFloat hightBtn = (250 - 90)/4;
    
    
     UIView  *keyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    keyView.backgroundColor = COLOR_WITH_RGB(212, 212, 212);
    [_scrollView addSubview:keyView];
    
    NSArray *titleArray =@[@[@"沪",@"京",@"渝",@"津",@"豫",@"湘",@"赣",@"苏",@"浙",@"陕"],@[@"晋",@"鲁",@"皖",@"琼",@"甘",@"辽",@"黑",@"冀",@"吉",@"鄂"],@[@"闽",@"滇",@"川",@"桂",@"粤",@"青",@"宁",@"港"],@[@"蒙",@"藏",@"新",@"贵",@"澳",@"台"]];
   
    
    for (NSInteger i = 0; i < 4; i++) {
        NSArray *array = titleArray[i];
        for (NSInteger j = 0; j < array.count ; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:titleArray[i][j] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            if (i == 0 || i == 1) {
                button.frame = CGRectMake(2+(widthBtn+4)*j, 15+(hightBtn+20)*i, widthBtn, hightBtn);
            }else if (i == 2){
                button.frame = CGRectMake(2+4+widthBtn+(widthBtn+4)*j,15+(hightBtn+20)*i, widthBtn, hightBtn);
            }else if (i == 3){
                button.frame = CGRectMake(10+2*widthBtn+(widthBtn+4)*j, 15+(hightBtn+20)*i, widthBtn, hightBtn);
            }
            [button addTarget:self action:@selector(onKeyBoardBtnClock:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonArray addObject:button];
            
            [keyView addSubview:button];
        }
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH-hightBtn-2, 250-hightBtn-15, hightBtn, hightBtn);
   
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [keyView addSubview:button];
    
}
- (void)createShuzhiBoard{
    CGFloat widthBtn = (SCREEN_WIDTH - 4 - 36)/10;
    CGFloat hightBtn = (250 - 90)/4;
    
    _keyView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 250)];
    _keyView.backgroundColor = COLOR_WITH_RGB(212, 212, 212);
    [_scrollView addSubview:_keyView];
     NSArray *numArray =@[@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"],@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"],@[@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S"],@[@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    for (NSInteger i = 0; i < 4; i++) {
        NSArray *array = numArray[i];
        for (NSInteger j = 0; j < array.count; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:numArray[i][j] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (i == 0 || i == 1) {
                button.frame = CGRectMake(2+(widthBtn+4)*j,15+(hightBtn+20)*i, widthBtn, hightBtn);
            }else if (i == 2){
                button.frame = CGRectMake(2+widthBtn/2+(widthBtn+4)*j,15+(hightBtn+20)*i, widthBtn, hightBtn);
            }else if (i == 3){
                button.frame = CGRectMake(6+widthBtn/2+widthBtn+(widthBtn+4)*j, 15+(hightBtn+20)*i, widthBtn, hightBtn);
            }
            
            if ([button.currentTitle isEqualToString:@"I"] || [button.currentTitle isEqualToString:@"O"]) {
                button.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
                button.userInteractionEnabled = NO;
            }
            
            [button addTarget:self action:@selector(onKeyBoardBtnClock:) forControlEvents:UIControlEventTouchUpInside];
            
            [_keyView addSubview:button];
        }
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH-hightBtn-2, 250-hightBtn-15, hightBtn, hightBtn);
   
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [_keyView addSubview:button];
}
- (void)deleteClick{
    if (_selectIndex == 99) {
        _selectIndex = 100;
    }
    
    
    UILabel *lable = [self.view viewWithTag:_selectIndex];
    if (lable.text.length == 0) {
        _selectIndex--;
        _select = NO;
        if (_selectIndex == 99) {
            _selectIndex = 100;
        }
        for (int i = 0; i < 7; i++) {
            UILabel *allLable = [self.view viewWithTag:100+i];
            if (allLable.tag == _selectIndex) {
                
                allLable.layer.borderColor = NEWMAIN_COLOR.CGColor;
                allLable.layer.borderWidth = 1;
                allLable.text = @"";
                if (allLable.tag == 100) {
                    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }else{
                    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
                }
            }else{
                allLable.layer.borderColor = [MyUtil colorWithHexString:@"ebebeb"].CGColor;
                allLable.layer.borderWidth = 1;
            }
            
        }
    }else{
        
        for (int i = 0; i < 7; i++) {
            UILabel *allLable = [self.view viewWithTag:100+i];
            if (allLable.tag == _selectIndex) {
                
                allLable.layer.borderColor = NEWMAIN_COLOR.CGColor;
                allLable.layer.borderWidth = 1;
                allLable.text = @"";
                if (allLable.tag == 100) {
                    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }else{
                    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
                }
            }else{
                allLable.layer.borderColor = [MyUtil colorWithHexString:@"ebebeb"].CGColor;
                allLable.layer.borderWidth = 1;
            }
            
        }
        _select = YES;
        _selectIndex--;
    }
    
    if (_selectIndex == 100) {
        _selectIndex = 100;
    }
}
- (void)onKeyBoardBtnClock:(UIButton *)button{
    if (_select == YES) {
        _selectIndex = _selectIndex+1;
        }
    _select = NO;
    UILabel *allLable1 = [self.view viewWithTag:_selectIndex];
   allLable1.text = button.currentTitle;
    if (allLable1.text.length == 0) {
        
        for (int i = 0; i < 7; i++) {
            UILabel *allLable = [self.view viewWithTag:100+i];
            if (allLable.tag == _selectIndex) {
                allLable.layer.borderColor = NEWMAIN_COLOR.CGColor;
                allLable.layer.borderWidth = 1;
                if (allLable.tag == 100) {
                    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }else{
                    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
                }
                
            }else{
                allLable.layer.borderColor = [MyUtil colorWithHexString:@"ebebeb"].CGColor;
                allLable.layer.borderWidth = 1;
            }
            
            
        }
        _selectIndex ++;
    }else{
        for (int i = 0; i < 7; i++) {
            UILabel *allLable = [self.view viewWithTag:100+i];
            if (allLable.tag == _selectIndex+1) {
              
                allLable.layer.borderColor = NEWMAIN_COLOR.CGColor;
                allLable.layer.borderWidth = 1;
                if (allLable.tag == 100) {
                    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                }else{
                    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
                }
                
            }else{
                allLable.layer.borderColor = [MyUtil colorWithHexString:@"ebebeb"].CGColor;
                allLable.layer.borderWidth = 1;
            }
            
            
        }
        _selectIndex ++;
    }
   
    
    if (_selectIndex == 99) {
        _selectIndex = 100;
    }
    if (_selectIndex == 107) {
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.allObjects[0];
    if ([touch.view isKindOfClass:[UILabel class]]) {
        return;
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _scrollView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)hideKeyBoard{
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    } completion:^(BOOL finished) {
        UILabel *pwdLable = [self.view viewWithTag:_selectIndex];
        pwdLable.layer.borderColor = [MyUtil colorWithHexString:@"ebebeb"].CGColor;
        pwdLable.layer.borderWidth = 1;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
#pragma mark - 点击拍照
- (IBAction)photoBtn:(UIButton *)sender;{
    _fromCamera = YES;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
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
    
}
//图片剪切
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
#pragma mark -
#pragma mark - 设置上路时间
- (IBAction)driveTime:(UIButton *)sender {
    [self hideKeyBoard];
    [self.view endEditing:YES];

    DatePickView *yearMonth = [[DatePickView alloc] init];
    [yearMonth show];
    yearMonth.myBlock = ^(NSString *year,NSString *month){
        _driveTime1 = [NSString stringWithFormat:@"%@-%.2ld",year,(long)[month integerValue]];
        [self.driveTime setTitle:_driveTime1 forState:UIControlStateNormal];
    };
}
#pragma mark -
#pragma mark - 驾驶证照片
- (IBAction)drivePhoto:(UIButton *)sender {
    [self hideKeyBoard];
    [self.view endEditing:YES];
    DriveImageView *driveImage = [[DriveImageView alloc]initWithController:self];
    [driveImage show];
    
}
#pragma mark -
#pragma mark - 点击自动支付
- (IBAction)moneyBaoPay:(UISwitch *)sender {
    [self.view endEditing:YES];
    [self hideKeyBoard];
    if (sender.isOn == YES) {
        CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:CGRectMake(0, 0, 200, 200) titleName:@"自动支付协议"];
        [alertView myTitleText:@"1.钱包安全自动支付功能用来支付已开通口袋停线上支付车场的停车费用2.当您的车辆离场时,系统会自动从钱包余额中自动支付本次停车费用,无需其它任何操作3.未开通口袋停线上支付的车场不支持此项功能4.本功能只在钱包的余额大于等于当次待支付费用时生效,当余额不足时,请线下付费或手动进行线上停车缴费功能5.自动支付成功后,对应车牌的车辆将被自动放行6.口袋停在法律规定范围内，对钱包安全自动支付功能涉及的各方面情况拥有解释权" Block:^{
         sender.on = 1;
         _IsAutoPay = 1;
        [self.isPayMoney setTitle:@"已开启钱包自动支付" forState:UIControlStateNormal];
        [self.isPayMoney setTitleColor:[MyUtil colorWithHexString:@"39D5B8"] forState:UIControlStateNormal];
        [alertView dismissAlertView];
        
    } canBlock:^{
        [self.isPayMoney setTitle:@"未开启钱包自动支付" forState:UIControlStateNormal];
        [self.isPayMoney setTitleColor:[MyUtil colorWithHexString:@"A7A7A7"] forState:UIControlStateNormal];
        sender.on = 0;
        _IsAutoPay = 0;
        [alertView dismissAlertView];
    }];
    
    alertView.backgroundColor = [UIColor whiteColor];
    [alertView showAlertView];
    }else{
        [self.isPayMoney setTitle:@"未开启钱包自动支付" forState:UIControlStateNormal];
        [self.isPayMoney setTitleColor:[MyUtil colorWithHexString:@"A7A7A7"] forState:UIControlStateNormal];
         _IsAutoPay = 0;
    }

}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - textField代理方法

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if (textField == self.kiloTextField) {
    
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 7) {
            return NO;
            
        }
        return [self validateNumber:string];
}
  
    return YES;
}
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark -
#pragma mark - 点击确定绑定车辆
- (IBAction)sureBtnClick:(id)sender {
    
    for (NSInteger i = 0; i < 7; i++) {
        UILabel *lable = [self.view viewWithTag:100+i];
        if (i == 0) {
            self.lastNumLable = lable.text;
        }else if(i == 1){
            self.lastNumLable1 =[NSString stringWithFormat:@"%@",lable.text];
        }else if(i == 2){
            self.NumLable1 = [NSString stringWithFormat:@"%@",lable.text];
        }else if(i == 3){
            self.NumLable2  = [NSString stringWithFormat:@"%@",lable.text];
        }else if(i == 4){
            self.NumLable3  = [NSString stringWithFormat:@"%@",lable.text];
        }else if(i == 5){
            self.NumLable4  = [NSString stringWithFormat:@"%@",lable.text];
        }else if(i == 6){
            self.NumLable5  = [NSString stringWithFormat:@"%@",lable.text];
        }
    }
    NSString *carAddress = [NSString stringWithFormat:@"%@%@",self.lastNumLable,self.lastNumLable1];
    NSString *carNum = [NSString stringWithFormat:@"%@%@%@%@%@",self.NumLable1,self.NumLable2,self.NumLable3,self.NumLable4,self.NumLable5];
    if (carAddress.length != 2) {
        ALERT_VIEW(@"请选择车牌归属地,如“沪A”");
        _alert = nil;
    }else if (carNum.length != 5){
        ALERT_VIEW(@"请填写车辆车牌号");
        _alert = nil;
    }else {
        
       
       
        NSString *carId = self.model.carId;
        NSString *carNumber = [NSString stringWithFormat:@"%@%@",carAddress,carNum];
//        NSString *carType = nil;
//        if ([self.carTypeBtn.currentTitle isEqualToString:@"请选择车型(选填)"]) {
//            carType = nil;
//        }else{
//            carType = self.carTypeBtn.currentTitle;
//        }
       
        NSString *tradeName = _tradeName;
        NSString *carBrand = _carBrand;
        NSString *carSeries = _carSeries;
        NSString *displacement = _displacement;
        NSString *styleYear = _styleYear;
        NSString *intakeType = _intakeType;
        NSString *travlledDistance = self.kiloTextField.text;
        NSString *carUseDate = _driveTime1;
        NSString *frameNum = self.carFrameTextField.text;
        NSString *engineNum = self.enginTextField.text;
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:20];
        [paramDic setObject:[MyUtil getCustomId] forKey:@"customerId"];
        if ([MyUtil isBlankString:carId] == NO) {
            [paramDic setObject:carId forKey:@"carId"];
        }
        if ([MyUtil isBlankString:carNumber] == NO) {
            [paramDic setObject:carNumber forKey:@"carNumber"];
        }
        if ([MyUtil isBlankString:tradeName] == NO) {
             [paramDic setObject:tradeName forKey:@"tradeName"];
        }
        if ([MyUtil isBlankString:carBrand] == NO) {
             [paramDic setObject:carBrand forKey:@"carBrand"];
        }
        if ([MyUtil isBlankString:carSeries] == NO) {
             [paramDic setObject:carSeries forKey:@"carSeries"];
        }
        if ([MyUtil isBlankString:displacement] == NO) {
             [paramDic setObject:displacement forKey:@"displacement"];
        }
        if ([MyUtil isBlankString:styleYear] == NO) {
              [paramDic setObject:styleYear forKey:@"styleYear"];
        }
        if ([MyUtil isBlankString:travlledDistance] == NO) {
             [paramDic setObject:travlledDistance forKey:@"travlledDistance"];
        }
        if ([MyUtil isBlankString:intakeType] == NO) {
            [paramDic setObject:intakeType forKey:@"intakeType"];
        }
        if ([MyUtil isBlankString:carUseDate] == NO) {
            [paramDic setObject:carUseDate forKey:@"carUseDate"];
        }
        
         [paramDic setObject:[NSString stringWithFormat:@"%ld",(long)_IsAutoPay] forKey:@"isAutoPay"];
        
        if ([MyUtil isBlankString:frameNum] == NO) {
            if ([MyUtil isCarFrameNumber:frameNum] == NO) {
                ALERT_VIEW(@"请输入正确车架号");
                _alert = nil;
                return;
            }else{
              [paramDic setObject:frameNum forKey:@"frameNum"];
            }
        }
        if ([MyUtil isBlankString:engineNum] == NO) {
            [paramDic setObject:engineNum forKey:@"engineNum"];
        }
        
        [paramDic setObject:[MyUtil getTimeStamp] forKey:@"timestamp"];
        
         BEGIN_MBPROGRESSHUD;
        [RequestModel requestGetPhoneNumNewWithURL:addCheLiang WithDic:paramDic Completion:^(NSDictionary *dict) {
            
            if ([dict[@"errorNum"] isEqualToString:@"0"]) {

                if (self.model) {
                        ALERT_VIEW(@"修改成功")
                        _alert = nil;
                  
                }else{

                    ALERT_VIEW(@"添加成功")
                    _alert = nil;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserCarChange" object:nil userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                ALERT_VIEW(dict[@"errorInfo"]);
                _alert = nil;
            }
            
            END_MBPROGRESSHUD
            
        } Fail:^(NSString *error) {
            END_MBPROGRESSHUD;
            ALERT_VIEW(error);
            _alert = nil;
            
        }];
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    } completion:^(BOOL finished) {
        
    }];
}


- (IBAction)carTypeBtn:(id)sender {
    NewCarListVC *userCtrl = [[NewCarListVC alloc] init];
    [self.navigationController pushViewController:userCtrl animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    if(scrollView == self.carScrollView){
        if (scrollView.contentOffset.y<=700-(SCREEN_HEIGHT-64)) {
            [self.carFrameTextField resignFirstResponder];
            [self.enginTextField resignFirstResponder];
        }
    }
}
@end








