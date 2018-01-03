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
        [self.delegate forgetPWDSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate sendForgetPWDSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate checkForgetPWDSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate resetNickSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate bandPayPWDSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate resetPayPWDSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate sendUpdatePaypwdSmsIsSuccess:NO errorMsg:@"服务器错误"];
        //失败的代理方法
    };
    //    NSDictionary *itemParaDic = @{@"mobile":paraDic[@"mobile"],@"channelCode":@"TBZ",@"checkCode":paraDic[@"checkCode"]};
    
    SOAPRequest *request = [self requestForAPI: APIsendUpdatePaypwdSms withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
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
        [self.delegate checkUpdatePaypwdSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate getSupportBankSms:nil IsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate bindNameSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate addBankCardSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        
        [self.delegate getBankListSms:nil IsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate unBindBankCardSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        if (response.succeed) {
            
            [self.delegate rechargeSmsIsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate rechargeSmsIsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate rechargeSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate withdrawSmsIsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate validatePaypwdSmsIsSuccess:NO errorMsg:@"服务器错误"];
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

/**
 * 获得现金流水
 * @param {"cardCode":"xxx","page":"xxx","pageSize":"xxx","type":"xxx"} cardCode 卡号 必填
 * page 当前页数 (默认 0 ) pageSize 分页大小 默认（10） type 流水类型 不填默认全部
 * 认购": SUBSCRIPTION,认购退款":SUBSCRIPTION_REFUND,奖金":BONUS，提现": CASH，"提现退款":CASH_REFUND,充值": RECHARGE"
 * 彩金":HANDSEL
 * @return orderType:会员的订单类型,amounts:账户交易金额,remBalance:变化后总余额,createTime:创建时间
 */

- (void) getCashBlotterSms:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getCashBlotterSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getCashBlotterSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getCashBlotterSms:nil IsSuccess:NO errorMsg:@"服务器错误"];
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
            NSDictionary *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getScoreBlotterSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getScoreBlotterSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getScoreBlotterSms:nil IsSuccess:NO errorMsg:@"服务器错误"];
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
 * @param params @param {"cardCode":"xxx"} cardCode 会员帐号
 * @return  会员信息
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
        [self.delegate getMemberByCardCodeSms:nil IsSuccess:NO errorMsg:@"服务器错误"];
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
            NSDictionary *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getRedPacketByStateSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getRedPacketByStateSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getRedPacketByStateSms:nil IsSuccess:NO errorMsg:@"服务器错误"];
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
        [self.delegate openRedPacketSms:nil IsSuccess:NO errorMsg:@"服务器错误"];
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
            NSDictionary *Info = [self objFromJson: responseJsonStr];
            
            [self.delegate getCouponByStateSms:Info IsSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getCouponByStateSms:nil IsSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate getCouponByStateSms:nil IsSuccess:NO errorMsg:@"服务器错误"];
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
- (void)updateImage:(NSDictionary<NSString*,NSArray<NSData*>*>* _Nullable)apkFile {
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString * infoString = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary * info = [self objFromJson:infoString];
            [self.delegate updateImage:YES errorMsg:response.errorMsg];
        }else{
           [self.delegate updateImage:NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
       [self.delegate updateImage:YES errorMsg:@"服务器错误"];
    };
    NSDictionary *paramDic = apkFile;
//     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:NSJSONWritingPrettyPrinted error:nil];
//     NSString *str = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSMutableDictionary * jsonparamDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    jsonparamDic[@"type"] = @"0";
//    jsonparamDic[@"pageStart"] = @"0";
//    jsonparamDic[@"cardCode"] =strId;
    SOAPRequest *request = [self requestForAPI:APIupdateImage withParam:@{@"arg1":[self actionEncrypt:[self JsonFromId:paramDic]]}];
    
    [self newRequestWithRequest: request
      constructingBodyWithBlock: nil
                        success: succeedBlock
                        failure: failureBlock];
}

@end
