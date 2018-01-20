//
//  netWorkHelper.h
//  LESSON-HTTP
//
//  Created by xixi on 15/8/26.
//  Copyright (c) 2015年 xixi. All rights reserved.
//

#import <Foundation/Foundation.h>
//声明协议
@protocol NetWorkingHelperDelegate <NSObject>
//@required必须实现的协议
@optional
- (void)passValueWithDic:(NSDictionary *)value;
- (void)passPostValueWithDic:(NSDictionary *)value;
- (void)passToValueWithDic:(NSDictionary *)value;

//判断是否有网络
- (void)passValueWithError;
- (void)passpostValueWithError;

@end

@interface netWorkHelper : NSObject

@property (nonatomic,weak) id< NetWorkingHelperDelegate>delegate;
//get请求的方法
- (void)getRequestMethodWithUrlstring:(NSString *)urlString parameter:(NSString *)parameter;
- (void)getBRequestMethodWithUrlstring:(NSString *)urlString parameter:(NSString *)parameter;
//POST
- (void)postRequestMethodWithUrlstring:(NSString *)urlString parameter:(NSString *)parameter;
@end
