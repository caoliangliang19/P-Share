//
//  ORCModel.h
//  P-SHARE
//
//  Created by fay on 16/9/26.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RootObject.h"

@interface ORCModel : RootObject
@property (nonatomic,copy)NSString  *config_str,
                                    *engine_num,//发动机号码
                                    *issue_date,
                                    *model,//品牌车型
                                    *owner,//用户名称
                                    *plate_num,//车牌号
                                    *register_date,//注册时间
                                    *request_id,
                                    *success,
                                    *vehicle_type,
                                    *vin;//车辆识别码
@end
