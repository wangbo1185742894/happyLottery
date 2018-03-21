//
//  SchemeCashPayment.h
//  happyLottery
//
//  Created by 王博 on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface SchemeCashPayment : BaseModel


@property (strong,nonatomic)NSString *cardCode , *schemeNo,*couponCode,*lotteryName;
@property (assign,nonatomic)NSInteger subCopies,baodiCopies,baodiCost;
@property(assign,nonatomic)double subscribed,realSubscribed;
@property(assign,nonatomic)BOOL isSponsor;

@property(assign,nonatomic)CostType costType;
@end
