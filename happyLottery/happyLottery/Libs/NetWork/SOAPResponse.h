//
//  SOAPResponse.h
//  Lottery
//
//  Created by YanYan on 6/8/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOAPResponse : NSObject {
    NSString *returnedString;
    NSString *responseXML;
    NSDictionary *responseDic;
}

@property BOOL succeed;
@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, strong) NSString *errorCode;

+ (SOAPResponse *) responseWithXML: (NSString *) responseXML;
- (NSString *) getAPIResponse;
- (NSString *) getAPIResponseNotNeedDecrypt;

- (NSString *) getAPIResponseNotNeedDecryptHasNum;
- (void) setResponseXML: (NSString *) xml;
- (void) errorCheck;
@end
