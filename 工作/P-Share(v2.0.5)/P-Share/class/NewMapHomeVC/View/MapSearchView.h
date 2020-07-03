//
//  MapSearchView.h
//  P-Share
//
//  Created by fay on 16/6/13.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapSearchView : UIView
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)UIButton *headBtn;
@property (nonatomic,copy)void (^goToUserCenter)();
@property (nonatomic,copy)void (^gotoSearchVC)();
@end
