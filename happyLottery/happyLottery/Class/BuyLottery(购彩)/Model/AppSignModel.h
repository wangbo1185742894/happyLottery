//
//  AppSignModel.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/17.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface AppSignModel : BaseModel

/** 描述*/

@property (strong,nonatomic) NSString* describe;

/** 图片 */

@property (strong,nonatomic) NSString* imageUrl;

/** 点击跳转URL*/

@property (strong,nonatomic) NSString* skipUrl;

/** 是否启用 */

@property (strong,nonatomic) NSString* enabled;
@end
