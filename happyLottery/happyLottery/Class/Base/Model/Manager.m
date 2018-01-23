//
//  Manager.m
//  vernon_customer
//
//  Created by AMP on 4/3/13.
//  Copyright (c) 2013 AMP. All rights reserved.
//

#import "Manager.h"
#import "AESUtility.h"


@implementation Manager

- (id) init {
    if (self = [super init]) {

        return self;
    }
    return nil;
}

- (AFHTTPRequestOperation *) newRequestWithRequest: (SOAPRequest*)request
                                            subAPI:(NSString *)subApi
                            constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block
                                              success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                                              failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{

    NSString * soapMessage = [request getSOAPMessage];

    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:WSServerURL,subApi]]];

    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    NSLog(@"22334%@",msgLength);
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod: @"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest: theRequest];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {

    }];
    [operation setCompletionBlockWithSuccess: successBlock failure: failureBlock];
    [operation start];
    return operation;
}

- (NSMutableDictionary *) paramsDicForAPI: (NSString *) apiName withAuth: (BOOL) auth
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    paramDic[@"api_name"] = apiName;
   
    return paramDic;
}



- (NSString*) JsonFromId: (id) obj {
    if (obj == nil) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: obj
                                                       options: NSJSONWritingPrettyPrinted
                                                         error:&error];

    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding: NSUTF8StringEncoding];
        jsonString =  [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonString =  [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        jsonString =  [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
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

- (NSString *) legalString: (id) obj
{
    return [Utility legalString: obj];
}

- (void) showErrorMsg: (NSString *) msg
{

}
//加密
- (NSString *) actionEncrypt: (NSString *) string {
    return [AESUtility encryptStr: string];
}
//解密
- (NSString *) actionDecrypt: (NSString *) string {
    return [AESUtility decryptStr: string];
}

- (SOAPRequest *) requestForAPI: (NSString *) apiName withParam: (NSDictionary *) paramDic {
    SOAPRequest *request = [[SOAPRequest alloc] init];
    request.apiName = apiName;
    request.paramDic = paramDic;
    return request;
}

- (SOAPResponse *) wrapSOAPResponse: (NSString *) responseXML {
    NSLog(@"Response: %@", responseXML);
    SOAPResponse *response = [SOAPResponse responseWithXML: responseXML];
    [response errorCheck];
    //TODO: check if need login, if so show login page
//    NSString *responseJsonStr = [response getAPIResponse];
    return response;
}

- (AFHTTPRequestOperation *) newRequestWithRequest: (SOAPRequest*)request
                         constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block
                                           success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                                           failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    NSString *soapMessage;
//    if ([ipaName isEqualToString:@"CancelOrder"]) {
//
//    }else{
        soapMessage = [request getSOAPMessage];
//    }
    
    
    
    
    NSMutableURLRequest *theRequest;
#ifdef bate
    theRequest= [NSMutableURLRequest requestWithURL: WSServerURL];
#else
    
    
    NSString *urlStr = @"http://192.168.88.244:8086/app/head/url?";
    
//    NSString *urlStr = [GlobalInstance instance].baseUrl;
//    if (urlStr.length == 0) {
//        theRequest= [NSMutableURLRequest requestWithURL: WSServerURL];
//    }else{
        theRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlStr]];
//    }

#endif
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    NSLog(@"22334%@",msgLength);
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod: @"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest: theRequest];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
    [operation setCompletionBlockWithSuccess: successBlock failure: failureBlock];
    [operation start];
    return operation;
}

@end
