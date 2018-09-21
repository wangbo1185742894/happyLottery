//
//  GlobalInstance.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "GlobalInstance.h"

static GlobalInstance *instance = NULL;

@interface GlobalInstance()

@end

@implementation GlobalInstance

+ (GlobalInstance *) instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GlobalInstance alloc]init];
    });
    return instance;
}

- (id)init{
    if (instance == NULL) {
        self = [super init];
        instance = self;
    }
    return instance;
}

-(User *)curUser{
    if (_curUser != nil) {
        return _curUser;
    }
    BOOL isLogin = NO;
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
   FMDatabase * fmdb =[FMDatabase databaseWithPath:fileName];
    if ([fmdb open]) {
        FMResultSet*  result = [fmdb executeQuery:@"select * from t_user_info"];
        if ([result next] && [result stringForColumn:@"mobile"] != nil) {
            isLogin = [[result stringForColumn:@"isLogin"] boolValue];
            User *user  =[[User alloc]init];
            user.mobile = [result stringForColumn:@"mobile"];
            user.cardCode = [result stringForColumn:@"cardCode"];
            user.loginPwd = [result stringForColumn:@"loginPwd"];
            user.isLogin = [[result stringForColumn:@"isLogin"] boolValue];
            user.payVerifyType = (PayVerifyType)[[result stringForColumn:@"payVerifyType"]  integerValue];
            return user;
        }else{
            return  nil;
        }
        [fmdb close];
    }else{
        return nil;
    }
}

@end
