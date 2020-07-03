//
//  temParkingPayResultVC.m
//  P-Share
//
//  Created by fay on 16/2/16.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "temParkingPayResultVC.h"

@interface temParkingPayResultVC ()

@end

@implementation temParkingPayResultVC

- (void)awakeFromNib{
    
    
    
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self.view removeFromSuperview];
    
}
- (void)setTemModel:(TemParkingListModel *)temModel{
    MyLog(@"%@",self.carNumber);
    self.titlePriceL.text = [NSString stringWithFormat:@"%@%@",temModel.amountPayable,@"元"];
    self.payTimeL.text = temModel.endDate;
    self.payMoneyL.text =[NSString stringWithFormat:@"%@%@",temModel.amountPaid,@"元"];
    self.orderIDL.text = temModel.orderId;
    
    //得到当前的时间
    NSDate * date = [NSDate date];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    //设置时间间隔（秒）（这个我是计算出来的，不知道有没有简便的方法 )
    NSTimeInterval time =  15 * 60;//一年的秒数
    //得到一年之前的当前时间（-：表示向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））
    NSDate * time1 = [date dateByAddingTimeInterval:0];
    NSString * startTime = [dateFormatter stringFromDate:time1];
    
    
    NSDate * time2 = [date dateByAddingTimeInterval:time];
    
    //转化为字符串
    NSString * lastTime = [dateFormatter stringFromDate:time2];
    
    _startTimeL.text = startTime;
    _endTimeL.text = lastTime;

//    self.startTimeL.text = temModel.beginDate;
//    self.endTimeL.text = temModel.endDate;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
     self.carNumL.text = self.carNumber;
    self.payKindL.text = self.payState;
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
