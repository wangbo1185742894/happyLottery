//
//  AttentPersonModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface AttentPersonModel : BaseModel


/**
 * 会员卡号
 */
@property(strong,nonatomic)NSString * cardCode;

/**
 * 会员昵称
 */
@property(strong,nonatomic)NSString * nickname;

/**
 * 被关注的会员卡号
 */
@property(strong,nonatomic)NSString * attentCardCode;

/**
 * 被关注的会员昵称
 */
@property(strong,nonatomic)NSString * attentNickname;

/**
 * 被关注的头像地址
 */
@property(strong,nonatomic)NSString * attentHeadUrl;

/**
 * 渠道号
 */
@property(strong,nonatomic)NSString * channelCode;

/**
 * 平台号
 */
@property(strong,nonatomic)NSString * platformCode;

@property(strong,nonatomic)NSString *  trRecentWon;

/**
 * 关注的类型
 */
@property(strong,nonatomic)NSString *  attentType;

@property(strong,nonatomic)NSString *  mobile;
@end
