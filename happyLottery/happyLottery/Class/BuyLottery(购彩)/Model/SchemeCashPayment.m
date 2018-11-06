
//
//  SchemeCashPayment.m
//  happyLottery
//
//  Created by 王博 on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "SchemeCashPayment.h"

@implementation SchemeCashPayment

-(NSMutableDictionary*)submitParaDicScheme{
    NSMutableDictionary *submitParaDic = [[NSMutableDictionary alloc]init];
    submitParaDic[@"cardCode"] = self.cardCode;
    submitParaDic[@"schemeNo"] = self.schemeNo;
    submitParaDic[@"couponCode"] = self.couponCode;
    submitParaDic[@"subCopies"] = @(self.subCopies);
    submitParaDic[@"subscribed"] = @(self.subscribed);
    submitParaDic[@"realSubscribed"] = @(self.realSubscribed);
    submitParaDic[@"isSponsor"] = @(true);
    return submitParaDic;
}

@end
