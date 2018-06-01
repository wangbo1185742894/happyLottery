//
//  AgentManager.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "Manager.h"

@protocol AgentManagerDelegate
@optional
-(void )agentApplydelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg;

@end

@interface AgentManager : Manager
@property(weak,nonatomic)id<AgentManagerDelegate> delegate;
-(void )agentApply:(NSDictionary *)param;
@end
