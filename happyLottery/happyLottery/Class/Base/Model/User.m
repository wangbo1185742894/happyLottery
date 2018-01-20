//
//  User.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "User.h"
#import "FMDatabase.h"
#import <AudioToolbox/AudioToolbox.h>//添加推送声音lala

@interface User()
   @property(nonatomic,strong)FMDatabase* fmdb;
@end

@implementation User

-(PayVerifyType)payVerifyType{
    
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    self.fmdb =[FMDatabase databaseWithPath:fileName];
    
    if ([self.fmdb open]) {
        NSString *mobile =self.mobile;
       FMResultSet*   result = [self.fmdb executeQuery:@"select * from t_user_info where mobile = ?",mobile];
        do {
            if ([result stringForColumn:@"payVerifyType"]) {
                return (PayVerifyType)[[result stringForColumn:@"payVerifyType"] integerValue];
            }
        } while ([result next]);
        [result close];
        [self.fmdb close];
    }
    
   
    return PayVerifyTypeAlwaysNo;
}

-(NSString *)totalBanlece{
    return [NSString stringWithFormat:@"%.2f",[self.balance doubleValue] + [self.sendBalance doubleValue] + [self .notCash doubleValue]];
}


@end
