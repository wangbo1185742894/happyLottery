//
//  PostboyManager.m
//  happyLottery
//
//  Created by LYJ on 2018/11/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "PostboyManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PostboyManager

- (void)getPostboyInfoById:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *matchDic = [self objFromJson: responseJsonStr];
            [self.delegate getPostboyInfoByIddelegate:matchDic isSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getPostboyInfoByIddelegate:nil isSuccess:NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate getPostboyInfoByIddelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    };
    SOAPRequest *request = [self requestForAPI: APIGetPostboyInfoById withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)getPostboyAccountList:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate getPostboyAccountListdelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];
        } else {
            [self.delegate getPostboyAccountListdelegate:nil isSuccess:NO errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate getPostboyAccountListdelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    };
    
    SOAPRequest *request = [self requestForAPI: APIGetPostboyAccountList withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}



- (void)getMemberPostboyAccount:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate getMemberPostboyAccountdelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];
        } else {
            
            [self.delegate getMemberPostboyAccountdelegate:nil isSuccess:NO errorMsg:response.errorMsg];

        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate getMemberPostboyAccountdelegate:nil isSuccess:NO errorMsg:response.errorMsg];

    };
    
    SOAPRequest *request = [self requestForAPI: APIGetMemberPostboyAccount withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}



- (void)memberPostboyBalanceCount:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate memberPostboyBalanceCountdelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];
        } else {
            
            [self.delegate memberPostboyBalanceCountdelegate:nil isSuccess:NO errorMsg:response.errorMsg];

        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate memberPostboyBalanceCountdelegate:nil isSuccess:NO errorMsg:response.errorMsg];

    };
    
    SOAPRequest *request = [self requestForAPI: APIMemberPostboyBalanceCount withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)recentPostboyAccount:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate recentPostboyAccountdelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];
            
        } else {
            [self.delegate recentPostboyAccountdelegate:nil isSuccess:NO errorMsg:response.errorMsg];

            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate recentPostboyAccountdelegate:nil isSuccess:NO errorMsg:response.errorMsg];

    };
    
    SOAPRequest *request = [self requestForAPI: APIRecentPostboyAccount withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)listSubscribeDetailByPostboy:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate listSubscribeDetailByPostboydelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];

            
        } else {
            
            [self.delegate listSubscribeDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate listSubscribeDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

    };
    
    SOAPRequest *request = [self requestForAPI: APIListSubscribeDetailByPostboy withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)listRechargeDetailByPostboy:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate listRechargeDetailByPostboydelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];

        } else {
            [self.delegate listRechargeDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate listRechargeDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

    };
    
    SOAPRequest *request = [self requestForAPI: APIListRechargeDetailByPostboy withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)listBonusDetailByPostboy:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate listBonusDetailByPostboydelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];

            
        } else {
            [self.delegate listBonusDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate listBonusDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];
    };
    
    SOAPRequest *request = [self requestForAPI: APIListBonusDetailByPostboy withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)listWithdrawDetailByPostboy:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate listWithdrawDetailByPostboydelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];

            
        } else {
            
            [self.delegate listWithdrawDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate listWithdrawDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

    };
    
    SOAPRequest *request = [self requestForAPI: APIListWithdrawDetailByPostboy withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)getChasePrepayOrderListByPostboy:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate getChasePrepayOrderListByPostboydelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];

            
        } else {
            [self.delegate getChasePrepayOrderListByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate getChasePrepayOrderListByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

    };
    
    SOAPRequest *request = [self requestForAPI: APIGetChasePrepayOrderListByPostboy withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)listCommissionDetailByPostboy:(NSDictionary *)dictionary{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate listCommissionDetailByPostboydelegate:matchArray isSuccess:YES errorMsg:response.errorMsg];

            
        } else {
            [self.delegate listCommissionDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate listCommissionDetailByPostboydelegate:nil isSuccess:NO errorMsg:response.errorMsg];

    };
    
    SOAPRequest *request = [self requestForAPI: APIListCommissionDetailByPostboy withParam:@{@"params":[self actionEncrypt:[self JsonFromId:dictionary]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIPostboyService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

@end
NS_ASSUME_NONNULL_END
