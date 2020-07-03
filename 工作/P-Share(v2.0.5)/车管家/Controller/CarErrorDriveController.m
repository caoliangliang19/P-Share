//
//  CarErrorDriveController.m
//  P-Share
//
//  Created by 亮亮 on 16/1/14.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "CarErrorDriveController.h"
#import "ChoiceCarViewController.h"
#import "AddRentCell.h"
#import "ParkingModel.h"
#import "CarErrorTableController.h"
#import "RequestModel.h"
#import "CityModel.h"
#import "provinceModel.h"
#import "RegulationsModel.h"
//聚合数据KEY
#define JUHEKEY  @"909110fd7305195902079f9e48057e42"


@interface CarErrorDriveController ()<UIPickerViewDelegate,UIPickerViewDataSource,SelectedCar,UITextFieldDelegate>
{
    
    UIAlertView *_alert;
  
    CityModel *_city;
   NSString *_selectedProvince;
    NSString *_selectCity;
    NSString *_selectArea;
    NSInteger _selectProvinceIndex;
   
    NSArray *_dataArray;

    NSString *_cityCode;
    NewCarModel *_selectCarModel;
    ParkingModel *_selectParkingModel;
    NSString *_selectCar;
    
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;

}
@property (nonatomic,strong)NSDictionary *areaDic;

@property (nonatomic,copy)NSString *fadongjiNumber;
@property (nonatomic,copy)NSString *carjiaNumber;



@property (nonatomic,strong)NSMutableArray *provinceArray;
@property (nonatomic,strong)NSMutableArray *cityArray;
@end

@implementation CarErrorDriveController

