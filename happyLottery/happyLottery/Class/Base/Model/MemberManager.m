//
//  MemberManager.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MemberManager.h"

@implementation MemberManager
//网络请求实例
- (void) loginCurUser {
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *userInfo = [self objFromJson: responseJsonStr];
            if ([userInfo isKindOfClass: [NSDictionary class]]  && [Utility isLegalString: userInfo[@"user"]]) {
                [self.delegate loginUser:userInfo IsSuccess:YES errorMsg:response.errorMsg];
                //成功的代理方法
            }else
            {
                [self.delegate loginUser:nil IsSuccess:NO errorMsg:response.errorMsg];
                //失败的代理方法
            }
        } else {
            [self.delegate loginUser:nil IsSuccess:NO errorMsg:response.errorMsg];
            //失败的代理方法
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate loginUser:nil IsSuccess:NO errorMsg:@"服务器错误"];
        //失败的代理方法
    };
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithCapacity: 2];
//    * mobile 手机号 必填项  pwd 密码 加密的 必填, channelCode 渠道号 必填
    loginDic[@"channelCode"]=@"TBZ";
    loginDic[@"mobile"] = @"15929443992";
    loginDic[@"pwd"] = @"npSPTG1vMjk=";
    
    SOAPRequest *request = [self requestForAPI: @"login" withParam:@{@"params":[self actionEncrypt:[self JsonFromId:loginDic]]} ];
    [self newRequestWithRequest: request
      constructingBodyWithBlock: nil
                        success: succeedBlock
                        failure: failureBlock];
}

/**
 * 注册用户
 * @param {"mobile":"xxx", "pwd":"xxxx","channelCode":"xxx","shareCode":"xxx"}
 * mobile 手机号 必填项  pwd 密码 加密的 必填, channelCode 渠道号 必填 shareCode 分享码 可以不填
 * @return
 */
//@WebMethod
//String register(@WebParam(name = "params")String params) throws BizException;
//网络请求实例
- (void) registerUser{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *userInfo = [self objFromJson: responseJsonStr];
            if ([userInfo isKindOfClass: [NSDictionary class]]  && [Utility isLegalString: userInfo[@"user"]]) {
                [self.delegate loginUser:userInfo IsSuccess:YES errorMsg:response.errorMsg];
                //成功的代理方法
            }else
            {
                [self.delegate loginUser:nil IsSuccess:NO errorMsg:response.errorMsg];
                //失败的代理方法
            }
        } else {
            [self.delegate loginUser:nil IsSuccess:NO errorMsg:response.errorMsg];
            //失败的代理方法
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate loginUser:nil IsSuccess:NO errorMsg:@"服务器错误"];
        //失败的代理方法
    };
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    //    * mobile 手机号 必填项  pwd 密码 加密的 必填, channelCode 渠道号 必填
    loginDic[@"channelCode"]=@"TBZ";
    loginDic[@"mobile"] = @"15929443994";
    loginDic[@"pwd"] = @"npSPTG1vMjk=";
    
    
    SOAPRequest *request = [self requestForAPI: @"register" withParam:@{@"params":[self actionEncrypt:[self JsonFromId:loginDic]]} ];
    [self newRequestWithRequest: request
      constructingBodyWithBlock: nil
                        success: succeedBlock
                        failure: failureBlock];
}

@end
