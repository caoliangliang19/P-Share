//
//  CommentVC.m
//  P-Share
//
//  Created by fay on 16/6/27.
//  Copyright © 2016年 曹亮亮. All rights reserved.
//

#import "CommentVC.h"
#import "StartView.h"
#import "TagView.h"
#import "TagModel.h"
#import "CommentModel.h"
NSString *const  placeHoldString = @"您的建议很重要,来点评下吧(100字以内)";
@interface CommentVC ()<UITextViewDelegate,UIScrollViewDelegate>
{
    StartView       *_startView;
    UIView          *_containView;
    UIView          *_headView;
    UIScrollView    *_scrollView;
    UIView          *_centerView;
    UIView          *_bottomView;
    UITextView      *_textView;
    UILabel         *_centerL;
//    样式二
    UILabel         *_headTopLabel;
    UILabel         *_headBottomLabel;
    StartView       *_startViewTop;
    StartView       *_startViewBottom;
    
    UIAlertView     *_alert;
}

@property (nonatomic,strong)TagView         *tagView;
@property (nonatomic,strong)CommentModel    *commentModel;
@property (nonatomic,strong)CommentModel    *commentPeopleModel;
@property (nonatomic,strong)NSDictionary    *orderTypeDic;

//总体评价和商家评价：    10专享临停，11临停缴费，12代泊，13月租，14产权，15加油卡,16钱包,
//总体评价和车管家评价：   17洗车
//总体评价：
@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _orderTypeDic = [NSDictionary dictionaryWithObjectsAndKeys:@"xiChe",@"17",@"chanQuan",@"14",@"yueZu",@"13",@"youHuiTingChe",@"10",@"linTingJiaoFei",@"11",@"daiBo",@"12",@"addOil",@"15", nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.rt_disableInteractivePop = YES;
    
    
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    if ([model.orderType intValue] == 17 || [model.orderType intValue] == 12) {
//        洗车订单  、 代泊订单
        self.style = CommentVCStyleTwo;
        
    }else
    {
        self.style = CommentVCStyleOne;
    }
    
   
    
}

- (void)leftBarButtonClick:(UIBarButtonItem *)item
{
    [UtilTool creatAlertController:self title:@"提示" describute:@"返回将丢失编辑内容,是否返回?" sureClick:^{
           [self.rt_navigationController popViewControllerAnimated:YES];
    } cancelClick:^{
        
    }];

}



- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CommentTags" ofType:@"plist"];
        NSDictionary *dataDic = [[NSDictionary alloc] initWithContentsOfFile:path];
       
        CommentModel *model = [CommentModel shareCommentModelWithDic:dataDic[_orderTypeDic[_model.orderType]][@"totalComment"]];
        _commentModel = model;
        CommentModel *aModel = [CommentModel shareCommentModelWithDic:dataDic[_orderTypeDic[_model.orderType]][@"CarMasterComment"]];
        _commentPeopleModel = aModel;
       
        
    });
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
  
    

    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];

        if (_style == CommentVCStyleOne) {
            [_scrollView setContentOffset:CGPointMake(0, 216) animated:YES];
        }else if (_style == CommentVCStyleTwo) {
            [_scrollView setContentOffset:CGPointMake(0, 300) animated:YES];
        }
        
    }];
    
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
   

    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutSubviews];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textView resignFirstResponder];
}
- (void)loadUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单评价";
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    _scrollView = scrollView;
    _scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    UIView *containView = [UIView new];
    _containView = containView;
    containView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:containView];
    [containView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    [self layoutHeadView];

    [self layoutCenterView];
    
    [self loadBottomView];
    
    [self loadData];

    
}
- (void)setStyle:(CommentVCStyle)style
{
    _style = style;

    [self loadUI];
}
- (void)layoutHeadView
{
    UIView *headView = [UIView new];
    _headView = headView;
    [_containView addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    if (_style == CommentVCStyleOne) {
        [self setHeadViewStyleOne];
    }else
    {
        [self setHeadViewStyleTwo];
    }
    
    
}
#pragma mark -- 设置样式二的headView
-(void)setHeadViewStyleTwo
{
    UILabel *headTopLabel = [UtilTool createLabelFrame:CGRectZero title:@"总体评价" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:17] textAlignment:0 numberOfLine:1];
    _headTopLabel = headTopLabel;
    UILabel *headBottomLabel = [UtilTool createLabelFrame:CGRectZero title:@"车管家" textColor:[UIColor colorWithHexString:@"333333"] font:[UIFont systemFontOfSize:17] textAlignment:0 numberOfLine:1];
    _headBottomLabel = headBottomLabel;
//    [_headView sd_addSubviews:@[headTopLabel,headBottomLabel]];
    [_headView addSubview:headTopLabel];
    [_headView addSubview:headBottomLabel];
    StartView *startViewTop = [[StartView alloc] init];
    _startViewTop = startViewTop;
    startViewTop.style = StartViewStyleSmall;
    StartView *startViewBottom = [[StartView alloc] init];
    _startViewBottom = startViewBottom;
    startViewBottom.style = StartViewStyleSmall;
//    [_headView sd_addSubviews:@[startViewTop,startViewBottom]];
    [_headView addSubview:startViewTop];
    [_headView addSubview:startViewBottom];
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
    
    __weak typeof(self)ws = self;

    _startViewTop.startViewClick = ^(NSInteger startNum)
    {
        MyLog(@"%ld",startNum);
        [ws showTagView];
        
        switch (startNum) {
            case 0:
            {
                ws.tagView.dataArray = nil;
                if (ws.tagView.dataArrayTwo == nil) {
                    [ws hiddenTagView];
                }
            }
                break;
                
            case 1:
            {
                ws.tagView.dataArray = ws.commentModel.startOne;
                
            }
                break;
                
            case 2:
            {
                ws.tagView.dataArray = ws.commentModel.startTwo;
                
            }
                break;
                
            case 3:
            {
                ws.tagView.dataArray = ws.commentModel.startThree;
                
            }
                break;
                
            case 4:
            {
                ws.tagView.dataArray = ws.commentModel.startFour;
                
            }
                break;
                
            case 5:
            {
                ws.tagView.dataArray = ws.commentModel.startFive;
                
            }
                break;
                
                
            default:
                break;
        }
        


    };
    
    _startViewBottom.startViewClick = ^(NSInteger startNum)
    {
        MyLog(@"%ld",startNum);
        [ws showTagView];
        [ws showTagView];
        
        switch (startNum) {
            case 0:
            {
                ws.tagView.dataArrayTwo = nil;
                if (ws.tagView.dataArray == nil) {
                    [ws hiddenTagView];
                }
            }
                break;
                
            case 1:
            {
                ws.tagView.dataArrayTwo = ws.commentPeopleModel.startOne;
                
            }
                break;
                
            case 2:
            {
                ws.tagView.dataArrayTwo = ws.commentPeopleModel.startTwo;
                
            }
                break;
                
            case 3:
            {
                ws.tagView.dataArrayTwo = ws.commentPeopleModel.startThree;
                
            }
                break;
                
            case 4:
            {
                ws.tagView.dataArrayTwo = ws.commentPeopleModel.startFour;
                
            }
                break;
                
            case 5:
            {
                ws.tagView.dataArrayTwo = ws.commentPeopleModel.startFive;
                
            }
                break;
                
            default:
                break;
        }
    };
    
}

#pragma mark -- 设置样式一的headView
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
        make.bottom.mas_equalTo(_startView.mas_bottom);
    }];
    __weak typeof(self)ws = self;

    _startView.startViewClick = ^(NSInteger startNum)
    {
        MyLog(@"%ld",startNum);
        [ws showTagView];

        switch (startNum) {
            case 0:
            {
                [ws hiddenTagView];
            }
                break;
                
            case 1:
            {
                ws.tagView.dataArray = ws.commentModel.startOne;

            }
                break;

            case 2:
            {
                ws.tagView.dataArray = ws.commentModel.startTwo;

            }
                break;

            case 3:
            {
                ws.tagView.dataArray = ws.commentModel.startThree;

            }
                break;

            case 4:
            {
                ws.tagView.dataArray = ws.commentModel.startFour;

            }
                break;

            case 5:
            {
                ws.tagView.dataArray = ws.commentModel.startFive;

            }
                break;

                
            default:
                break;
        }

        
    };
    
}
#pragma mark -- showTagView
- (void)showTagView
{
    _tagView.hidden = NO;
    _centerL.hidden = YES;
}

