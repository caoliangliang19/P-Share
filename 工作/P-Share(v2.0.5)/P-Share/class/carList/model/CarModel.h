//
//  CarModel.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/29.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CarModel : MAAnnotationView

@property (nonatomic,copy,setter=setCarNumber:) NSString *carNumber;
@property (nonatomic,copy,setter=setCarBrand:) NSString *carBrand;
@property (nonatomic,copy) NSString *carId;

@end
