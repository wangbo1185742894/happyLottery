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
//WebMethod
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
 * param {"mobile":"xxx", "pwd":"xxxx","channelCode":"xxx","shareCode":"xxx"}
 * mobile 手机号 必填项  pwd 密码 加密的 必填, channelCode 渠道号 必填 shareCode 分享码 可以不填
 *
 */

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


/**
 * 注册时发送短信验证码
 * param {"mobile":"xxx", "channelCode":"xxx"}
 * return 是否成功
 * @throws BizException
 */

- (void) sendRegisterSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate sendRegisterSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate sendRegisterSmsIsSuccess:NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate sendRegisterSmsIsSuccess:NO errorMsg:@"服务器错误"];
        //失败的代理方法
    };
    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ"};
  
    SOAPRequest *request = [self requestForAPI: APISendRegisterSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:itemParaDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}
/**
 * 验证注册时发送短信验证码
 * param {"mobile":"xxx", "channelCode":"xxx", "checkCode":"xxxxx"}
 * return 是否成功
 * @throws BizException
 */
- (void) checkRegisterSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate checkRegisterSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate checkRegisterSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate checkRegisterSmsIsSuccess:NO errorMsg:@"服务器错误"];
        //失败的代理方法
    };
    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APICheckRegisterSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:itemParaDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

@end