#pragma mark -- hiddenTagView
- (void)hiddenTagView
{
    _tagView.hidden = YES;
    _centerL.hidden = NO;
}

- (void)layoutCenterView
{
    _centerView = [UIView new];
    _centerView.backgroundColor = [UIColor whiteColor];
    [_containView addSubview:_centerView];
    UILabel *centerL = [UtilTool createLabelFrame:CGRectZero title:@"来自星星的标签" textColor:[UIColor colorWithHexString:@"999999"] font:[UIFont systemFontOfSize:14] textAlignment:1 numberOfLine:0];
    _centerL = centerL;
    [_centerView addSubview:centerL];
    [centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_containView.mas_centerX);
        make.centerY.mas_equalTo(_containView.mas_centerY).offset(-25);
    }];
    
    
    TagView *tagView = [TagView new];
    
    _startView.tagArray = tagView.tagOneArray;
    _startViewTop.tagArray = tagView.tagOneArray;
    _startViewBottom.tagArray = tagView.tagTwoArray;

    
    _tagView = tagView;
    tagView.backgroundColor = [UIColor whiteColor];
    [_centerView addSubview:tagView];
    
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.style==CommentVCStyleOne) {
            make.top.mas_equalTo(_headView.mas_bottom).offset(58);
            make.height.mas_equalTo(190);

        }else
        {
            make.top.mas_equalTo(_headView.mas_bottom).offset(24);
            make.height.mas_equalTo(270);

        }
        make.leading.trailing.mas_equalTo(0);
    }];
    
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(_centerView);
        make.width.equalTo(_centerView);
    }];
    [tagView layoutIfNeeded];


    [self hiddenTagView];
    
    MyLog(@"%f  %f  %f  %f",tagView.frame.origin.x,tagView.frame.origin.y,tagView.frame.size.width,tagView.frame.size.height);
}

- (void)loadBottomView
{
    _bottomView = [UIView new];
    [_containView addSubview:_bottomView];
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_centerView.mas_bottom).offset(24);
        make.right.left.mas_equalTo(0);
    }];
    UITextView *textView = [[UITextView alloc] init];
    _textView = textView;
    textView.layer.borderWidth = 1;
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    textView.layer.cornerRadius = 4;
    textView.layer.masksToBounds = YES;
    textView.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    textView.font = [UIFont systemFontOfSize:14];
    textView.text = placeHoldString;
    textView.textColor = [UIColor colorWithHexString:@"999999"];

    UIButton *btn = [UIButton new];
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor colorWithHexString:@"39d5b8"];
    [btn setTitle:@"提交评价" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(CommitComment) forControlEvents:(UIControlEventTouchUpInside)];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    [_bottomView sd_addSubviews:@[textView,btn]];
    [_bottomView addSubview:textView];
    [_bottomView addSubview:btn];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-14);
        make.left.mas_equalTo(14);
        make.height.mas_equalTo(116);
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(textView.mas_leading);
        make.trailing.mas_equalTo(textView.mas_trailing);
        make.top.mas_equalTo(textView.mas_bottom).offset(24);
        make.height.mas_equalTo(44);
    }];
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(btn.mas_bottom);
    }];
    
    [_bottomView layoutIfNeeded];
    MyLog(@"%f  %f  %f  %f",_bottomView.frame.origin.x,_bottomView.frame.origin.y,_bottomView.frame.size.width,_bottomView.frame.size.height);

    [_containView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bottomView.mas_bottom).offset(20);
    }];
    
    [_containView layoutIfNeeded];
    [_scrollView layoutIfNeeded];
    MyLog(@"%f  %f  %f  %f",_containView.frame.origin.x,_containView.frame.origin.y,_containView.frame.size.width,_containView.frame.size.height);
    MyLog(@"%f  %f  %f  %f",_scrollView.frame.origin.x,_scrollView.frame.origin.y,_scrollView.frame.size.width,_scrollView.frame.size.height);
    
}

