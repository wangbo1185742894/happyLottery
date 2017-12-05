//
//  SOAPResponse.m
//  Lottery
//
//  Created by YanYan on 6/8/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "SOAPResponse.h"
#import "AESUtility.h"
#import "XMLDictionary.h"

@implementation SOAPResponse

+ (SOAPResponse *) responseWithXML: (NSString *) responseXML {
    SOAPResponse *reponse = [[SOAPResponse alloc] init];
    [reponse setResponseXML: responseXML];
    return reponse;
}

- (void) setResponseXML: (NSString *) xml {
    responseXML = xml;
    responseDic = [NSDictionary dictionaryWithXMLString: xml];
}

//parse xml get value for return tag
// need decry
- (NSString *) getAPIResponse {
    if (nil == returnedString) {
        NSArray *responseComp = [responseXML componentsSeparatedByString: @"<return>"];
        if (responseComp.count > 1) {
            returnedString = responseComp[1];
            responseComp = [returnedString componentsSeparatedByString: @"</return>"];
            returnedString = responseComp[0];
            //if not string, should be error code
            if (![Utility isNumeric: returnedString]) {
                returnedString = [AESUtility decryptStr: returnedString];
            }
        }
    }
    return returnedString;
}
// not need decry
- (NSString *) getAPIResponseNotNeedDecrypt {
    if (nil == returnedString) {
        NSArray *responseComp = [responseXML componentsSeparatedByString: @"<return>"];
        if (responseComp.count > 1) {
            returnedString = responseComp[1];
            responseComp = [returnedString componentsSeparatedByString: @"</return>"];
            returnedString = responseComp[0];
//            if not string, should be error code
            if ([Utility isNumeric: returnedString]) {
                returnedString = nil;
            }
        }
    }
    
    return returnedString;
}
- (NSString *) getAPIResponseNotNeedDecryptHasNum {
    if (nil == returnedString) {
        NSArray *responseComp = [responseXML componentsSeparatedByString: @"<return>"];
        if (responseComp.count > 1) {
            returnedString = responseComp[1];
            responseComp = [returnedString componentsSeparatedByString: @"</return>"];
            returnedString = responseComp[0];
            //if not string, should be error code
            //            if ([Utility isNumeric: returnedString]) {
            //                returnedString = nil;
            //            }
        }
    }
    
    
    return returnedString;
}

-(void)getResult{
    NSDictionary *resultDic = [self objFromJson:returnedString];
    NSString *returnedStr =[NSString stringWithFormat:@"%@",resultDic[@"result"]];
    if (returnedStr !=nil && ![returnedStr isEqualToString:@"FAIL"]) {
        returnedString = returnedStr;
    }else{
        
        returnedString = @"";
    }
}
- (void) errorCheck {
    NSDictionary *headerDic = responseDic[@"soap:Body"];
    NSDictionary *returnDic  = [headerDic.allValues firstObject];
    NSDictionary *dic = [self objFromJson:[AESUtility decryptStr:  returnDic[@"return"] ]];
    self.errorMsg = dic[@"message"];
    returnedString = dic[@"result"];
    NSString *codeStr = dic[@"code"];
    //success code
    if ([codeStr isEqualToString: @"0000"]) {
        self.succeed = YES;
        self.errorCode = codeStr;
    } else {
        self.errorCode = codeStr;
        self.succeed = NO;
    }
}

- (NSString*) JsonFromId: (id) obj {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: obj
                                                       options: NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding: NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

- (id) objFromJson: (NSString*) jsonStr {
    if (jsonStr == nil) {
        return nil;
    }
    NSData * jsonData = [jsonStr dataUsingEncoding: NSUTF8StringEncoding];
    NSError * error=nil;
    NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    return parsedData;
}


@end
