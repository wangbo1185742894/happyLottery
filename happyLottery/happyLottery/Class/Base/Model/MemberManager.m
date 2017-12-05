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
              
                //成功的代理方法
            }else
            {
                //失败的代理方法
            }
        } else {
            //失败的代理方法
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        //失败的代理方法
    };
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionaryWithCapacity: 2];
    
    loginDic[@"ip"]=@"error";
    loginDic[@"cardCode"] = @"80001072";
    loginDic[@"password"] = @"npSPTG1vMjk=";
    
    SOAPRequest *request = [self requestForAPI: @"login" withParam:@{@"arg1":[self actionEncrypt:[self JsonFromId:loginDic]]} ];
    [self newRequestWithRequest: request
      constructingBodyWithBlock: nil
                        success: succeedBlock
                        failure: failureBlock];
}

@end
