//
//  User.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "MyAgentInfoModel.h"

//{
//    balance = 999996; *
//    bankBinding = 0; *
//    cardCode = 10000001;
//    channelCode = TBZ;
//    couponCount = 0;
//    id = 1;
//    lockStatus = "UN_LOCK";
//    memberType = "FREEDOM_PERSON";
//    mobile = 15929443992;
//    notCash = 0;
//    parentId = 0;
//    paypwdSetting = 0;
//    registerTime = 1513315447000;
//    score = 0;
//    sendBalance = 0;
//    shareCode = E13608C5;
//    whitelist = 1;
//}

typedef enum {
    PayVerifyTypeAlways = 1,
    PayVerifyTypeAlwaysNo,
    PayVerifyTypeLessThanOneHundred,
    PayVerifyTypeLessThanFiveHundred,
    PayVerifyTypeLessThanThousand,
    
}PayVerifyType;


@interface User : BaseModel

@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,assign)BOOL bankBinding;
@property(nonatomic,assign)BOOL paypwdSetting;
@property(nonatomic,assign)int  payPWDThreshold;
@property(nonatomic,strong)NSString * loginPwd;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *channelName;
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *headUrl;
@property(nonatomic,strong)NSString * sendBalance;
@property(nonatomic,strong)NSString * cardCode;
@property(nonatomic,strong)NSString * mobile;
@property(nonatomic,strong)NSString *shareCode;
@property(nonatomic,strong)NSString *lockStatus;

/**
 CIRCLE_MASTER("圈主"), CIRCLE_PERSON("圈民"), FREEDOM_PERSON("自由人");
 */
@property(nonatomic,strong)NSString * memberType;
@property(nonatomic,strong)NSString * balance;  //余额
@property(nonatomic,strong)NSString * notCash;  //不可提现的
@property(nonatomic,strong)NSString * whitelist;
@property(nonatomic,strong)NSString * channelCode;
@property(nonatomic,strong)NSString * couponCount;
@property(nonatomic,strong)NSString * registerTime;
@property(nonatomic,strong)NSString * score;
// UN_LOCK("未锁定"), LOCK("锁定");
@property(nonatomic,strong)NSString * parentId;

@property(nonatomic,strong)NSString *totalBanlece;

/** 可提现余额 */
@property(nonatomic,strong)NSString *postboyBalance;

/** 不可提现金额 */
@property(nonatomic,strong)NSString *postboyNotCash;

@property (nonatomic, assign) PayVerifyType payVerifyType;

@property(nonatomic,strong)MyAgentInfoModel *agentInfo;

-(NSString *)getShareUrl;
@end

