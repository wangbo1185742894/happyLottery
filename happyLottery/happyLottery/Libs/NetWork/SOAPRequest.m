//
//  SOAPRequest.m
//  Lottery
//
//  Created by YanYan on 6/8/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "SOAPRequest.h"

@interface SOAPRequest() {
    NSString *soapHeaderStr;
    NSString *soapBodyStr;
    NSString *soapMessageStr;
    NSString *deviceName;
    NSString *appVersion;
}

@end

@implementation SOAPRequest

- (NSString *) modifyTemplate: (NSString *) template {
    return [template stringByReplacingOccurrencesOfString: @"NameSpaceURI" withString: @"http://webService.only.com/"];
}

- (NSString *) getClient {
    if (nil == deviceName) {
        deviceName = [Utility isIpad]?@"ipad": @"iphone";
    }
    return deviceName;
}

- (NSString *) getAppVersion {
    if(nil == appVersion) {
        appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    }
    return appVersion;
}

- (void) composeSOAPHeader {
    NSString *usernameEncrypted =@"";
    NSString *passwordEncrypted = @"";
    
//    NSString *usernameEncrypted = @"w2zcYR4ohSw=";
//    NSString *passwordEncrypted = @"w2zcYR4ohSw=";
    soapHeaderStr = [NSString stringWithFormat: [self modifyTemplate: SOAPHeaderTemplate],
                     usernameEncrypted,
                     passwordEncrypted,
                     [self getClient],
                     [self getAppVersion],
                     ChannelID];
}

- (void) composeSOAPBody {
    NSMutableString *paramXML = [NSMutableString string];
    for (NSString *paramKey in [self.paramDic allKeys]) {
        NSString *value = self.paramDic[paramKey];
        [paramXML appendFormat: @"<%@ i:type=\"d:string\">%@</%@>", paramKey, value, paramKey];
    }
    NSLog(@"%@",@(paramXML.length));
    soapBodyStr = [NSString stringWithFormat: [self modifyTemplate: SOAPBodyTemplate],
                                               self.apiName,
                                               paramXML,
                                               self.apiName];
}

- (void) composeSOAPMessage {
    soapMessageStr = [NSString stringWithFormat: SOAPMessageTemplate, soapHeaderStr, soapBodyStr];
}

- (NSString *) getSOAPMessage {
    [self composeSOAPHeader];
    [self composeSOAPBody];
    [self composeSOAPMessage];
    return soapMessageStr;
}
@end
