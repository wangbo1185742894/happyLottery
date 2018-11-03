//
//  PayOrderLegViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "PayTypeListCell.h"
#import "JCLQTransaction.h"
#import "Coupon.h"

@interface PayOrderLegViewController : BaseViewController

@property(nonatomic,strong)BaseTransaction *basetransction;


@property(nonatomic,copy)NSString *lotteryName;

@property(assign,nonatomic)double subscribed;

//所选优惠券
@property(nonatomic,strong)Coupon *curSelectCoupon;

//自购, 合买, 追号, 推荐, 发单, 跟单
@property(assign,nonatomic)SchemeType  schemetype;

@property(assign,nonatomic)BOOL isYouhua;


@end
