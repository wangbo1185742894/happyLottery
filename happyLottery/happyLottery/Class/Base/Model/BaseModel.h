//
//  BaseModel.h
//  happyLottery
//
//  Created by 王博 on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject


-(id)initWith:(NSDictionary*)dic;

+(NSString *)getLotteryByName:(NSString *)lottery;
@end
