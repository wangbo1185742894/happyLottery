//
//  JcPairingOptions.h
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JcPairingOptions : NSObject
@property (nonatomic,strong)NSString *options,*sp,*playType;
-(id)initWith:(NSDictionary*)dic;
@end
