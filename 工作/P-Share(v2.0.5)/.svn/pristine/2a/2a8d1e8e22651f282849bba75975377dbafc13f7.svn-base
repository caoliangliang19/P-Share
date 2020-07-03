//
//  CarDetailAlert.h
//  P-Share
//
//  Created by 亮亮 on 16/4/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewParkingModel.h"
#import "CarModel.h"
typedef enum {
    RULETYPEONE,//规则1 代泊价格描述不现实
    RULETYPETWO
    
}RULETYPE;

@protocol CarDetailAlertDelegate <NSObject>

- (void)dataPickerView:(NSString *)startTime hourString:(NSString *)endTime miunteString:(NSString *)carNum;


@end

@interface CarDetailAlert : UIView
@property (nonatomic,strong)NewCarModel *carModel;
@property (weak, nonatomic) IBOutlet UILabel *parkName;

@property (nonatomic,assign)RULETYPE ruleType;
@property (weak, nonatomic) IBOutlet UILabel *CarNum;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopLayout1;

@property (nonatomic,copy)NSString *startTime;
@property (nonatomic,copy)NSString *endTime;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopLayout2;
@property (weak, nonatomic) IBOutlet UILabel *detailPrice;
@property (nonatomic,assign)id<CarDetailAlertDelegate>delegate;
@property (nonatomic,retain)ParkingModel *parkingModel;
@property (weak, nonatomic) IBOutlet UILabel *infoL;

@property (weak, nonatomic) IBOutlet UILabel *todayTimeL;
@property (weak, nonatomic) IBOutlet UILabel *getCarTimeL;
@property (weak, nonatomic) IBOutlet UILabel *planManeyL;

- (IBAction)tureBtn:(UIButton *)sender;
- (IBAction)hideBtn:(UIButton *)sender;
- (instancetype)initWithInfo:(NSString *)info;
- (void)hide;
- (void)show;
@end
