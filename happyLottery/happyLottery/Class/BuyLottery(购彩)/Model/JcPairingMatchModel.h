//
//  jcPairingMatchDto.h
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JcPairingOptions.h"

@interface JcPairingMatchModel : NSObject


@property(nonatomic,strong)NSString * matchKey, * lineId, *homeName ,* guestName ,* dealLine, * handicap;
@property(nonatomic,strong)NSMutableArray <JcPairingOptions *> * options;

-(id)initWith:(NSDictionary*)dic;
@end
