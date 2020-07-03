//
//  TimeLineYuYueCell.h
//  P-SHARE
//
//  Created by fay on 16/10/25.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "TimeLineBaseCell.h"
typedef enum {
    TimeLineYuYueCellStyleLineOne = 0,
    TimeLineYuYueCellStyleLineTwo,
}TimeLineYuYueCellStyle;
@interface TimeLineYuYueCell : TimeLineBaseCell
@property (nonatomic,assign)TimeLineYuYueCellStyle yuYueCellStyle;

@end
