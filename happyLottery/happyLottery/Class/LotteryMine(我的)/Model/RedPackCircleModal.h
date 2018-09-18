//
//  RedPackCircleModal.h
//  happyLottery
//
//  Created by LYJ on 2018/9/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedPackCircleModal : BaseModel

/** 卡号 */
@property(nonatomic,copy) NSString *cardCode;

/** 手机号 */
@property(nonatomic,copy) NSString *mobile;

/** 昵称 */
@property(nonatomic,copy) NSString *nickName;

/** 消费总金额 */
@property(nonatomic,copy) NSString *totalCost;

/** 消费次数 */
@property(nonatomic,copy) NSString *totalSubCount;

@property(nonatomic,assign)BOOL isSelect;

@property(nonatomic,copy)NSString * headUrl;


@end
