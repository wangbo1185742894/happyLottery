//
//  RedPacket.h
//  happyLottery
//
//  Created by LYJ on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface RedPacket : BaseModel

@property(nonatomic,strong)NSString * _id;
@property(nonatomic,strong)NSString *cardCode;
@property(nonatomic,strong)NSString *startValidTime;
@property(nonatomic,strong)NSString* endValidTime;
@property(nonatomic,strong)NSString * redPacketStatus;
@property(nonatomic,strong)NSString *_description;
@property(nonatomic,strong)NSString *redPacketContent;
@property(nonatomic,strong)NSString* randomCost;
@property(nonatomic,strong)NSString * activityId;
@property(nonatomic,strong)NSString *redPacketType;
@property(nonatomic,strong)NSString *redPacketChannel;
@property(nonatomic,strong)NSString * openTime;
@property(nonatomic,strong)NSString * useTime;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *activityName;


@end
