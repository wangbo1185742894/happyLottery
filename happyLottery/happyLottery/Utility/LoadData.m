//
//  LoadData.m
//  manager
//
//  Created by 王博 on 16/1/5.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import "LoadData.h"
#import "AFNetworking.h"

static LoadData *loadData = nil;

@interface LoadData ()

@property(strong,nonatomic)AFHTTPRequestOperationManager*manager;



@end
@implementation LoadData


+(LoadData*)singleLoadData{

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        loadData = [[LoadData alloc]init];
    });
    return loadData;

}

//懒加载
-(AFHTTPRequestOperationManager*)manager{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    _manager = [AFHTTPRequestOperationManager manager];
    
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];

//    [_manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@", self.singleGlobal.SID] forHTTPHeaderField:@"Cookie"];
    return _manager;
}

-(void)RequestWithString:(NSString*)urlStr isPost:(BOOL)isPost andPara:(NSDictionary*)para andComplete:(Complete)complete{
    
    if (isPost) {
    
        [self POSTWithUrl:urlStr andPara:para andComplete:complete];
    }else{
     [self GETWithUrl:urlStr andComplete:complete];
    }
}

-(void)GETWithUrl:(NSString*)urlStr andComplete:(Complete)complete{

    
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",string);
        complete(responseObject,YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complete(nil,NO);
    }];

}

-(void)POSTWithUrl:(NSString*)urlStr andPara:(NSDictionary*)para andComplete:(Complete)complete{
    
    [self.manager POST:urlStr parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        complete(responseObject,YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        complete(nil,NO);
    }];
    
}

@end
