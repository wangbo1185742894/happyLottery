//
//  AgentMemberModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"
#import "Enum.h"

@interface AgentMemberModel : BaseModel

/** 圈子ID*/
@property(nonatomic,copy)NSString * agentId;

/** 圈民卡号*/
@property(nonatomic,copy)NSString * cardCode;

/** 圈民手机号 */
@property(nonatomic,copy)NSString * mobile;

/** 圈民昵称 */
@property(nonatomic,copy)NSString * nickname;

/** 圈民头像 */
@property(nonatomic,copy)NSString * headUrl;

/** 圈民类型 */
@property(nonatomic,copy)NSString * memberType;
@property(nonatomic,copy)NSString * createTime;

@end
