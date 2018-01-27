//
//  CashBoltter.h
//  happyLottery
//
//  Created by LYJ on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface CashBoltter : BaseModel

@property(nonatomic,strong)NSString * amounts;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *orderType;
@property(nonatomic,strong)NSString* remBalance;

@end
