//
//  LotteryManager.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "LotteryManager.h"
#import "JCZQTranscation.h"
#import "Lottery.h"

@implementation LotteryManager


- (NSArray*) getAllLottery {
    NSArray *lotteryDStemp;
    NSArray *lotteryDSSource;
    
#ifdef betaVersion
    //    lotteryDSSource = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryConfig_" ofType: @"plist"]];
    
    lotteryDStemp = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryConfig" ofType: @"plist"]];
    lotteryDSSource = @[lotteryDStemp[0],lotteryDStemp[2],lotteryDStemp[1],lotteryDStemp[7],lotteryDStemp[8],lotteryDStemp[9],lotteryDStemp[4],lotteryDStemp[5],lotteryDStemp[10]];
    
#else
    lotteryDSSource = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryConfig" ofType: @"plist"]];
#endif
    
    NSMutableArray *lotteryDS = [NSMutableArray arrayWithCapacity: [lotteryDSSource count]];
    for (NSDictionary *lotteryDic in lotteryDSSource) {
        Lottery *lottery = [[Lottery alloc] init];
        
        NSArray *allKeys = [lotteryDic allKeys];
        for (NSString *key in allKeys) {
            SEL selector = NSSelectorFromString([NSString stringWithFormat: @"set%@:", key]);
            
            if ([key isEqualToString: @"Type"]) {
                lottery.type = (LotteryType) [lotteryDic[key] intValue];
            } else if ([lottery respondsToSelector: selector]) {
                [lottery performSelector: selector withObject: lotteryDic[key]];
            }
        }
        [lotteryDS addObject: lottery];
    }
    
    
    
    return @[lotteryDS[0],lotteryDS[2],lotteryDS[3],lotteryDS[1],lotteryDS[4],lotteryDS[6],lotteryDS[5],lotteryDS[7],lotteryDS[9],lotteryDS[10],lotteryDS[11]];
    
}

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


