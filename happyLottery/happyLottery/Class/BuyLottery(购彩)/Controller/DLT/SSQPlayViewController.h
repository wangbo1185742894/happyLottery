//
//  LotteryPlayViewController.h
//  Lottery
//
//  Created by AMP on 5/23/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "BaseViewController.h"
#import "LotteryTransaction.h"
#import "WebCTZQHisViewController.h"
@class Lottery;

@interface SSQPlayViewController : BaseViewController
@property(nonatomic,assign)BOOL isReBuy;
@property(nonatomic,strong)NSArray *selectedNumber;
@property (nonatomic, strong) Lottery *lottery;
@property (nonatomic,copy) NSString *tempResource;
@property (nonatomic,strong) LotteryTransaction *lotteryTransaction;
@property(nonatomic,strong)NSString *isOmit;
@property(nonatomic,strong)NSString *rebuyTitle;

- (void)loadConentView:(float)curY;
@end
