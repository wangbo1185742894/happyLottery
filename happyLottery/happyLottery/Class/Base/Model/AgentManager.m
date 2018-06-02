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
 会员建圈申请
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

/**
 获取当前用户的圈子信息
 */
- (void)getAgentInfo:(NSDictionary *)param{
    
    [self AgentManagerRequest:param url:Agent_getAgentInfo andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate getAgentInfodelegate:[self analyticalDictionary:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate getAgentInfodelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}


/**
 获取当前用户所在圈子的所有圈民列表(我的圈子->我的圈友)
 */
- (void)listAgentMember:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_listAgentMember andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate listAgentMemberdelegate:[self analyticalArray:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate listAgentMemberdelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}

/**
 获取当前登录用户的圈子可跟单方案数
 */
- (void)getAgentFollowCount:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_getAgentFollowCount andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate getAgentFollowCountdelegate:[self analyticalString:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate getAgentFollowCountdelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}

/**
 获取当前登录用户的圈子可跟单方案
 */
- (void)listAgentFollow:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_listAgentFollow andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate listAgentFollowdelegate:[self analyticalArray:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate listAgentFollowdelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}


/**
 获取圈子的动态
 */
- (void)listAgentDynamic:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_listAgentDynamic andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate listAgentDynamicdelegate:[self analyticalArray:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate listAgentDynamicdelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}

/**
 获取我的圈子
 */
- (void)getMyAgentInfo:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_getMyAgentInfo andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate getMyAgentInfodelegate:[self analyticalDictionary:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate getMyAgentInfodelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}


/**
佣金账户转个人账户
 */
- (void)transferAccount:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_transferAccount andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate transferAccountdelegate:[self analyticalString:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate transferAccountdelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}


/**
 分页获取圈主的佣金转账记录
 */
- (void)listMyTransfer:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_listMyTransfer andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate listMyTransferdelegate:[self analyticalArray:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate listMyTransferdelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}


/**
 变更圈子的头像
 */
- (void)modifyHeadUrl:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_modifyHeadUrl andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate modifyHeadUrldelegate:[self analyticalString:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate modifyHeadUrldelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}

/**
变更圈名
 */
- (void)modifyCircleName:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_modifyCircleName andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate modifyCircleNamedelegate:[self analyticalString:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate modifyCircleNamedelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}

/**
 申请变更圈子公告
 */
- (void)modifyNotice:(NSDictionary *)param{
    [self AgentManagerRequest:param url:Agent_modifyNotice andSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate modifyNoticedelegate:[self analyticalString:response] isSuccess:response.succeed errorMsg:response.errorMsg];
    } andfailure:^(AFHTTPRequestOperation *operation, id responseObject) {
        SOAPResponse *response = [self wrapSOAPResponse:operation.responseString];
        [self.delegate modifyNoticedelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    }];
}

@end
