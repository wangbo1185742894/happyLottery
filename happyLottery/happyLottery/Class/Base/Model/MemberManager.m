//
//  MemberManager.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MemberManager.h"

@implementation MemberManager
//* mobile 手机号 必填项  pwd 密码 加密的 必填, channelCode 渠道号 必填
//* @return
//*/
//@WebMethod
//String login(@WebParam(name = "params")String params) throws BizException;

- (void) loginCurUser:(NSDictionary *)paraDic {
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *userInfo = [self objFromJson: responseJsonStr];
            
            [self.delegate loginUser:userInfo IsSuccess:YES errorMsg:response.errorMsg];
           
        } else {
            [self.delegate loginUser:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate loginUser:nil IsSuccess:NO errorMsg:@"服务器错误"];
        //失败的代理方法
    };

    SOAPRequest *request = [self requestForAPI: APILogin withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 注册用户
 * @param {"mobile":"xxx", "pwd":"xxxx","channelCode":"xxx","shareCode":"xxx"}
 * mobile 手机号 必填项  pwd 密码 加密的 必填, channelCode 渠道号 必填 shareCode 分享码 可以不填
 * @return
 */
//@WebMethod
//String register(@WebParam(name = "params")String params) throws BizException;

- (void) registerUser:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *userInfo = [self objFromJson: responseJsonStr];
            [self.delegate registerUser:userInfo IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate registerUser:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate registerUser:nil IsSuccess:NO errorMsg:@"服务器错误"];
        //失败的代理方法
    };
    NSDictionary *itemParaDic;
    if (paraDic[@"shareCode"] == nil) {
         itemParaDic = @{@"mobile":paraDic[@"userTel"], @"pwd":[self actionEncrypt:paraDic[@"userPwd"]],@"channelCode":@"TBZ"};
    }else{
        itemParaDic = @{@"mobile":paraDic[@"userTel"], @"pwd":[self actionDecrypt:paraDic[@"userPwd"]],@"channelCode":@"TBZ",@"shareCode":paraDic[@"shareCode"]};
    }
    SOAPRequest *request = [self requestForAPI: APIRegister withParam:@{@"params":[self actionEncrypt:[self JsonFromId:itemParaDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

@end
