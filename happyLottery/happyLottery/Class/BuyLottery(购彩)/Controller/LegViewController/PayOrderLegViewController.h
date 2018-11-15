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


@property(nonatomic,copy)NSString *lotteryName; //彩种名称

@property(assign,nonatomic)double subscribed;

//所选优惠券
@property(nonatomic,strong)Coupon *curSelectCoupon;

//自购, 合买, 追号, 推荐, 发单, 跟单
@property(assign,nonatomic)SchemeType  schemetype;

@property(assign,nonatomic)BOOL isYouhua;

@property (nonatomic,copy)NSString *schemeNo;  //未支付订单传递方案号

@property (nonatomic,copy)NSString *postBoyId;  //未支付订单已选小哥id

@property (nonatomic,strong)NSArray *zhuiArray;  //追号

@property (nonatomic,strong)NSDictionary *diction;  //跟单传递值

@property (nonatomic,strong)NSArray *contentArray;  //奖金优化

@end
