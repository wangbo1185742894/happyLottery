//
//  PayOrderLegViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "SchemeCashPayment.h"
#import "PayTypeListCell.h"
#import "Coupon.h"
@interface PayOrderLegViewController : BaseViewController

@property(nonatomic,strong)SchemeCashPayment *cashPayMemt;

//所选优惠券
@property(nonatomic,strong)Coupon *curSelectCoupon;



@property(assign,nonatomic)SchemeType  schemetype;

@property(assign,nonatomic)BOOL isYouhua;


@end