- (void)viewDidLoad {
    [super viewDidLoad];
    ALLOC_MBPROGRESSHUD;
    BEGIN_MBPROGRESSHUD;
    [self setDefaultUI];
    [self loadPickerViewData];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(SCREEN_WIDTH - 61,  10, 60, 60);
    [btn setBackgroundImage:[UIImage imageNamed:@"customerservice"] forState:(UIControlStateNormal)];
    [btn addTarget: self action:@selector(ChatVC) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:btn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)ChatVC
{
    
    CHATBTNCLICK
    
}
- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - 更新UI
- (void)setDefaultUI
{
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    
    self.textField1.delegate = self;
    self.textField2.delegate = self;
    self.placePickerView.delegate = self;
    self.placePickerView.dataSource = self;
    self.placePickerView.hidden = YES;
}



#pragma mark - 给UIPickerView填充数据
- (void)loadPickerViewData{
    [RequestModel requestPickViewDataWithCompletion:^(NSArray *arr) {
      
        END_MBPROGRESSHUD;
        _dataArray = arr;
        [_placePickerView reloadAllComponents];
        
    }];
}
#pragma mark - 车牌号码代理
- (void)selectedCarWithCarModel:(NewCarModel *)model
{
    _selectCarModel = model;
    self.telePhone.text = model.carNumber;
    self.telePhone.textColor = [UIColor blackColor];
    
}

#pragma mark- Picker Data Source 代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return _dataArray.count;
    }
    else
    {
        NSInteger seletNum = [_placePickerView selectedRowInComponent:0];
        provinceModel *province = [_dataArray objectAtIndex:seletNum];
        return province.cityArrays.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        provinceModel *province = [_dataArray objectAtIndex:row];
        _selectedProvince = province.province;
        return province.province;
        
    }
    else
    {
        NSInteger seletNum = [_placePickerView selectedRowInComponent:0];
        provinceModel *province = [_dataArray objectAtIndex:seletNum];
        
        if (row >=province.cityArrays.count) {
            return nil;
        }
       
        CityModel *city = [province.cityArrays objectAtIndex:row];
        _selectedProvince = province.province;
        _selectCity = city.city_name;
        _cityCode = city.city_code;
        _city = city;
        
       
        
        return city.city_name;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [_placePickerView reloadComponent:1];
//        [_placePickerView selectRow:0 inComponent:1 animated:YES];
        
        provinceModel *province = [_dataArray objectAtIndex:row];
        CityModel *city = [province.cityArrays objectAtIndex:0];
        _selectedProvince = province.province;
        _selectCity = city.city_name;
        _cityCode = city.city_code;
        _city = city;
        

    }
    
    else
    {
        NSInteger seletNum = [_placePickerView selectedRowInComponent:0];
        provinceModel *province = [_dataArray objectAtIndex:seletNum];
        
        if (row >=province.cityArrays.count) {
            return ;
        }

        CityModel *city = [province.cityArrays objectAtIndex:row];
        _selectedProvince = province.province;
        _selectCity = city.city_name;
        _cityCode = city.city_code;
        _city = city;
        
    }
    self.carErrorPlace.text = [NSString stringWithFormat:@"%@ %@",_selectedProvince,_selectCity];
    self.carErrorPlace.textColor = [UIColor blackColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 拿到省市地区
- (IBAction)firstButton:(id)sender {
    
    self.placePickerView.hidden = NO;
    if (_dataArray.count > 0) {
        provinceModel *province = [_dataArray objectAtIndex:0];
        CityModel *city = [province.cityArrays objectAtIndex:0];
        _selectedProvince = province.province;
        _selectCity = city.city_name;
        self.carErrorPlace.text = [NSString stringWithFormat:@"%@ %@",_selectedProvince,_selectCity];
        self.carErrorPlace.textColor = [UIColor blackColor];

    }
    
    [self.view endEditing:YES];
    
}
#pragma mark - 拿到车牌号
- (IBAction)secondButton:(id)sender {
    [self.view endEditing:YES];
    self.placePickerView.hidden = YES;
    ChoiceCarViewController *choiceCarCtrl = [[ChoiceCarViewController alloc] init];
    choiceCarCtrl.delegate = self;
    [self.navigationController pushViewController:choiceCarCtrl animated:YES];
}
#pragma mark - 点击调用接口 成功后进入违章查询列表页面
- (IBAction)lastBlueButton:(id)sender {
    
    if ([self.carErrorPlace.text isEqualToString:@""]) {
        ALERT_VIEW(@"查询城市不能为空");
        _alert = nil;
        return;
    }
    
    if ([self.telePhone.text isEqualToString:@"请选择车牌"]) {
        ALERT_VIEW(@"请填写车辆车牌号");
        _alert = nil;
        return;
    }
    
    if ([_city.engine isEqualToString:@"1"] && [self.textField1.text isEqualToString:@""]) {
        if ([_city.engineno isEqualToString:@"0"]) {
            ALERT_VIEW(@"请输入全部发动机号");
            _alert = nil;
        }else
        {
            NSString *alertStr = [NSString stringWithFormat:@"请输入发动机后%@位",_city.engineno];
            ALERT_VIEW(alertStr);
            _alert = nil;
            
        }
        return;
    }
    
    if ([_city.classa isEqualToString:@"1"] && [self.textField2.text isEqualToString:@""]) {
        if ([_city.classno isEqualToString:@"0"]) {
            ALERT_VIEW(@"请输入全部车架号");
            _alert = nil;
        }else
        {
            NSString *alertStr = [NSString stringWithFormat:@"请输入车架号后%@位",_city.classno];
            ALERT_VIEW(alertStr);
            _alert = nil;
            
        }
        return;
    }
    
    

    BEGIN_MBPROGRESSHUD
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_cityCode,@"city", self.telePhone.text,@"hphm",@"909110fd7305195902079f9e48057e42",@"key",self.textField1.text,@"engineno",self.textField2.text,@"classno",nil];
    [RequestModel requestRegulationsWithURL:dic Completion:^(RegulationResultModel *model) {
        
        CarErrorTableController *addview = [[CarErrorTableController alloc]init];
        model.place = _selectCity;
        
        addview.resultModel = model;
        
        
        [self.navigationController pushViewController:addview animated:YES];
        
        END_MBPROGRESSHUD
        
    } Error:^(NSString *errorStr) {
        
        ALERT_VIEW(errorStr);
        _alert = nil;
        END_MBPROGRESSHUD
    } Fail:^(NSString *error) {
        ALERT_VIEW(error);
        _alert = nil;
        END_MBPROGRESSHUD
        
    }];
    

}
#pragma mark - 返回上一页
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 触摸键盘下去
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.placePickerView.hidden = YES;
}
#pragma mark - 返回键键盘下去
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    return YES;
}
@end
