//
//  QQTool.m
//  P-SHARE
//
//  Created by fay on 16/9/8.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "QQTool.h"

@interface QQTool ()
{
    TencentOAuth    *_tencentOAuth;
    GroupManage     *_manage;
    
}
@end
@implementation QQTool

- (void)QQLogin
{
    [self QQBegin];
    _manage = [GroupManage shareGroupManages];
    
    NSArray  *permissions= [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",@"add_t",nil];
    [_tencentOAuth authorize:permissions inSafari:NO];

}
- (void)QQBegin{
    if (!_tencentOAuth) {
        _tencentOAuth=[[TencentOAuth alloc]initWithAppId:QQ_APPKEY andDelegate:self];
    }
}
#pragma mark --- QQ登录获取用户信息
-(void)getUserInfoResponse:(APIResponse *)response
{
    
    MyLog(@"respons:%@",response.jsonResponse);
    if (_manage.openid) {
        _manage.headimgurl = response.jsonResponse[@"figureurl_qq_2"];
        _manage.nickname = response.jsonResponse[@"nickname"];
        if (self.QQToolLoginCallBack) {
            self.QQToolLoginCallBack(response.jsonResponse);
        }
    }
    
}
#pragma mark -- TencentSessionDelegate
//登陆完成调用
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && _tencentOAuth.accessToken.length != 0 )
    {
        [_manage groupHubShow];
        //  记录登录用户的OpenID、Token以及过期时间
        _manage.loginType = @"04";
        _manage.openid = _tencentOAuth.openId;
        [_tencentOAuth getUserInfo];
        
    }
    else
    {
        MyLog(@"登录不成功没有获取accesstoken");
    }
}

//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    MyLog(@"tencentDidNotLogin");
    if (cancelled)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户取消登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"登录失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}
// 网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    MyLog(@"tencentDidNotNetWork");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"无网络连接，请设置网络" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}



- (void)onReq:(QQBaseReq *)req
{
    
}
/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
            if ([sendResp.result isEqualToString:@"0"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"QQ分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"QQ分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

// 处理QQ在线状态的回调
- (void)isOnlineResponse:(NSDictionary *)response {
    MyLog(@"处理QQ在线状态的回调");
}

@end