#pragma mark -- 提交按钮点击事件
- (void)CommitComment
{
    [_textView resignFirstResponder];
    
    if ([_textView.text isEqualToString:placeHoldString]) {
        _textView.text = @"";
    }
    
    
    MyLog(@"_textView.text:%@\n  _dataOneArray : %ld\n  _dataTwoArray: %ld\n _topStartNum:%ld _bottomStartNum:%ld \n startNum:%ld",_textView.text,_tagView.tagOneArray.count,_tagView.tagTwoArray.count,_startViewTop.lightingStartNum,_startViewBottom.lightingStartNum,_startView.lightingStartNum);
    
    NSMutableString *totalComment = [NSMutableString string];
    [_tagView.tagOneArray enumerateObjectsUsingBlock:^(TagModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = model.info;
        str = model.isZan ? [NSString stringWithFormat:@"%@1",str]:[NSString stringWithFormat:@"%@0",str];
        [totalComment appendFormat:@"%@=",str];
    }];
    
    NSMutableString *subComment = [NSMutableString string];
    [_tagView.tagTwoArray enumerateObjectsUsingBlock:^(TagModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = model.info;
        str = model.isZan ? [NSString stringWithFormat:@"%@1",str]:[NSString stringWithFormat:@"%@0",str];
        [subComment appendFormat:@"%@=",str];
    }];
    
    MyLog(@"%@",totalComment);
    
    NSMutableDictionary *dic;
    if (_style == CommentVCStyleOne) {
        
        if (_textView.text.length == 0 && _startView.lightingStartNum == 0) {
            _textView.text = placeHoldString;
            [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"请先输入评价内容"];
//            ALERT_VIEW(@"请先输入评价内容");
            _alert = nil;
            return;
        }
        
        dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_model.orderId,@"orderId",[UtilTool getCustomId],@"customerId",[self changeNSInterget:_startView.lightingStartNum],@"totalityStar",totalComment,@"totalityTag",_textView.text,@"commentContent",@"2.0.1",@"version", nil];
    }else if (_style == CommentVCStyleTwo){
        if (_textView.text.length == 0 && _startViewBottom.lightingStartNum == 0 && _startViewTop.lightingStartNum == 0) {
            _textView.text = placeHoldString;
//            ALERT_VIEW(@"请先输入评价内容");
             [[GroupManage shareGroupManages] groupAlertShowWithTitle:@"请先输入评价内容"];
//            _alert = nil;
            return;
        }
        dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_model.orderId,@"orderId",[UtilTool getCustomId],@"customerId",[self changeNSInterget:_startViewTop.lightingStartNum],@"totalityStar",totalComment,@"totalityTag",subComment,@"carManagerTag",@"",@"businessTag",_textView.text,@"commentContent",@"2.0.1",@"version",[self changeNSInterget:_startViewBottom.lightingStartNum],@"carManagerStar",@"0",@"businessStar", nil];
    }
    [NetWorkEngine postRequestUse:(self) WithURL:APP_URL(submit) WithDic:dic needEncryption:YES needAlert:YES showHud:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PING_JIA_CHENG_GONG" object:nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"errorInfo"]  delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
          alert = nil;
    } error:^(NSString *error) {
        
    } failure:^(NSString *fail) {
        
    }];
    
//    [RequestModel requestQueryFinishParkOrder:APP_URL(submit) WithType:nil WithDic:dic Completion:^(NSDictionary *dict) {
//                
//        ;
//      
//    
//    } Fail:^(NSString *error) {
//            ALERT_VIEW(error);
//            _alert = nil;
//    }];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)changeNSInterget:(NSInteger )num
{
    return [NSString stringWithFormat:@"%ld",(long)num];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    MyLog(@"textFile  ******   开始编辑");
    

    if ([textView.text isEqualToString:placeHoldString]) {
        textView.text = @"";
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        textView.text = placeHoldString;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>100) {
        textView.text = [textView.text substringToIndex:100];
        return ;
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
