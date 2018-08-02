//
//  PersonCenterModel.h
//  happyLottery
//
//  Created by LYJ on 2018/5/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonCenterModel : BaseModel

/** 发单人卡号 */
@property(nonatomic,copy)NSString * cardCode;

/** 发单人昵称 */
@property(nonatomic,copy)NSString * nickName;

/** 发单人头像 */
@property(nonatomic,copy)NSString* headUrl;

/** 会员的标签 */
@property(nonatomic,copy)NSString * labelMap;

/** 该用户被关注次数 粉丝数*/
@property(nonatomic,copy)NSString* attentCount;

/** 累计发单中奖 */
@property(nonatomic,copy)NSString * totalInitiateBonus;

/** 近期发单中奖状态  0,1,1,1,0 表示, 0 表示未中奖*/
@property(nonatomic,copy)NSString * initiateStatus;

@property(nonatomic,copy)NSString *  label_urls;

@property(nonatomic,copy)NSString * mobile;


@end
