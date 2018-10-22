//
//  LegWordModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/18.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface LegWordModel : BaseModel

@property(nonatomic,strong)NSString *  _id;

/** 小哥名称*/
@property(nonatomic,strong)NSString * legName;

/** 跑腿费 */
@property(nonatomic,strong)NSString * cost;

/** 小哥微信号*/
@property(nonatomic,strong)NSString * wechatId;

 /** 小哥电话号*/
@property(nonatomic,strong)NSString * mobile;

/** 小哥支付宝号*/
@property(nonatomic,strong)NSString * alipay;

/** 是否在线*/
@property(nonatomic,strong)NSString * overline;

/** 是否启用*/
@property(nonatomic,strong)NSString * enabled;

@property(nonatomic,assign)BOOL  isSelect;

@end

@interface LotteryShopDto : BaseModel

@property(nonatomic,strong)NSString * _id;

/** 门店名称*/
@property(nonatomic,strong)NSString * shopName;

@end
