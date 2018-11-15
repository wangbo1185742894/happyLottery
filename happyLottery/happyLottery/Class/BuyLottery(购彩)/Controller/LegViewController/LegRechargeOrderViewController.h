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
#import "PostboyAccountModel.h"


@interface LegRechargeOrderViewController : BaseViewController

//订单金额
@property (nonatomic , copy) NSString *orderCost;

@property(nonatomic,strong)SchemeCashPayment *cashPayMemt;

@property(assign,nonatomic)SchemeType  schemetype;

@property (nonatomic , copy) NSString *schemeNo;

@property(assign,nonatomic)BOOL isYouhua;

@property (nonatomic , copy) NSString *lotteryName;//彩种名称

@property(nonatomic,strong)PostboyAccountModel *postModel;

@property(nonatomic,strong)NSString *schemeSource;

@end
