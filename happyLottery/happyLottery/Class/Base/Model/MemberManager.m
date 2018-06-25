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
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationUserLoginSuccess" object:nil];
            [self.delegate loginUser:userInfo IsSuccess:YES errorMsg:response.errorMsg];
           
        } else {
            [self.delegate loginUser:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate loginUser:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
    };
    
    SOAPRequest *request = [self requestForAPI: APILogin withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
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
        [self.delegate registerUser:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    NSString *platformCode;
#ifdef APPSTORE
    platformCode = @"APPSTORE";
#else
    platformCode = @"ONLY";
#endif
    
    NSDictionary *itemParaDic;
    if (paraDic[@"shareCode"] == nil) {
         itemParaDic = @{@"mobile":paraDic[@"userTel"], @"pwd":[self actionEncrypt:paraDic[@"userPwd"]],@"channelCode":@"TBZ",@"platformCode":platformCode};
    }else{
        itemParaDic = @{@"mobile":paraDic[@"userTel"], @"pwd":[self actionEncrypt:paraDic[@"userPwd"]],@"channelCode":@"TBZ",@"shareCode":paraDic[@"shareCode"],@"platformCode":platformCode};
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
        [self.delegate sendRegisterSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
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
        [self.delegate checkRegisterSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
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
/**
 * 重置登录密码
 * @param {"mobile":"xxx","newPwd":"xxx","channelCode":"xxx"} mobile 手机号 必填
 * newPwd 新密码 必填 channelCode 渠道号 必填
 * @throws BizException
 */
- (void) forgetPWDSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate forgetPWDSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate forgetPWDSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate forgetPWDSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
//    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIForgetPWDSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 重置登录密码时发送短信验证码
 * @param params {"mobile":"xxx", "channelCode":"xxx"}
 * @return 是否成功
 * @throws BizException
 */

- (void) sendForgetPWDSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate sendForgetPWDSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate sendForgetPWDSmsIsSuccess:NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate sendForgetPWDSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ"};
    
    SOAPRequest *request = [self requestForAPI: APISendForgetPWDSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:itemParaDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}
/**
 * 验证重置登录密码时发送短信验证码
 * @param params {"mobile":"xxx", "channelCode":"xxx", "checkCode":"xxxxx"}
 * @return 是否成功
 * @throws BizException
 */
- (void) checkForgetPWDSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate checkForgetPWDSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate checkForgetPWDSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate checkForgetPWDSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APICheckForgetPWDSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:itemParaDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 重置昵称
 * @param {"mobile":"xxx","newPwd":"xxx","channelCode":"xxx"} mobile 手机号 必填
 * newPwd 新密码 必填 channelCode 渠道号 必填
 * @throws BizException
 */
- (void) resetNickSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate resetNickSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate resetNickSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate resetNickSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIResetNickSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 绑定支付密码
 params - {"mobile":"xxx","newPaypwd":"xxxx","channelCode":"xxx"} mobile 手机号 必填 newPaypwd 新密码 必填 channelCode 渠道号 必填
 * @throws BizException
 */
- (void) bandPayPWDSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate bandPayPWDSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate bandPayPWDSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate bandPayPWDSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIBandPayPWDSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 重置支付密码
 params - {"mobile":"xxx","oldPaypwd":"xxx","newPaypwd":"xxx","channelCode":"xxx"} mobile 手机号 必填 oldPaypwd 旧密码 newPaypwd 新密码 channelCode 渠道号

 * @throws BizException
 */
- (void) resetPayPWDSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate resetPayPWDSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate resetPayPWDSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate resetPayPWDSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIResetPayPWDSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 修改登录密码密码
 params - {"mobile":"xxx","oldPaypwd":"xxx","newPaypwd":"xxx","channelCode":"xxx"} mobile 手机号 必填 oldPaypwd 旧密码 newPaypwd 新密码 channelCode 渠道号
 
 * @throws BizException
 */
- (void) changeLoginPWDSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate changeLoginPWDSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate changeLoginPWDSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate changeLoginPWDSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIChangeLoginPWDSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}
/**
 * 修改支付密码时发送短信验证码
 参数:
 params - {"mobile":"xxx", "channelCode":"xxx"}

 */
- (void) sendUpdatePaypwdSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate sendUpdatePaypwdSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate sendUpdatePaypwdSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate sendUpdatePaypwdSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":CHANNEL_CODE};
    
    SOAPRequest *request = [self requestForAPI: APIsendUpdatePaypwdSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:itemParaDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 验证修改支付密码时发送短信验证码
 参数:
 params - {"mobile":"xxx", "channelCode":"xxx", "checkCode":"xxxxx"}
 */
- (void) checkUpdatePaypwdSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate checkUpdatePaypwdSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate checkUpdatePaypwdSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate checkUpdatePaypwdSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIcheckUpdatePaypwdSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 获得支持的银行
 */
- (void) getSupportBankSms{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
           NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
                NSDictionary *Info = [self objFromJson: responseJsonStr];
          
            [self.delegate getSupportBankSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getSupportBankSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getSupportBankSms:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetSupportBank withParam:nil ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 实名认证
 参数:
 params - {"cardCode":"xxx","name":"xxx"} cardCode 会员卡号 name 会员真实姓名
 */
- (void) bindNameSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate bindNameSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate bindNameSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate bindNameSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIbindName withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 添加银行卡
 参数:
 params - {"cardCode":"xxx","bankNumber":"xxx","bankName":"xxx", "bankUserName":"xxx","bankEposit":"xxx"} cardCode 会员卡号 bankNumber 银行卡号 bankName 银行名称 bankUserName 银行卡用户姓名 bankEposit 银行卡简称
 */
- (void) addBankCardSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate addBankCardSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate addBankCardSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate addBankCardSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIaddBankCard withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 获得会员已绑定的银行卡列表
 参数:
 params - {"cardCode":"xxx"} cardCode 会员卡号
 */
- (void) getBankListSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
           NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
             NSDictionary *Info = [self objFromJson: responseJsonStr];
            [self.delegate getBankListSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getBankListSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
        [self.delegate getBankListSms:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetBankList withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 解绑银行卡
 参数:
 params - {"cardCode":"xxx","bankNumber":"xxx","payPwd":"xxx"} cardCode 会员卡号 bankNumber 银行卡号 payPwd 支付密码
 */
- (void) unBindBankCardSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate unBindBankCardSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate unBindBankCardSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate unBindBankCardSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIunBindBankCard withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 会员充值 {"cardCode":"xxxxx", "channel":"xxxx", "amounts":10}
 参数:
 params - String cardCode 会员卡号, RechargeChannel channel 充值渠道, BigDecimal amounts 充值金额
 */
- (void) rechargeSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        
        if (response.succeed) {
            NSDictionary *Info = [self objFromJson: responseJsonStr];
            [self.delegate rechargeSmsIsSuccess:YES andPayInfo:Info errorMsg:response.errorMsg];
        } else {
            [self.delegate rechargeSmsIsSuccess:NO andPayInfo:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate rechargeSmsIsSuccess:NO andPayInfo:nil errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIrecharge withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) getAvailableCoupon:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        
        if (response.succeed) {
            NSArray *Info = [self objFromJson: responseJsonStr];
            [self.delegate gotAvailableCoupon:YES andPayInfo:Info errorMsg:response.errorMsg];
        } else {
            [self.delegate gotAvailableCoupon:NO andPayInfo:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotAvailableCoupon:NO andPayInfo:nil errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetAvailableCoupon withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) queryRecharge:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        
        if (response.succeed) {
            NSDictionary *Info = [self objFromJson: responseJsonStr];
            [self.delegate queryRecharge:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate queryRecharge:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate queryRecharge:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIqueryRecharge withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 会员提现 {"cardCode":"xxxxx", "paypwd":"xxxx", "bankId":"123123", "amounts":10}
 参数:
 params - String cardCode 会员卡号 , String paypwd 支付密码 , Long bankId 绑定的银行卡ID, BigDecimal amounts 金额
 */
- (void) withdrawSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate withdrawSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate withdrawSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate withdrawSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIwithdraw withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 验证支付密码
 * @param params {"cardCode":"xxx","payPwd":"xxx"}
 * @return
 * @throws BizException
 */
- (void) validatePaypwdSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            [self.delegate validatePaypwdSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate validatePaypwdSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate validatePaypwdSmsIsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIvalidatePaypwd withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) getCashBlotterSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getCashBlotterSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getCashBlotterSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getCashBlotterSms:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetCashBlotter withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}  ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


/**
 * 获得积分流水
 * @param {"cardCode":"xxx","page":"xxx","pageSize":"xxx","type":"xxx"} cardCode 卡号 必填
 * page 当前页数 (默认 0 ) pageSize 分页大小 默认（10） type 流水类型 不填默认全部
 *"认购":SUBSCRIPTION "活动赠送":ACTIVITY"签到":SIGN "奖金":BONUS "方案保底":BAODI "保底转认购":BAODI_TURN "合买提成": TOGETHER_COMMISSION
 * @return  orderType:会员的订单类型,amounts:账户交易金额,remBalance:变化后总余额,createTime:创建时间
 */
- (void) getScoreBlotterSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getScoreBlotterSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getScoreBlotterSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getScoreBlotterSms:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetScoreBlotter withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}  ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 根据卡号获取会员信息
 * @param @param {"cardCode":"xxx"} cardCode 会员帐号
 * 会员信息
 * @throws BizException
 */
- (void) getMemberByCardCodeSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getMemberByCardCodeSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getMemberByCardCodeSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getMemberByCardCodeSms:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetMemberByCardCode withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}  ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 根据是否有效  获得红包
 * @param params {"cardCode":"xxx","isValid":"xxx"} cardCode 会员卡号 isValid 是否有效 true:锁定或解锁 false:失效
 * @return
 * @throws BizException
 */
- (void) getRedPacketByStateSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getRedPacketByStateSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getRedPacketByStateSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getRedPacketByStateSms:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetRedPacketByState withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}  ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIActivity
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 打开红包
 * @param params {"id":"xxxx"} id 红包id
 * @return
 * @throws BizException
 */
- (void) openRedPacketSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate openRedPacketSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate openRedPacketSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate openRedPacketSms:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIopenRedPacket withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}  ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIActivity
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 根据状态分页查询优惠券
 * @param params {"cardCode":"xxx","isValid":"xxx"} cardCode 会员卡号 isValid 优惠券状态 true：可使用 false：失效或已使用
 *               NOT_USE("未使用"),USE("使用"),INVALID("失效");
 * @return  couponCode:优惠卷的卡号 status:优惠卷状态 quota:使用限额(消费多少钱可以使用)
 *          deduction:抵扣金额  invalidTime:失效时间(过期时间)
 * @throws BizException
 */
- (void) getCouponByStateSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getCouponByStateSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getCouponByStateSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getCouponByStateSms:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetCouponByState withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}  ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

//上传头像
- (void)updateImage:(NSDictionary *)paramDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString * infoString = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary * info = [self objFromJson:infoString];
            [self.delegate updateImage:info errorMsg:response.errorMsg];
        }else{
           [self.delegate updateImage:NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
       [self.delegate updateImage:YES errorMsg:@"请检查网络连接"];
    };

    SOAPRequest *request = [self requestForAPI:APIupdateImage withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paramDic]]}];
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void) getMemberByCardCode:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *userInfo = [self objFromJson: responseJsonStr];
            [self.delegate gotMemberByCardCode:userInfo errorMsg:response.errorMsg];
        } else {
            [self.delegate gotMemberByCardCode:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate gotMemberByCardCode:nil errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    NSDictionary *itemParaDic = @{@"cardCode":paraDic[@"cardCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetMemberByCardCode withParam:@{@"params":[self actionEncrypt:[self JsonFromId:itemParaDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 * 获取二维码的地址
 * @param params {"clientType" : "IOS", "channelCode" : "xxxx"}
 * @return 结果json
 * @throws BizException
 */
- (void) getQRCode:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
         NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
             //NSDictionary *userInfo = [self objFromJson: responseJsonStr];
              [self.delegate getQRCodeStateSms:responseJsonStr IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getQRCodeStateSms:nil IsSuccess:YES errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
         [self.delegate getQRCodeStateSms:nil IsSuccess:YES errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetClientDownLoadUrl withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


/**
 * 意见反馈
 * @param params {"cardCode":"xxx","feedbackContent":"xxx","fkscore":"xxx"}
 *               cardCode卡号  ；    feedbackContent  反馈内容    ；     fkscore    打分 (可以不填)
 * @return
 * @throws BizException
 */
- (void)FeedBack:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString * infoString = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary * info = [self objFromJson:infoString];
            [self.delegate FeedBack:info errorMsg:response.errorMsg];
        }else{
            [self.delegate FeedBack:NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate FeedBack:YES errorMsg:@"请检查网络连接"];
    };
    
    SOAPRequest *request = [self requestForAPI:APIfeedBack withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 意见反馈--未读消息条数
 参数:
 params - {"cardCode":"10000001" }
 */
- (void)FeedBackUnReadNum:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString * infoString = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary * info = [self objFromJson:infoString];
            [self.delegate FeedBackUnReadNum:info IsSuccess:YES errorMsg:response.errorMsg];
        }else{
             [self.delegate FeedBackUnReadNum:nil IsSuccess:NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
         [self.delegate FeedBackUnReadNum:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
   
    };
    
    SOAPRequest *request = [self requestForAPI:APIfeedBackUnReadNum withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 意见反馈--更新会员所有意见为已读
 参数:
 params - {"cardCode":"10000001" }
 */
- (void)ResetFeedBackReadStatus:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString * infoString = [response getAPIResponse];
        if (response.succeed) {
     
            [self.delegate ResetFeedBackReadStatusSmsIsSuccess: YES errorMsg:response.errorMsg];
        }else{
            [self.delegate ResetFeedBackReadStatusSmsIsSuccess: NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
          [self.delegate ResetFeedBackReadStatusSmsIsSuccess: YES errorMsg:@"请检查网络连接"];
        
    };
    
    SOAPRequest *request = [self requestForAPI:APIresetFeedBackReadStatus withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 
 获得会员意见反馈列表
 参数:
 params - {"cardCode":"xxx","page":"xxx","pageSize":"xxx"}
 */
- (void) getFeedbackListSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getFeedbackListSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getFeedbackListSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getFeedbackListSms:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIgetFeedbackList withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}  ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) signIn:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
 
        if (response.succeed) {
            NSDictionary *Info = [self objFromJson: responseJsonStr];
            [self.delegate signInIsSuccess:Info isSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate signInIsSuccess:nil isSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate signInIsSuccess:nil isSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIsignIn withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) isSignInToday:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            [self.delegate gotisSignInToday:responseJsonStr IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate gotisSignInToday:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotisSignInToday:nil IsSuccess:NO errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIisSignInToday withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}  ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


/**
 * 获取二维码的地址
 * @param params {"clientType" : "IOS", "channelCode" : "xxxx"}
 * @return 结果json
 * @throws BizException
 */
- (void) upMemberShareSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            //NSDictionary *userInfo = [self objFromJson: responseJsonStr];
            [self.delegate upMemberShareSmsIsSuccess: YES result:responseJsonStr errorMsg:response.errorMsg];
        } else {
            [self.delegate upMemberShareSmsIsSuccess:YES result:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate upMemberShareSmsIsSuccess:YES result:nil  errorMsg:@"请检查网络连接"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIMemberShare withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)saveVisit:(NSArray  *)infoArray{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self .delegate saveVisited:response.succeed];
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self .delegate saveVisited:NO];
    };
    
    NSMutableDictionary * paramDic1 = [NSMutableDictionary dictionaryWithCapacity:1];
    paramDic1[@"params"] = [self actionEncrypt:[self JsonFromId:infoArray]];
    
    SOAPRequest *request = [self requestForAPI:APIsaveVisit withParam:paramDic1];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

-(void)upLoadClientInfo:(NSDictionary *)clientInfo{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed == YES) {
            NSLog(@"yes");
        }
        
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    };
    
    NSMutableDictionary * paramDic1 = [NSMutableDictionary dictionaryWithCapacity:1];
    paramDic1[@"params"] = [self actionEncrypt:[self JsonFromId:clientInfo]];
    
    SOAPRequest *request = [self requestForAPI:APISaveClientInfo withParam:paramDic1];
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)getVueHttpUrl{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        
        if (response.succeed) {
            NSString *responseJsonStr = [response getAPIResponse];
            
            [self.delegate gotVueHttpUrl:responseJsonStr errorMsg:response.errorMsg];
        } else {
            [self.delegate gotVueHttpUrl:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotVueHttpUrl:nil errorMsg:@"请检查网络连接"];
    };
    //
    SOAPRequest *request = [self requestForAPI: APIGetVueHttpUrl withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

/**
 意见反馈--更新会员所有意见为已读
 参数:
 params - {"cardCode":"10000001" }
 */
- (void)giveShareScore:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
//        NSString * infoString = [response getAPIResponse];
        if (response.succeed) {
            
            [self.delegate giveShareScore : YES errorMsg:response.errorMsg];
        }else{
            [self.delegate giveShareScore: NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate ResetFeedBackReadStatusSmsIsSuccess: YES errorMsg:@"请检查网络连接"];
        
    };
    
    SOAPRequest *request = [self requestForAPI:APIgiveShareScore withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIMember
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


@end
