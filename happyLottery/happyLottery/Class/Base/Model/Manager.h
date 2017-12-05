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




@protocol ManagerDelegate <NSObject>
@optional
- (void) needUserLogin;
- (void) systemError;
@end

@interface Manager : NSObject {
    NSMutableArray *requests;
    NSString * ipaName;
}

@property (nonatomic, weak) id<ManagerDelegate> delegate;

- (NSString*) JsonFromId: (id) obj;
- (id) objFromJson: (NSString*) jsonStr;
- (BOOL) checkResponse: (NSDictionary *) responseDic;
- (NSMutableDictionary *) paramsDicForAPI: (NSString *) apiName withAuth: (BOOL) auth;


- (NSString *) legalString: (id) obj;
- (void) showErrorMsg: (NSString *) msg;
- (NSString *) actionEncrypt: (NSString *) string;
- (NSString *) actionDecrypt: (NSString *) string;
- (SOAPRequest *) requestForAPI: (NSString *) apiName withParam: (NSDictionary *) paramDic;
- (AFHTTPRequestOperation *) newRequestWithRequest: (SOAPRequest*)request
                         constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block
                                           success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                                           failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;
- (SOAPResponse *) wrapSOAPResponse: (NSString *) responseXML;
@end
