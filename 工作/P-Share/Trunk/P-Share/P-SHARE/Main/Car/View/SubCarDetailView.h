//
//  SubCarDetailView.h
//  P-Share
//
//  Created by fay on 16/8/1.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCarDetailView : UIView
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSDictionary   *dataDic;

@property (nonatomic,copy)void(^NextVC)(SubCarDetailView *subView,NSString *tradeName,NSString *carSeries,NSDictionary *dataDic);

- (void)animationShow;
- (void)animationHidden;

@end
