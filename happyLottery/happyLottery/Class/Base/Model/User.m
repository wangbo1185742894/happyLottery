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

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"bankBinding"]) {
        self.bankBinding = [value boolValue];
        return;
    }
    if ([key isEqualToString:@"paypwdSetting"]) {
        self.paypwdSetting = [value boolValue];
        return;
    }
    if ([key isEqualToString:@"payPWDThreshold"]) {
        self.payPWDThreshold = [value intValue];
        return;
    }
    [super setValue:value forKey:key];
}


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

-(NSString *)whitelist{
    
#ifdef APPSTORE
    
    if ([_whitelist boolValue] == YES&& self.isLogin == YES) {
        return @"1";
    }else{
        
        return @"0";
    }
#endif
    return @"1";

}

-(NSString *)getShareUrl{
    if ([self.memberType isEqualToString:@"CIRCLE_MASTER"]) {
        return [NSString stringWithFormat:@"%@%@?shareCode=%@&shareCardCode=%@",H5BaseAddress,KcircleRegister,self.shareCode,self.cardCode];
    }else{
        return [NSString stringWithFormat:@"%@%@?shareCardCode=%@",H5BaseAddress,KcircleRegisterCopy,self.cardCode];
    }
}

@end
