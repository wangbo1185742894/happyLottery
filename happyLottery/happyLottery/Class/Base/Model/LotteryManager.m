//
//  LotteryManager.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "LotteryManager.h"
#import "JCZQTranscation.h"

@implementation LotteryManager


- (void) getJczqMatch:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate gotJczqMatch:matchArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotJczqMatch:nil errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];

        [self.delegate gotJczqMatch:nil errorMsg:response.errorMsg];
    };
    
    SOAPRequest *request = [self requestForAPI: APIgetJczqMatch withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]} ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) getJczqSp:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate gotJczqSp:matchArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotJczqSp:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate gotJczqMatch:nil errorMsg:response.errorMsg];
    };
    
    SOAPRequest *request = [self requestForAPI: APIgetJczqSp withParam:nil ];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) getJczqLeague:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate gotJczqLeague:matchArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotJczqLeague:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate gotJczqLeague:nil errorMsg:response.errorMsg];
    };
    
    SOAPRequest *request = [self requestForAPI: APIgetJczqLeague withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) betLotteryScheme:(BaseTransaction *)transcation{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            
            [self.delegate betedLotteryScheme:responseJsonStr errorMsg:response.errorMsg];
        } else {
            [self.delegate betedLotteryScheme:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate betedLotteryScheme:nil errorMsg:response.errorMsg];
    };
    
    NSDictionary *betContentDic = [transcation lottDataScheme];
    NSMutableDictionary *subSchemeDic = [transcation submitParaDicScheme];
    
    subSchemeDic[@"betContent"] = [self JsonFromId:betContentDic];
    
    SOAPRequest *request = [self requestForAPI: APIBetLotteryScheme withParam:@{@"params":[self actionEncrypt:[self JsonFromId:subSchemeDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) schemeCashPayment:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            
            [self.delegate gotSchemeCashPayment:response.succeed errorMsg:response.errorMsg];
        } else {
            [self.delegate gotSchemeCashPayment:response.succeed errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate gotSchemeCashPayment:nil errorMsg:response.errorMsg];
    };
    
    SOAPRequest *request = [self requestForAPI: APISchemeCashPayment withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) schemeScorePayment:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        [self.delegate gotSchemeScorePayment:response.succeed errorMsg:response.errorMsg];
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate gotSchemeScorePayment:NO errorMsg:@"服务器错误"];
    };
    
    
    SOAPRequest *request = [self requestForAPI: APISchemeScorePayment withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) getJczqShortcut{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray *matchArray = [self objFromJson: responseJsonStr];
            [self.delegate gotJczqShortcut:matchArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotJczqShortcut:nil errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate gotJczqShortcut:nil errorMsg:response.errorMsg];
    };
    
    SOAPRequest *request = [self requestForAPI: APIgetJczqShortcut withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) listByForecast:(NSDictionary *)infoDic isHis:(BOOL)isHis{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed  && responseJsonStr!= nil && responseJsonStr.length>0) {
            NSArray  * dataArray = [self objFromJson:responseJsonStr];
            [self.delegate gotlistByForecast:dataArray errorMsg:response.errorMsg];
        }else{
            [self.delegate gotlistByForecast:nil  errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.delegate gotlistByForecast:nil  errorMsg:@"服务器错误"];
    };
    NSString *strPara;
    SOAPRequest *request;
    if (isHis) {
        strPara = [self JsonFromId:@{@"lotteryCode":infoDic[@"lotteryCode"],@"screenTime":infoDic[@"screenTime"]}];
        request = [self requestForAPI: APIlistByHisForecast withParam: @{@"params":[self actionEncrypt:strPara]}];
    }else{
        strPara = [self JsonFromId:@{@"lotteryCode":infoDic[@"lotteryCode"]}];
        request = [self requestForAPI: APIlistByForecast withParam: @{@"params":[self actionEncrypt:strPara]}];
    }
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
    
}


