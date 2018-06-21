//
//  ChannelModel.h
//  happyLottery
//
//  Created by 王博 on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface ChannelModel : BaseModel

@property(nonatomic,copy)NSString * rechargeDesc;
@property(nonatomic,copy)NSString * channel;
@property(nonatomic,copy)NSString * descValue;
@property(nonatomic,copy)NSString * channelValue;
@property(nonatomic,copy)NSString *channelIcon;
@property(nonatomic,copy)NSString *channelTitle;
@property(nonatomic,assign)BOOL isSelect;

@end


@interface RechargeModel : BaseModel

@property(nonatomic,copy)NSString *handsel;
@property(nonatomic,copy)NSString *recharge;
@property(nonatomic,assign)BOOL isSelect;

@end
