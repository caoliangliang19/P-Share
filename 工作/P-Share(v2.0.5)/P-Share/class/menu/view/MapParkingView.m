//
//  MapParkingView.m
//  P-Share
//
//  Created by fay on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "MapParkingView.h"
#import "MapCell.h"
#import "ManagerModel.h"
@interface MapParkingView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableV;
}
@end
@implementation MapParkingView

- (void)layoutSubviews
{
    [_tableV reloadData];
    [super layoutSubviews];
    
}

- (instancetype)init{
    if (self == [super init]) {
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
                
        _tableV = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        
        _tableV.tableFooterView = [[UIView alloc] init];
        
        [self addSubview:_tableV];
        [_tableV reloadData];
        
        [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(10);
            make.right.left.mas_equalTo(0);
            
        }];
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"取消" forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn addTarget:self action:@selector(removeView) forControlEvents:(UIControlEventTouchUpInside)];
        
        [btn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_tableV.mas_bottom).offset(0);
            make.right.left.bottom.mas_equalTo(0);
        }];
        
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ParkingModel *parkingModel = [_dataArray objectAtIndex:indexPath.row];
    
    ManagerModel *model1 = [_dataArray objectAtIndex:indexPath.row];
    NewParkingModel *model = [[NewParkingModel alloc]init];
    model.parkingName = model1.searchTitle;
    model.parkingArea = model1.searchDistrict;
    model.parkingLongitude = model1.searchLongitude;
    model.parkingLatitude = model1.searchLatitude;
    if (self.positionParking) {
        
        self.positionParking(model);
        self.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
        _grayView.hidden = YES;
        
    }
//    MapCell *cell = (MapCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.style = CellStyleSelect;
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];
    if (!cell) {
        cell = [[MapCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MapCell" WithKind:CellCellKindParking];
        
    }
   
//    ParkingModel *model = _dataArray[indexPath.row];
    ManagerModel *model = _dataArray[indexPath.row];
    
    cell.imgV.image = [UIImage imageNamed:@"location_collection"];
    
    
    cell.infoL.text = model.searchTitle;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}

- (void)removeView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
        _grayView.hidden = YES;
        
    }];
    
   
}


@end
