//
//  PostboyAccountModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/18.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface PostboyAccountModel : BaseModel

/** 小哥id*/
@property(nonatomic,strong)NSString *  _id;

/** 小哥名称*/
@property(nonatomic,strong)NSString * postboyName;

 /**  余额 */
@property(nonatomic,strong)NSString * balance;

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

/** 对应会员卡号 账号*/
@property(nonatomic,strong)NSString * cardCode;

/** 对应会员总余额 */
@property(nonatomic,strong)NSString * totalBalance;

/** 对应会员可提现余额 */
@property(nonatomic,strong)NSString * cashBalance;


/** 对应会员不可提现金额 */
@property(nonatomic,strong)NSString * notCash;

@property(nonatomic,assign)BOOL  isSelect;

@end

