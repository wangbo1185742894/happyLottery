//
//  LoadData.h
//  manager
//
//  Created by 王博 on 16/1/5.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Complete)(id data,BOOL isSuccess);

@interface LoadData : NSObject

+(LoadData*)singleLoadData;
-(void)RequestWithString:(NSString*)urlStr isPost:(BOOL)isPost andPara:(NSDictionary*)para andComplete:(Complete)complete;

@end
