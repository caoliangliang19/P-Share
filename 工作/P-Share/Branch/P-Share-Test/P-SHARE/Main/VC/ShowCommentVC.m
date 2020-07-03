//
//  ShowCommentVC.m
//  P-Share
//
//  Created by fay on 16/6/28.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "ShowCommentVC.h"
#import "StartView.h"
#import "TagView.h"
#import "TagModel.h"
@interface ShowCommentVC ()
{
    UIView          *_headView;
    StartView       *_startView;
    UIView          *_bottomView;
    TagView         *_tagView;
    UILabel         *_headTopLabel;
    UILabel         *_headBottomLabel;
    StartView       *_startViewTop;
    StartView       *_startViewBottom;
    UILabel         *_bottomLabel;
}
@end

@implementation ShowCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    
}
- (void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_model.orderId,@"orderId",_model.orderType,@"orderType",@"2.0.1",@"version", nil];
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(queryByOrderId) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        OrderModel *model = [OrderModel shareObjectWithDic:responseObject[@"data"]];
        [self setDataWithModel:model];
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
//    [RequestModel requestDaiBoOrder:queryByOrderId WithType:@"getCar" WithDic:dic Completion:^(NSArray *dataArray) {
//       
//        TemParkingListModel *aModel = [dataArray objectAtIndex:0];
//        [self setDataWithModel:aModel];
//       
//        MyLog(@"%@",aModel);
//        
//    } Fail:^(NSString *error) {
//        
//    }];
    
}

- (void)setDataWithModel:(OrderModel *)model
{
    NSString *tag = [NSString stringWithFormat:@"%@=%@=%@",model.totalityTag,model.carManagerTag,model.businessTag];
    NSArray *tagArray = [tag componentsSeparatedByString:@"="];
    if ([_model.orderType intValue] == 17 || [_model.orderType intValue] == 12) {//洗车、代泊订单有两行星星
        self.style = ShowCommentVCStyleTwo;
        _startViewTop.lightStartNum = [model.totalityStar intValue];//设置亮星星数量
        _startViewTop.showStyle = StartViewShowStyleShow;
        _startViewBottom.lightStartNum = [model.businessStar intValue]>0 ? [model.businessStar intValue]:[model.carManagerStar intValue];
        _startViewBottom.showStyle = StartViewShowStyleShow;

        
    }else{
        self.style  =ShowCommentVCStyleOne;
        
        _startView.lightStartNum = [model.totalityStar intValue];//设置亮星星数量
        _startView.showStyle = StartViewShowStyleShow;

        
    }
    NSMutableArray *aTagArray = [NSMutableArray array];
    [tagArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        if (str.length > 0) {
            NSString *info = [str substringToIndex:str.length-1];
            NSString *num = [str substringWithRange:NSMakeRange(str.length-1, 1)];
            TagModel *tagModel = [[TagModel alloc] init];
            tagModel.info = info;
            tagModel.isZan = [num intValue] == 1 ? YES : NO;
            [aTagArray addObject:tagModel];
        }
    }];
    _bottomLabel.text = model.commentContent;
    _tagView.dataArray = aTagArray;
    
}


