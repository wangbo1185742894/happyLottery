//
//  QmitModel.h
//  Lottery
//
//  Created by only on 16/11/10.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QmitModel : NSObject
@property (nonatomic, copy) NSString *avgNumbs;
@property (nonatomic, copy) NSString *beforeIssue;
@property (nonatomic, copy) NSString *beforeResult;
@property (nonatomic, copy) NSString *curDayOut;
@property (nonatomic, copy) NSString *currentIssue;
@property (nonatomic, copy) NSString *daysNoOut;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *isRecCode;
@property (nonatomic, copy) NSString *ltype;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *preOutProb;
@property (nonatomic, copy) NSString *times;

@property(nonatomic,strong)NSString *isSelect; // 0 /1

-(id)initWith:(NSDictionary*)dic;


@end
