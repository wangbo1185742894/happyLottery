//
//  jcBetContent.h
//  Lottery
//
//  Created by onlymac on 2017/10/30.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCbetPlayTypes.h"
@interface jcBetContent : NSObject
@property (nonatomic,copy) NSString *matchId;
@property (nonatomic,copy) NSString *dan;
@property (nonatomic,copy) NSString *clash;
@property (nonatomic,copy) NSString *matchKey;
@property (nonatomic,strong)NSMutableArray <YCbetPlayTypes *>*betPlayTypes;
-(id)initWith:(NSDictionary*)dic;
@end
