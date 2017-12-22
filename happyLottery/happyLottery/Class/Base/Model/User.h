//
//  User.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

typedef enum {
    
    PayVerifyTypeAlways =1,
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
// CIRCLE_MASTER("圈主"), CIRCLE_PERSON("圈民"), FREEDOM_PERSON("自由人");
@property(nonatomic,assign)NSString * memberType;
@property(nonatomic,strong)NSString * balance;
@property(nonatomic,strong)NSString * notCash;
@property(nonatomic,strong)NSString * whitelist;
@property(nonatomic,strong)NSString * channelCode;
@property(nonatomic,strong)NSString * couponCount;
@property(nonatomic,strong)NSString * registerTime;
@property(nonatomic,strong)NSString * score;
@property(nonatomic,strong)NSString * parentId;
@property (nonatomic, strong) NSNumber *payVerifyType;

@end

