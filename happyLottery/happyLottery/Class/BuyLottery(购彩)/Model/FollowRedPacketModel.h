//
//  FollowRedPacketModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/20.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RedPacketGainModel.h"


@interface FollowRedPacketModel : RedPacketGainModel
@property (nonatomic,copy)NSString * trRedPacketStatus;
@property (nonatomic,copy)NSString * trRedPacketType;
@property (nonatomic,copy)NSString * trRedPacketChannel;
@property (nonatomic,copy)NSString * headUrl;
@property (nonatomic,copy)NSString * nikeName;
@property (nonatomic,copy)NSString * mobile;
@property(nonatomic,strong)NSString * openStatus;
@end
