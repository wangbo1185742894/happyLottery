//
//  BiFenZhiboModel.h
//  Lottery
//
//  Created by 关阿龙 on 17/3/3.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiFenZhiboModel : NSObject

@property(strong,nonatomic)NSString *itemName,*lottery,*sortVal,*url;

-(id)initWithDic:(NSDictionary *)dic;
@end
