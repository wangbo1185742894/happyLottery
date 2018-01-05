//
//  YuCeScheme.h
//  Lottery
//
//  Created by onlymac on 2017/10/25.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "jcBetContent.h"
@interface YuCeScheme : NSObject
@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *earningsType;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,copy) NSString *recommendCount;
@property (nonatomic,copy) NSString *dealLine;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *lottery;
@property (nonatomic,copy) NSString *lastModifyTime;
@property (nonatomic,copy) NSString *predictIndex;
@property (nonatomic,copy) NSString *recSchemeNo;
@property (nonatomic,copy) NSString *recMatchKey;
@property (nonatomic,copy) NSString *earnings;
@property (nonatomic,copy) NSString *passTypes;
@property(nonatomic,strong)NSMutableArray <jcBetContent*> *jcBetContent;
-(id)initWith:(NSDictionary*)dic;
@end
