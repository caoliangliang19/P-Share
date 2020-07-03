//
//  selfAlertView.m
//  P-Share
//
//  Created by fay on 16/3/7.
//  Copyright © 2016年 杨继垒. All rights reserved.
//

#import "selfAlertView.h"
#import "MapCell.h"

@interface selfAlertView ()<UITableViewDataSource,UITableViewDelegate>
{
    MapCell *_temCell;
    NSIndexPath *_temIndexPath;
    UITableView *_tableV;
    
}
@end

@implementation selfAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        __weak typeof(self) weakSelf = self;
        UILabel *titleL = [[UILabel alloc]init];
        titleL.textColor = [UIColor blackColor];
        titleL.text = @"选择您的车辆";
        titleL.textAlignment = 1;
        [self addSubview:titleL];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakSelf);
            make.top.mas_equalTo(18);
        }];
        
        
        UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [cancelBtn setImage:[UIImage imageNamed:@"payViewCancel"] forState:(UIControlStateNormal)];
        [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 9, 8 , 8)];

        [cancelBtn addTarget:self action:@selector(removeView) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(32, 32));
            
        }];
        
        UIView *view = [UIView new];
        view.backgroundColor = [MyUtil colorWithHexString:@"e0e0e0"];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleL.mas_bottom);
            make.height.mas_equalTo(1);
            make.right.left.mas_equalTo(1);
        }];
        
        
        
        _temIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        _tableV = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableV.tableFooterView = [[UIView alloc]init];
        
        _tableV.delegate = self;
        _tableV.dataSource = self;
        [self addSubview:_tableV];
        [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(44);
            make.right.left.mas_equalTo(0);
            
        }];
        
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"下一步" forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(nextStep:) forControlEvents:(UIControlEventTouchUpInside)];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn setTitleColor:NEWMAIN_COLOR forState:(UIControlStateNormal)];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_tableV.mas_bottom).offset(0);
            make.right.left.bottom.mas_equalTo(0);
        }];
        
        
        
    }
    
    return self;
}
#pragma mark -
#pragma mark - 车辆列表
- (void)getUserCarArrayWhenCompetion:(void (^)())completion Failure:(void(^)())failure;
{
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
       NSInteger beginIndex = 1;
       _dataArray = [NSMutableArray array];
       NSString *summary = [[NSString stringWithFormat:@"%@%@%@",CUSTOMERMOBILE(customer_id),@"2.0.2",MD5_SECRETKEY] MD5];
       NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",NewCarList,CUSTOMERMOBILE(customer_id),@"2.0.2",summary];
       NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
       RequestModel *model = [RequestModel new];
       
       [model getRequestWithURL:urlString WithDic:nil success:^(NSURLSessionDataTask *task, id responseObject) {
           
           if ([responseObject isKindOfClass:[NSDictionary class]])
           {
               NSDictionary *dict = responseObject;
               
               if ([dict[@"errorNum"] isEqualToString:@"0"])
               {
                   if (beginIndex == 1) {
                       [_dataArray removeAllObjects];
                   }
                   NSArray *infoArrray = dict[@"data"];
                 
                       for (NSDictionary *infoDict in infoArrray){
                           CarModel *model = [[CarModel alloc] init];
                           [model setValuesForKeysWithDictionary:infoDict];
                           [_dataArray addObject:model];
                       }
                       if (completion) {
                           completion();
                       }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_tableV reloadData];

                        });
                       
                  
               }else{
                   
                   if (failure) {
                       failure();
                   }
               }
           }
           
           
       } error:^(NSString *error) {
           if (failure) {
               failure();
           }
       } failure:^(NSString *fail) {
           if (failure) {
               failure();
           }
       }];

   });
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_tableV reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _temIndexPath = indexPath;
    
    [tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];
    if (!cell) {
        cell = [[MapCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"MapCell" WithKind:CellCellKindCarNum];
    }

    if (indexPath.row == _temIndexPath.row) {
        
        cell.style = CellStyleSelect;
    }
    else{
        
        cell.style = CellStyleUnSelect;
    }
    
    
    CarModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.infoL.text = model.carNumber;
    
    
    return cell;
}

- (void)removeView
{

    [UIView animateWithDuration:0.3 animations:^{
        
        self.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
        _grayView.hidden = YES;
        
    }];
    
}

- (void)nextStep:(UIButton *)btn
{
    [self removeView];
    CarModel *model = [_dataArray objectAtIndex:_temIndexPath.row];
    
    if (self.nextStep) {
        self.nextStep(model);
        self.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
        if (self.isHiddenGrayView) {
            _grayView.hidden = YES;
        }
        
        
    }
}

@end
