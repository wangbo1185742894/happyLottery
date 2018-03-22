//
//  CTZQOrderProfile.h
//  Lottery
//
//  Created by LC on 16/5/18.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "OrderProfile.h"


//"betContent": "3,1,0,1,0,1,1,1,0,*,*,*,*,*",
//"betSource": 2,
//"cardCode": 80002554,
//"cost": 2,
//"createTime": 1463538722000,
//"id": 23,
//"issueNumber": "16079",
//"lottery": "RJC",
//"multiple": 1,
//"payStatus": true,
//"payTime": 1463538739000,
//"schemeId": "RJC20160518103202100004",
//"units": 1,
//"winningStatus": "WAIT_LOTTERY"

@interface CTZQOrderProfile : OrderProfile
@property (nonatomic, strong)NSString *betContent;
//@property (nonatomic, strong)NSString *betSource;
@property (nonatomic, strong)NSString *cardCode;
@property (nonatomic, strong)NSString *cost;
//@property (nonatomic, strong)NSString *createTime;
@property (nonatomic, strong)NSString *id;
//@property (nonatomic, strong)NSString *lottery;
//@property (nonatomic, strong)NSString *multiple;
//@property (nonatomic, strong)NSString *payStatus;
@property (nonatomic, strong)NSString *schemeId;
//@property (nonatomic, strong)NSString *units;
//@property (nonatomic, strong)NSString *winningStatus;
@property (nonatomic, strong)NSString *payTime;
//@property (nonatomic, strong)NSString *issueNumber;

@property (nonatomic, strong)NSString* descFangAnToAppear;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
