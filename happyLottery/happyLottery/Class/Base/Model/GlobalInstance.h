//
//  GlobalInstance.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface GlobalInstance : NSObject

@property(nonatomic,assign)NSTimeInterval serverTime;
@property(nonatomic,strong)User *curUser;
@property (nonatomic,strong)NSString * homeUrl;
@property (nonatomic,strong)NSString * lotteryUrl;
@property(nonatomic,assign)BOOL isFromTogeVCToThis;
+ (GlobalInstance *) instance;
@end
