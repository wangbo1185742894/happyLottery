//
//  netWorkHelper.m
//  LESSON-HTTP
//
//  Created by xixi on 15/8/26.
//  Copyright (c) 2015年 xixi. All rights reserved.
//

#import "netWorkHelper.h"
@interface netWorkHelper ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property (nonatomic,retain) NSMutableData *dataSource;
@end
@implementation netWorkHelper
- (NSMutableData *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableData data];
    }
    return _dataSource;
}

//#pragma mark- 实现异步delegate
////开始返回响应头，可能会带部分数据
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    
//    NSLog(@"开始");
//    
//}
////返回数据
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    
//    NSLog(@"返回数据");
//    //拼接服务器返回的数据
//    [self.dataSource appendData:data];
//    
//    
//    
//}
////连接错误
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    
//    NSLog(@"连接错误");
//    
//    
//    
//}
////请求完成。本次连接完成
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSLog(@"连接完成");
//    if (self.dataSource) {
//        NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:self.dataSource options:NSJSONReadingAllowFragments error:nil];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(passValueWithDic:)]) {
//            [self.delegate passValueWithDic:listDic];
//        }
//        
//
//    }
//    }
#pragma mark - get同步

#pragma mark - get异步请求
- (void)getRequestMethodWithUrlstring:(NSString *)urlString parameter:(NSString *)parameter {
    //判断是否有参数，get请求，所以urlString需要拼接请求参数
    NSMutableString *urlMutableString = [[NSMutableString alloc] initWithString:urlString];
    if (parameter) {
        [urlMutableString appendString:parameter];
    
    }

    //创建url
    NSURL *url = [NSURL URLWithString:urlMutableString];
    //创建请求reques
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //创建同步连接
//    NSError *error;
//   NSData *jsondata = [NSURLConnection  sendSynchronousRequest:request returningResponse:nil error:&error];
    
    //json解析
    
//  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingAllowFragments error:nil];

    //创建异步连接需要代理
    //[NSURLConnection connectionWithRequest:request delegate:self];
    //通过代里传值
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(passValueWithDic:)]) {
    //         [self.delegate passValueWithDic:dic];
    //    }

    
    
    //创建异步连接的block
    NSOperationQueue *queue = [NSOperationQueue mainQueue];

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(passValueWithError)]) {
                [self.delegate passValueWithError];
            }
            //NSLog(@"listdic%@",listDic);
        } else {
        //解析
        NSError *error;
        NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (self.delegate && [self.delegate respondsToSelector:@selector(passValueWithDic:)]) {
            [self.delegate passValueWithDic:listDic];
        }
        }

    }];
    
    
    
    
    
    
}

#pragma mark - post
- (void)postRequestMethodWithUrlstring:(NSString *)urlString parameter:(NSString *)parameter {
    //创建url
    NSURL *url = [NSURL URLWithString:urlString];
    //创建请求request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求的方式
    [request setHTTPMethod:@"POST"];
    //设置post请求参数
    NSData *data = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //创建异步请求代理模式
    //[NSURLConnection connectionWithRequest:request delegate:self];
        //创建异步连接block
        //多线程
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!data) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(passValueWithDic:)]) {
                    [self.delegate passpostValueWithError];
                }
                //NSLog(@"listdic%@",listDic);
            } else {
            
            NSDictionary *postDataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //通过代里传值
            if (self.delegate && [self.delegate respondsToSelector:@selector(passPostValueWithDic:)]) {
            [self.delegate passPostValueWithDic:postDataDic];
            }
            }
        }];
    
    
    
}

//GET- B
- (void)getBRequestMethodWithUrlstring:(NSString *)urlString parameter:(NSString *)parameter {
    //判断是否有参数，get请求，所以urlString需要拼接请求参数
    NSMutableString *urlMutableString = [[NSMutableString alloc] initWithString:urlString];
    if (parameter) {
        [urlMutableString appendString:parameter];
        
    }
        //创建url
    NSURL *url = [NSURL URLWithString:urlMutableString];
    //创建请求reques
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
       //创建异步连接的block
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(passValueWithError)]) {
                [self.delegate passValueWithError];
            }
        }else{
        //解析
        NSDictionary *listDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(passToValueWithDic:)]) {
            [self.delegate passToValueWithDic:listDic];
        }
        }
        
    }];
    
 

}

@end
