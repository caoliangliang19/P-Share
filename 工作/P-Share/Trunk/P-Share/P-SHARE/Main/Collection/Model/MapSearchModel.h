//
//  MapSearchModel.h
//  P-SHARE
//
//  Created by fay on 16/9/6.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "RootObject.h"

@interface MapSearchModel : RootObject
@property (nonatomic,copy)NSString      *customerId,
                                        *searchDistrict,
                                        *searchLatitude,
                                        *searchLongitude,
                                        *searchTitle;
@property (nonatomic,assign)BOOL        isCollection;
@end
