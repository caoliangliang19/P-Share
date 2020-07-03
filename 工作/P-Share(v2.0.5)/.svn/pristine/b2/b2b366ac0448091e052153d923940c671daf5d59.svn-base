//
//  HelpViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/10/21.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
{
    NSInteger _i;
}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _i = 0;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelGuideImage];
}


- (void)cancelGuideImage
{
    
    _i++;
    if (_i==1) {
        self.groupImage.image = [UIImage imageNamed:@"step2"];
    }else if (_i == 2){
        self.groupImage.image = [UIImage imageNamed:@"step3"];
    }else if (_i == 3){
        self.groupImage.image = [UIImage imageNamed:@"step4"];
    }else if (_i == 4){
        self.groupImage.image = [UIImage imageNamed:@"step5"];
    }else if (_i == 5){
        self.groupImage.image = [UIImage imageNamed:@"step6"];
    }else if (_i == 6){
        self.groupImage.image = [UIImage imageNamed:@"step7"];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
