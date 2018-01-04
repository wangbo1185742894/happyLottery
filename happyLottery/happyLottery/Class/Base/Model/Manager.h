//
//  Manager.h
//  vernon_customer
//
//  Created by AMP on 4/3/13.
//  Copyright (c) 2013 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "Macro.h"
#import "Utility.h"
#import "GlobalInstance.h"
#import "SOAPRequest.h"
#import "SOAPResponse.h"


@interface Manager : NSObject {
    NSMutableArray *requests;
    NSString * ipaName;
}


- (NSString*) JsonFromId: (id) obj;
- (id) objFromJson: (NSString*) jsonStr;

- (NSMutableDictionary *) paramsDicForAPI: (NSString *) apiName withAuth: (BOOL) auth;


- (NSString *) legalString: (id) obj;
- (void) showErrorMsg: (NSString *) msg;
- (NSString *) actionEncrypt: (NSString *) string;
- (NSString *) actionDecrypt: (NSString *) string;
- (SOAPRequest *) requestForAPI: (NSString *) apiName withParam: (NSDictionary *) paramDic;
- (AFHTTPRequestOperation *) newRequestWithRequest: (SOAPRequest*)request
                                            subAPI:(NSString *)subApi
                         constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block
                                           success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                                           failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
;

- (SOAPResponse *) wrapSOAPResponse: (NSString *) responseXML;

- (AFHTTPRequestOperation *) newRequestWithRequest: (SOAPRequest*)request
                         constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block
                                           success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                                           failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;
@end

