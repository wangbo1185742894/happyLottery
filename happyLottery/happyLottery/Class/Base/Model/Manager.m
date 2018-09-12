//
//  Manager.m
//  vernon_customer
//
//  Created by AMP on 4/3/13.
//  Copyright (c) 2013 AMP. All rights reserved.
//

#import "Manager.h"
#import "AESUtility.h"
#import <arpa/inet.h>
#import <netdb.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/utsname.h>

@implementation Manager

- (id) init {
    if (self = [super init]) {

        return self;
    }
    return nil;
}

//判断服务器是否可达
- (BOOL)socketReachabilityTest {
    
    int socketNumber = socket(AF_INET, SOCK_STREAM, 0);
    
    struct sockaddr_in serverAddress;
    
    serverAddress.sin_family = AF_INET;
    
    serverAddress.sin_addr.s_addr = inet_addr("118.190.43.29");
    
    serverAddress.sin_port = htons(28000);
    if (connect(socketNumber, (const struct sockaddr *)&serverAddress, sizeof(serverAddress)) == 0) {
        close(socketNumber);
        return true;
    }
    close(socketNumber);;
    return false;
}

//判断网络状态
- (void)afnReachabilityTest {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                
                [self.netDelegate netIsNotEnable];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //                [self showPromptText:@"WWAN" hideAfterDelay:1.8];
                //                NSLog(@"AFNetworkReachability Reachable via WWAN");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //                [self showPromptText:@"WiFi" hideAfterDelay:1.8];
                //                NSLog(@"AFNetworkReachability Reachable via WiFi");
                break;
            case AFNetworkReachabilityStatusUnknown:
            default:
                //                [self showPromptText:@"Unknown" hideAfterDelay:1.8];
                //                NSLog(@"AFNetworkReachability Unknown");
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


- (AFHTTPRequestOperation *) newRequestWithRequest: (SOAPRequest*)request
                                            subAPI:(NSString *)subApi
                            constructingBodyWithBlock: (void (^)(id <AFMultipartFormData> formData))block
                                              success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                                              failure: (void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock
{
    
//    if (![self socketReachabilityTest ]) {
//        [self .netDelegate serverIsNotConnect];
//        return nil;
//    }
//    [self afnReachabilityTest];
   
    NSString * soapMessage = [request getSOAPMessage];
    NSString *lotteryUrl;
    if ([GlobalInstance instance].lotteryUrl .length == 0) {
        lotteryUrl = WSServerURL;
    }else{
        lotteryUrl = [GlobalInstance instance].lotteryUrl;
    }
//
//    if ([request.apiName isEqualToString:APIrecharge]) {
//        lotteryUrl = @"http://192.168.88.108:28090/services%@";
//    }
  
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:lotteryUrl,subApi]]];
    theRequest.timeoutInterval = 10;
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    NSLog(@"22334%@",msgLength);
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod: @"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest: theRequest];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {

    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [operation setCompletionBlockWithSuccess: successBlock failure: failureBlock];
         [operation start];
    });
   
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

@end
