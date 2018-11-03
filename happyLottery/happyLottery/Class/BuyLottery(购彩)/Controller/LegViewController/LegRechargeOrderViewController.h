//
//  LegRechargeOrderViewController.h
//  happyLottery
//
//  Created by LYJ on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "ChannelModel.h"
#import "PayTypeListCell.h"
#import "SchemeCashPayment.h"


@interface LegRechargeOrderViewController : BaseViewController

//订单金额
@property (nonatomic , copy) NSString *orderCost;

@property (nonatomic , copy) NSString *legYuE;

@property (nonatomic , copy) NSString *legId;

@property(nonatomic,strong)SchemeCashPayment *cashPayMemt;

@property(assign,nonatomic)SchemeType  schemetype;

@property(assign,nonatomic)BOOL isYouhua;

@end
