//
//  YCbetPlayTypes.h
//  Lottery
//
//  Created by onlymac on 2017/11/2.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCbetPlayTypes : NSObject
@property (nonatomic,copy) NSString *playType;
@property (nonatomic,strong)NSMutableArray *options;
-(id)initWith:(NSDictionary*)dic;
@end