- (void) getForecastByMatch:(NSDictionary *)infoDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed  && responseJsonStr!= nil && responseJsonStr.length>0) {
            NSDictionary  * dataArray = [self objFromJson:responseJsonStr];
            [self.delegate gotForecastByMatch:dataArray  errorMsg:response.errorMsg];
        }else{
            [self.delegate gotForecastByMatch:nil  errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.delegate gotForecastByMatch:nil  errorMsg:@"服务器错误"];
    };
    
    SOAPRequest* request = [self requestForAPI:APIgetForecastByMatch  withParam: @{@"params":[self actionEncrypt:[self JsonFromId:infoDic]]}];
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)getJczqPairingMatch:(NSDictionary *)infoDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            
            NSString * infoString = [response getAPIResponse];
            
            NSDictionary  * dataDic = [self objFromJson:infoString];
            
            [self.delegate gotJczqPairingMatch:dataDic  errorMsg:response.errorMsg];
        }else{
            [self.delegate gotJczqPairingMatch:nil  errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
            [self.delegate gotJczqPairingMatch:nil  errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIgetJczqPairingMatch withParam: @{@"params":[self actionEncrypt:[self JsonFromId:infoDic]]}];
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
   
}

- (void) jcycScoreZhibo:(NSDictionary *)infoDic isJCZQ:(BOOL)isJCZQ{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed  && responseJsonStr!= nil && responseJsonStr.length>0) {
            NSArray  * dataArray = [self objFromJson:responseJsonStr];
            [self.delegate gotjcycScoreZhibo:dataArray  errorMsg:response.errorMsg] ;
        }else{
            [self.delegate gotjcycScoreZhibo:nil  errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.delegate gotjcycScoreZhibo:nil  errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request;
    if (isJCZQ) {
        request = [self requestForAPI: APIlistByJczqScore withParam: nil];
    }else{
        request = [self requestForAPI: APIlistByJclqScore withParam: nil];
    }
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)getListByRecScheme:(NSDictionary *)infoDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            NSString * infoString = [response getAPIResponse];
            NSArray  * dataArr = [self objFromJson:infoString];
            
            [self.delegate gotListByRecScheme:dataArr errorMsg:response.errorMsg];
        }else{
            [self.delegate gotListByRecScheme:nil errorMsg:response.errorMsg];
            
        }
        
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
        [self.delegate gotListByRecScheme:nil errorMsg:@"网络异常"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIlistByRecScheme withParam: @{@"params":[self actionEncrypt:[self JsonFromId:infoDic]]}];
    
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


-(void)getBFZBInfo{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponseNotNeedDecryptHasNum];
        
        if (response.succeed ) {
            NSMutableArray * matchArray = [self objFromJson: responseJsonStr];
            [self.delegate gotBFZBInfo:matchArray];
        }else{
            [self.delegate gotBFZBInfo:nil];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotBFZBInfo:nil];
    };
    
    SOAPRequest *request = [self requestForAPI: APIGetBFZBInfo  withParam: nil];

    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) getSchemeRecord:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray  *dataDic = [Utility objFromJson:responseJsonStr];
            [self.delegate gotSchemeRecord:dataDic errorMsg:response.errorMsg];
        } else {
            [self.delegate gotSchemeRecord:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotSchemeRecord:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIGetSchemeRecord withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void) getJczqTicketOrderDetail:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary  *dataArray = [Utility objFromJson:responseJsonStr];
            [self.delegate gotJczqTicketOrderDetail:dataArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotJczqTicketOrderDetail:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotJczqTicketOrderDetail:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIGetJczqTicketOrderDetail withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPITicketService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)getSchemeRecordBySchemeNo:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary  *dataArray = [Utility objFromJson:responseJsonStr];
            [self.delegate gotSchemeRecordBySchemeNo:dataArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotSchemeRecordBySchemeNo:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotSchemeRecordBySchemeNo:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIGetSchemeRecordBySchemeNo withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)listByRechargeChannel:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray  *dataArray = [Utility objFromJson:responseJsonStr];
            [self.delegate gotListByRechargeChannel:dataArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotListByRechargeChannel:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotListByRechargeChannel:nil errorMsg:@"服务器错误"];
    };
//
    SOAPRequest *request = [self requestForAPI: APIlistByRechargeChannel withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


//参数:
//params - {"cardCode":"xxxx","page":"xxx","pageSize":"xxx"} 卡号 和 分页信息

- (void)getCollectedMatchList:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray  *dataArray = [Utility objFromJson:responseJsonStr];
            [self.delegate gotCollectedMatchList:dataArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotCollectedMatchList:nil errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotCollectedMatchList:nil errorMsg:@"服务器错误"];
    };
    //
    SOAPRequest *request = [self requestForAPI: APIGetCollectedMatchList withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)getlistByHisGains:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSArray  *dataArray = [Utility objFromJson:responseJsonStr];
            [self.delegate gotlistByHisGains:dataArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotlistByHisGains:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotlistByHisGains:nil errorMsg:@"服务器错误"];
    };
    //
    SOAPRequest *request = [self requestForAPI: APIlistByHisGains withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

//params - {"cardCode":"xxx","matchId":"x","isCollect":"x"} cardCode:会员卡号;matchId:赛事Id;isCollect: 收藏:1/true 取消收藏:0/false
- (void)collectMatch:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        
        if (response.succeed) {
            
            [self.delegate collectedMatch:YES errorMsg:response.errorMsg andIsSelect:[paraDic[@"isCollect"] boolValue]];
        } else {
            [self.delegate collectedMatch:NO errorMsg:response.errorMsg andIsSelect:[paraDic[@"isCollect"] boolValue]] ;
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate collectedMatch:NO errorMsg:@"服务器错误" andIsSelect:[paraDic[@"isCollect"] boolValue]];
    };
    //
    SOAPRequest *request = [self requestForAPI: APICollectMatch withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)getForecastTotal:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        
        if (response.succeed) {
            NSString *responseJsonStr = [response getAPIResponse];
            NSDictionary  *infoDic = [Utility objFromJson:responseJsonStr];
            [self.delegate gotForecastTotal:infoDic errorMsg:response.errorMsg];
        } else {
           [self.delegate gotForecastTotal:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotForecastTotal:nil errorMsg:@"服务器错误"];
    };
    //
    SOAPRequest *request = [self requestForAPI: APIgetForecastTotal withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (NSString *)getStringformfeid :(EarningsType)defaultFeid{
    NSString *str;
    switch (defaultFeid) {
        case EarningsTypeSTEADY:
            str = @"STEADY";
            break;
        case EarningsTypeLOW_RISK:
            str = @"LOW_RISK";
            break;
        case EarningsTypeHIGH_RISK:
            str = @"HIGH_RISK";
            break;
        default:
            str = @"default";
            break;
    }
    
    return str;
    
}

@end
