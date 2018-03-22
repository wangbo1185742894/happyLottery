//
//  DltOpenResult.h
//  happyLottery
//
//  Created by 王博 on 2018/3/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"
#import "LotteryRound.h"

@interface DltOpenResult : BaseModel
@property(nonatomic,copy)NSString * _id;
@property(nonatomic,copy)NSString * openTime;
@property(nonatomic,copy)NSString * openResult;
@property(nonatomic,copy)NSString * distriStatus;
@property(nonatomic,copy)NSString * sellStatus;
@property(nonatomic,copy)NSString * stopTime;
@property(nonatomic,copy)NSString * winStatus;
@property(nonatomic,copy)NSString * issueNumber;
@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,copy)NSString * auditStatus;
@property(nonatomic,copy)NSString * editor;
@property(nonatomic,copy)NSString * startTime;
@property(nonatomic,copy)NSString * lotteryCode;
-(LotteryRound *)transport;
@end
