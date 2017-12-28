//
//  Coupon.h
//  happyLottery
//
//  Created by LYJ on 2017/12/28.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface Coupon : BaseModel

@property(nonatomic,strong)NSString * couponCode;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *quota;
@property(nonatomic,strong)NSString* deduction;
@property(nonatomic,strong)NSString * invalidTime;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *couponSource;
@property(nonatomic,strong)NSString* useTime;
@property(nonatomic,strong)NSString * subOrderNo;
@property(nonatomic,strong)NSString *remark;


@end
