//
//  JcForecastOptions.h
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JcForecastOptions : NSObject
@property (nonatomic,strong)NSString *options,*sp ,* forecast;
-(id)initWith:(NSDictionary*)dic;
@end
