//
//  X115LimitNum.h
//  Lottery
//
//  Created by 王博 on 2017/12/19.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface X115LimitNum : NSObject

@property(nonatomic,copy)NSString * _id;
@property(nonatomic,copy)NSString *status;

@property(nonatomic,copy)NSArray *limitNum;
@property(nonatomic,copy)NSString *version;
@property(nonatomic,copy)NSString *playType;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *trPlayType;
-(id)initWithDic:(NSDictionary *)dic;

@end