- (void)loadUI
{
    self.title = @"查看评价";
    [self loadHeadView];
    [self loadBottomView];
    
}
- (void)setStyle:(ShowCommentVCStyle)style
{
    _style = style;
    [self loadUI];
    
}
- (void)loadHeadView
{
    UIView *headView = [UIView new];
    _headView = headView;
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    if (_style == ShowCommentVCStyleOne) {
        [self setHeadViewStyleOne];
    }else
    {
        [self setHeadViewStyleTwo];
    }
}
- (void)setHeadViewStyleOne
{
    UILabel *topLabel = [UILabel new];
    topLabel.text = @"总体评价";
    topLabel.font = [UIFont systemFontOfSize:17];
    topLabel.textColor = [UIColor colorWithHexString:@"333333"];
    topLabel.textAlignment = 1;
    [_headView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headView.mas_top).offset(24);
        make.centerX.mas_equalTo(_headView);
    }];
    
    _startView = [[StartView alloc] init];
    _startView.style = StartViewStyleBig;
    
    [_headView addSubview:_startView];
    [_startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_headView);
        make.top.mas_equalTo(topLabel.mas_bottom).offset(24);
        make.width.mas_equalTo(_startView.startWidth * 5 + _startView.startspace * 4);
        make.height.mas_equalTo(_startView.startWidth);
    }];
    [_headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_startView.mas_bottom).offset(24);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [_headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(_headView.mas_bottom);
    }];
    

}
- (void)loadBottomView
{
    UIView *bottomView = [UIView new];
    _bottomView = bottomView;
    [self.view addSubview:bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headView.mas_bottom).offset(0);
        make.leading.trailing.mas_equalTo(0);
//        make.height.mas_equalTo(150);
        
    }];
    [self loadTagView];
    [self loadBottomL];
    
    
}
- (void)loadTagView
{
    TagView *tagView = [TagView new];
    tagView.style = TagViewStyleShow;
    _tagView = tagView;
    [_bottomView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(0);
        make.height.mas_equalTo(120);
        
    }];
    [tagView layoutIfNeeded];
    
    
}
- (void)loadBottomL
{
    
    UILabel *label = [UtilTool createLabelFrame:CGRectZero title:@"" textColor:[UIColor colorWithHexString:@"696969"] font:[UIFont systemFontOfSize:14] textAlignment:0 numberOfLine:0];
    _bottomLabel = label;
    label.numberOfLines = 0;
    [_bottomView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        if (_tagView) {
            make.top.mas_equalTo(_tagView.mas_bottom).offset(14);
        }else
        {
            make.top.mas_equalTo(14);
        }
    }];
    
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(label.mas_bottom);
    }];
    
}
- (void)setHeadViewStyleTwo
{
    UILabel *headTopLabel = [UtilTool createLabelFrame:CGRectZero title:@"总体评价" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:17] textAlignment:0 numberOfLine:1];
    _headTopLabel = headTopLabel;
    UILabel *headBottomLabel = [UtilTool createLabelFrame:CGRectZero title:@"车管家" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:17] textAlignment:0 numberOfLine:1];
    _headBottomLabel = headBottomLabel;
    [_headView addSubview:headTopLabel];
    [_headView addSubview:headBottomLabel];
    
    StartView *startViewTop = [[StartView alloc] init];
    _startViewTop = startViewTop;
    startViewTop.style = StartViewStyleSmall;
//    startViewTop.lightStartNum = 2;
    
    StartView *startViewBottom = [[StartView alloc] init];
    _startViewBottom = startViewBottom;
//    startViewBottom.lightStartNum = 4;
    startViewBottom.style = StartViewStyleSmall;
    [_headView addSubview:startViewTop];
    [_headView addSubview:startViewBottom];
//    [_headView sd_addSubviews:@[startViewTop,startViewBottom]];
    
    [headTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.left.mas_equalTo(14);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    [headBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headTopLabel.mas_bottom).offset(24);
        make.left.mas_equalTo(headTopLabel.mas_left);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    [startViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headTopLabel.mas_centerY);
        make.left.mas_equalTo(headTopLabel.mas_right).offset(24);
        make.width.mas_equalTo(startViewTop.startWidth * 5 + startViewTop.startspace * 4);
        make.height.mas_equalTo(startViewTop.startWidth);
    }];
    [startViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headBottomLabel.mas_centerY);
        make.left.mas_equalTo(startViewTop.mas_left);
        make.width.mas_equalTo(startViewTop.mas_width);
        make.height.mas_equalTo(startViewTop.mas_height);
    }];
    [_headView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(startViewBottom.mas_bottom).offset(24);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    [_headView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(_headView.mas_bottom);
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
