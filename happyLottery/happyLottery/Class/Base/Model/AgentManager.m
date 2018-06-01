//
//  AgentManager.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "AgentManager.h"

typedef  void(^RequestBlock)(AFHTTPRequestOperation *operation, id responseObject);
@implementation AgentManager

- (void) AgentManagerRequest:(NSDictionary *)paraDic url:(NSString *)url andSuccess:(RequestBlock)success andfailure:(RequestBlock)failure{
    NSDictionary *para ;
    if (paraDic == nil) {
        para = nil;
    }else{
        para = @{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]};
    }
    SOAPRequest *request = [self requestForAPI:url  withParam:para];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIAgentService
      constructingBodyWithBlock:nil
                        success:success
                        failure:failure];
}

/**
 解析数组

 */
-(NSArray *)analyticalArray:(SOAPResponse *)  response{
    NSString *responseJsonStr = [response getAPIResponse];
    NSArray *userInfo;
    if (response.succeed) {
        userInfo = [self objFromJson: responseJsonStr];
    }
    return userInfo;
}

/**
 解析字典
 
 */
-(NSDictionary *)analyticalDictionary:(SOAPResponse *)  response{
    NSString *responseJsonStr = [response getAPIResponse];
    NSDictionary *userInfo;
    if (response.succeed) {
        userInfo = [self objFromJson: responseJsonStr];
    }
    return userInfo;
}
/**
 解析字符串
 
 */
-(NSString *)analyticalString:(SOAPResponse *)  response{
    return [response getAPIResponse];
}

/**
 会员建圈申请 {"cardCode":"xxx","realName":"xxx","mobile":"xxx","qq":"xxx"} cardCode 卡号 realName 真实姓名 mobile 手机号 qq qq号
 */
-(void )agentApply:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_agentApply andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate agentApplydelegate:[self analyticalDictionary:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate agentApplydelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}



@end
