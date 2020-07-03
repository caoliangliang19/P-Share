//
//  CarLifeView.h
//  P-Share
//
//  Created by fay on 16/7/22.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarLiftModel;
typedef enum {
    PositionStyleBottom,
    PositionStyleCenter,
    PositionStyleTop
    
}PositionStyle;
@interface CarLifeView : UIView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (nonatomic,copy)  void (^changeCarLiftPosition)(CarLifeView *carLiftView,BOOL direction);
@property (weak, nonatomic) IBOutlet UIView *headBgV;
@property (nonatomic,assign)PositionStyle positionStyle;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic,copy)void (^backClick)(CarLifeView *carLiftView);
@property (nonatomic,strong)Parking *parkModel;
@property (nonatomic,copy)void(^jumpBlock)();
@property (nonatomic,copy)void(^carLifeBlock)(NSInteger i,NSMutableArray *array,Parking *);
/**
 *  MapBottomViews的一个子View 赋值给carLiftView  便于更新carLiftView的坐标
 */
@property (nonatomic,strong)UIView *showView;
@property (nonatomic,strong)UIView *bgView;


@property (nonatomic,copy)void (^showActivityDetail)(CarLiftModel *model);

@property (weak, nonatomic) IBOutlet UITextField *distanceT;

@property (nonatomic,strong)Car *carModel;
- (void)hubShow;
- (void)hubHiden;

- (IBAction)parkingList:(id)sender;

+ (CarLifeView *)instaceCarLifeView;

@end