- (void) betLotterySchemeOpti:(BaseTransaction *)transcation schemeList:(NSArray *)schemeList{
    
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
    
    NSMutableDictionary *subSchemeDic = [transcation submitParaDicScheme];
    
    subSchemeDic[@"betContent"] = [self JsonFromId:schemeList];
    
    SOAPRequest *request = [self requestForAPI: APIBetLotteryScheme withParam:@{@"params":[self actionEncrypt:[self JsonFromId:subSchemeDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
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
//    [0]    (null)    @"betContent" : @"[{\"betMatches\":[{\"dan\":false,\"matchId\":\"1\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"2\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"3\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"4\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"5\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"6\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"7\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"8\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"9\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"10\",\"options\":[\"3\"]},{\"dan\":false,\"matchId\":\"11\",\"options\":[\"*\"]},{\"dan\":false,\"matchId\":\"12\",\"options\":[\"*\"]},{\"dan\":false,\"matchId\":\"13\",\"options\":[\"*\"]},{\"dan\":false,\"matchId\":\"14\",\"options\":[\"*\"]}]}]"
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

- (void) betChaseScheme:(LotteryTransaction *)transcation{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            [self.delegate betedChaseScheme:responseJsonStr errorMsg:response.errorMsg];
        } else {
            [self.delegate betedChaseScheme:nil errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        [self.delegate betedLotteryScheme:nil errorMsg:response.errorMsg];
    };
    
    NSDictionary *chaseContent = [transcation lottDataScheme];
    
    NSMutableDictionary *subSchemeDic = [transcation getDLTChaseScheme];
    
    subSchemeDic[@"chaseContent"] = [self JsonFromId:chaseContent];
    
    SOAPRequest *request = [self requestForAPI: APIbetChaseScheme withParam:@{@"params":[self actionEncrypt:[self JsonFromId:subSchemeDic]]}];
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

- (void) getJczqTicketOrderDetail:(NSDictionary *)paraDic andLottery:(NSString *)lotteryCode{
    
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
    NSString *url;
    if([lotteryCode isEqualToString:@"DLT"]){
        url = APIGetDltTicketOrderDetail;
    }else  if([lotteryCode isEqualToString:@"RJC"]){
        url = APIgetRjcTicketOrderDetail;
    }else  if([lotteryCode isEqualToString:@"SFC"]){
        url = APIgetSfcTicketOrderDetail;
    }else   if([lotteryCode isEqualToString:@"JCGJ"]){
        url = APIGetJcgjTicketOrderDetail;
    }else  if([lotteryCode isEqualToString:@"JCGYJ"]){
        url = APIGetJcgyjTicketOrderDetail;
    }else if ([lotteryCode isEqualToString:@"SSQ"]){
        url = APIGetSsqTicketOrderDetail;
    }else  if ([lotteryCode isEqualToString:@"JCLQ"]){
        url = APIGetJclqTicketOrderDetail;
    }else {
        url = APIGetJczqTicketOrderDetail;
    }
    SOAPRequest *request = [self requestForAPI: url withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
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

- (void)updateRecSchemeRecCount:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
    
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
    };
    
    SOAPRequest *request = [self requestForAPI: APIupdateRecSchemeRecCount withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
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
//{
//    bonusOptimizeSingleList =     (
//                                   {
//                                       clash = "AFC\U6e29\U5e03\U5c14\U767bVS\U5e03\U83b1\U514b\U672c";
//                                       matchId = "\U5468\U4e8c003";
//                                       matchKey = 104567;
//                                       odds = "3.97";
//                                       option = 0;
//                                       playType = 1;
//                                   },
//                                   {
//                                       clash = "\U5f17\U62c9\U95e8\U6208VS\U6cb3\U5e8a";
//                                       matchId = "\U5468\U4e09018";
//                                       matchKey = 104601;
//                                       odds = "1.9";
//                                       option = 0;
//                                       playType = 1;
//                                   }
//                                   );
//    forecastBonus = "15.09";
//    passType = "P2_1";
//}
- (void)getbonusOptimize:(BaseTransaction *)transcation{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        
        if (response.succeed) {
            NSString *responseJsonStr = [response getAPIResponse];
            NSArray  *infoDic = [Utility objFromJson:responseJsonStr];
            [self.delegate gotbonusOptimize:infoDic errorMsg:response.errorMsg];
        } else {
            [self.delegate gotbonusOptimize:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotbonusOptimize:nil errorMsg:@"服务器错误"];
    };
    
    NSArray *betContentDic = [transcation lottDataScheme];
    NSMutableDictionary *subSchemeDic = [NSMutableDictionary dictionaryWithCapacity:0];
    subSchemeDic[@"betMatches"] = [betContentDic firstObject][@"betMatches"];
    subSchemeDic[@"passTypes"] = [betContentDic firstObject][@"passTypes"];
//[1]    (null)    @"betMatches" : @"2 elements"    [2]    (null)    @"passTypes" : @"1 element"
//    subSchemeDic[@"betContent"] = [self JsonFromId:betContentDic];
    
    SOAPRequest *request = [self requestForAPI: APIbonusOptimize withParam:@{@"params":[self actionEncrypt:[self JsonFromId:subSchemeDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}


- (void)getSellIssueList:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        
        if (response.succeed) {
            NSString *responseJsonStr = [response getAPIResponse];
                NSArray *roundInfoArray = [self objFromJson: responseJsonStr];
                if ([roundInfoArray isKindOfClass: [NSArray class]]) {
                    NSMutableArray *rounds = [NSMutableArray arrayWithCapacity: roundInfoArray.count];
                    
                    for (NSDictionary *roundInfoDic in roundInfoArray) {
                        LotteryRound *round = [self getLotteryRoundFromDic: roundInfoDic];
                        if ([roundInfoDic.allKeys containsObject:@"sellStatus"]) {
                            round.sellStatus = roundInfoDic[@"sellStatus"];
                        }
                        [round isExpire];
                        [rounds addObject: round];
                    }
                    [self.delegate gotSellIssueList:rounds errorMsg:response.errorMsg];
                }
        } else {
            [self.delegate gotSellIssueList:nil errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotSellIssueList:nil errorMsg:@"服务器错误"];
    };
    //
    SOAPRequest *request = [self requestForAPI: APIgetSellIssueList withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)getListHisPageIssue:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            NSString *responseJsonStr = [response getAPIResponse];
            NSArray *dataArray = [Utility objFromJson:responseJsonStr];
            [self.delegate gotListHisPageIssue:dataArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotListHisPageIssue:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotListHisPageIssue:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIlistHisPageIssue withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)getListHisIssue:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            NSString *responseJsonStr = [response getAPIResponse];
            NSArray *dataArray = [Utility objFromJson:responseJsonStr];
            [self.delegate gotListHisIssue:dataArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotListHisIssue:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotListHisIssue:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIListHisIssue withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)getChaseDetailForApp:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            NSString *responseJsonStr = [response getAPIResponse];
            NSDictionary *dataDic = [Utility objFromJson:responseJsonStr];
            [self.delegate gotChaseDetailForApp:dataDic errorMsg:response.errorMsg];
        } else {
            [self.delegate gotChaseDetailForApp:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotChaseDetailForApp:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIgetChaseDetailForApp withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)listChaseSchemeForApp:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            NSString *responseJsonStr = [response getAPIResponse];
            NSArray   *dataList = [Utility objFromJson:responseJsonStr];
            [self.delegate listChaseSchemeForApp:dataList errorMsg:response.errorMsg];
        } else {
            [self.delegate listChaseSchemeForApp:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate listChaseSchemeForApp:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIlistChaseSchemeForApp withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)getStopChaseScheme:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {

            [self.delegate gotStopChaseScheme:response.succeed errorMsg:response.errorMsg];
        } else {
            [self.delegate gotStopChaseScheme:response.succeed errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotStopChaseScheme:NO errorMsg:@"网络异常"];
    };
    //
    SOAPRequest *request = [self requestForAPI: APIchaseWhenStop withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPISchemeService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)getListZcMatchSp:(NSDictionary *)paraDic{
    
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        if (response.succeed) {
            NSString *responseJsonStr = [response getAPIResponse];
            NSDictionary  *infoDic = [Utility objFromJson:responseJsonStr];
            [self.delegate gotListZcMatchSp:infoDic errorMsg:response.errorMsg];
        } else {
            [self.delegate gotListZcMatchSp:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotListZcMatchSp:nil errorMsg:@"服务器错误"];
    };
    //
    SOAPRequest *request = [self requestForAPI: APIlistZcMatchSp withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
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

- (LotteryRound *) getLotteryRoundFromDic: (NSDictionary *) roundDic {
    
    NSArray * dicKeys = @[@"stopTime",@"startTime",@"issueNumber",@"serverTime",@"lotteryCode",@"openResult"];
    NSArray * roundPropertys = @[@"stopTime",@"startTime",@"issueNumber",@"serverTime",@"lotteryCode",@"openResult"];
    
    LotteryRound *round = [[LotteryRound alloc] init];
    for (int i=0;i<dicKeys.count;i++) {
        NSString *key = dicKeys[i];
        NSString *value = [Utility legalString: roundDic[key]];
        if (![key isEqualToString:@"openResult"]) {
            NSString *property = roundPropertys[i];
            NSString *capFirst =[[property substringToIndex: 1] uppercaseString];
            NSString *selectorName = [NSString stringWithFormat: @"set%@%@:", capFirst,[property substringFromIndex: 1]];
            SEL selector = NSSelectorFromString(selectorName);
            if ([round respondsToSelector: selector]) {
                [round performSelector: selector withObject: value];
            }
        }else{
            NSString * temp = [value stringByReplacingOccurrencesOfString:@"," withString:@" "];
            NSRange rang = [temp rangeOfString:@"#"];
            if (rang.location == NSNotFound) {
                round.mainRes = temp;
                if([roundDic[@"lotteryCode"] isEqualToString:@"X115"]){
                    NSArray * numArray = [temp componentsSeparatedByString:@" "];
                    NSMutableArray * newNumTemp = [NSMutableArray array];
                    for (NSString * num in numArray) {
                        if ([num intValue] < 10 && num.length == 1) {
                            [newNumTemp addObject:[NSString stringWithFormat:@"0%@",num]];
                        }else{
                            [newNumTemp addObject:num];
                        }
                    }
                    round.mainRes = [newNumTemp componentsJoinedByString:@" "];
                }
            }else{
                NSString * mainRes = [temp substringToIndex:rang.location];
                NSString * subRes = [temp substringFromIndex:(rang.location+1)];
                round.mainRes = mainRes;
                round.subRes = subRes;
            }
        }
    }
    return round;
}


#pragma mark 竞猜冠亚军
- (void) listJcgjSellItem:(NSDictionary *)infoDic
{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed  && responseJsonStr!= nil && responseJsonStr.length>0) {
            NSArray  * dataArray = [self objFromJson:responseJsonStr];
            [self.delegate gotlistJcgjSellItem:dataArray errorMsg:response.errorMsg];
        }else{
            [self.delegate gotlistJcgjSellItem:nil errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate gotlistJcgjSellItem:nil errorMsg:@"服务器错误"];
    };
    SOAPRequest* request = [self requestForAPI:APIlistJcgjSellItem  withParam: nil];
    [self newRequestWithRequest:request
                          subAPI:SUBAPIDATA
       constructingBodyWithBlock:nil
                         success:succeedBlock
                         failure:failureBlock];
}

- (void)listJcgyjSellItem:(NSDictionary *)infoDic
{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed  && responseJsonStr!= nil && responseJsonStr.length>0) {
            NSArray  * dataArray = [self objFromJson:responseJsonStr];
            [self.delegate gotlistJcgyjSellItem:dataArray errorMsg:response.errorMsg];
        }else{
            [self.delegate gotlistJcgyjSellItem:nil  errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate gotlistJcgyjSellItem:nil  errorMsg:@"服务器错误"];
    };
    SOAPRequest* request = [self requestForAPI:APIlistJcgyjSellItem  withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
    
}

- (void)listJcgjItem:(NSDictionary *)infoDic
{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed  && responseJsonStr!= nil && responseJsonStr.length>0) {
            NSArray  * dataArray = [self objFromJson:responseJsonStr];
            [self.delegate gotlistJcgjItem:dataArray errorMsg:response.errorMsg];
        }else{
            [self.delegate gotlistJcgjItem:nil  errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.delegate gotlistJcgjItem:nil  errorMsg:@"服务器错误"];
    };
    SOAPRequest* request = [self requestForAPI:APIlistJcgjItem  withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
    
}

- (void)listJcgyjItem:(NSDictionary *)infoDic
{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed  && responseJsonStr!= nil && responseJsonStr.length>0) {
            NSArray  * dataArray = [self objFromJson:responseJsonStr];
            [self.delegate gotlistJcgyjItem:dataArray errorMsg:response.errorMsg];
        }else{
            [self.delegate gotlistJcgyjItem:nil  errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
                [self.delegate gotlistJcgyjItem:nil  errorMsg:@"服务器错误"];
    };
    SOAPRequest* request = [self requestForAPI:APIlistJcgyjItem  withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
}

- (void)getJcgjTicketOrderDetail:(NSDictionary *)paraDic
{
        
        void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
        {
            SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
            NSString *responseJsonStr = [response getAPIResponse];
            if (response.succeed) {
                NSDictionary  *dataArray = [Utility objFromJson:responseJsonStr];
                [self.delegate gotJcgjTicketOrderDetail:dataArray errorMsg:response.errorMsg];
            } else {
                [self.delegate gotJcgjTicketOrderDetail:nil errorMsg:response.errorMsg];
                
            }
        };
        void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [self.delegate gotJcgjTicketOrderDetail:nil errorMsg:@"服务器错误"];
        };
        
        SOAPRequest *request = [self requestForAPI: APIGetJcgjTicketOrderDetail withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
        [self newRequestWithRequest:request
                             subAPI:SUBAPITicketService 
          constructingBodyWithBlock:nil
                            success:succeedBlock
                            failure:failureBlock];
}

- (void)getJcgyjTicketOrderDetail:(NSDictionary *)paraDic
{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
                NSDictionary  *dataArray = [Utility objFromJson:responseJsonStr];
                [self.delegate gotJcgyjTicketOrderDetail:dataArray errorMsg:response.errorMsg];
        } else {
                [self.delegate gotJcgyjTicketOrderDetail:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
            [self.delegate gotJcgyjTicketOrderDetail:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIGetJcgyjTicketOrderDetail withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPITicketService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
    
}

#pragma mark 竞彩篮球

- (void)getJclqMatch:(NSDictionary *)infoDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed  && responseJsonStr!= nil && responseJsonStr.length>0) {
            NSArray  * dataArray = [self objFromJson:responseJsonStr];
            [self.delegate gotJclqMatch:dataArray errorMsg:response.errorMsg];
        }else{
            [self.delegate gotJclqMatch:nil  errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate gotJclqMatch:nil  errorMsg:@"服务器错误"];
    };
    SOAPRequest* request = [self requestForAPI:APIgetJclqMatch  withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
    
}
- (void)getJclqSp:(NSDictionary *)infoDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed  && responseJsonStr!= nil && responseJsonStr.length>0) {
            NSArray  * dataArray = [self objFromJson:responseJsonStr];
            [self.delegate gotJclqSp:dataArray errorMsg:response.errorMsg];
        }else{
            [self.delegate gotJclqSp:nil  errorMsg:response.errorMsg];
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate gotJclqSp:nil  errorMsg:@"服务器错误"];
    };
    SOAPRequest* request = [self requestForAPI:APIgetJclqSp  withParam:nil];
    [self newRequestWithRequest:request
                         subAPI:SUBAPIDATA
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
    
}

- (void)getJclqTicketOrderDetail:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary  *dataArray = [Utility objFromJson:responseJsonStr];
            [self.delegate gotSsqTicketOrderDetail:dataArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotSsqTicketOrderDetail:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotSsqTicketOrderDetail:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIGetSsqTicketOrderDetail withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPITicketService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
    
}

#pragma mark 双色球

- (void)getSsqTicketOrderDetail:(NSDictionary *)paraDic{
    void (^succeedBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        SOAPResponse *response = [self wrapSOAPResponse: operation.responseString];
        NSString *responseJsonStr = [response getAPIResponse];
        if (response.succeed) {
            NSDictionary  *dataArray = [Utility objFromJson:responseJsonStr];
            [self.delegate gotJclqTicketOrderDetail:dataArray errorMsg:response.errorMsg];
        } else {
            [self.delegate gotJclqTicketOrderDetail:nil errorMsg:response.errorMsg];
            
        }
    };
    void (^failureBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.delegate gotJclqTicketOrderDetail:nil errorMsg:@"服务器错误"];
    };
    
    SOAPRequest *request = [self requestForAPI: APIGetJclqTicketOrderDetail withParam:@{@"params":[self actionEncrypt:[self JsonFromId:paraDic]]}];
    [self newRequestWithRequest:request
                         subAPI:SUBAPITicketService
      constructingBodyWithBlock:nil
                        success:succeedBlock
                        failure:failureBlock];
    
}

@end
