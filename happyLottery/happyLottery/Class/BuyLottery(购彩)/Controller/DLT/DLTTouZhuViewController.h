//
//  TouZhuViewController.h
//  Lottery
//
//  Created by YanYan on 6/10/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "BaseViewController.h"
#import "LotteryTransaction.h"
#import "BetsListPopViewCell.h"
#import "LotteryManager.h"
#import "User.h"
#import "MemberManager.h"
@protocol TouZhuViewControllerDelegate <NSObject>
@optional
- (void) betTransactionUpdated;
- (void) addRandomBet;
- (void) betzhuihaodelegate;    
@end

@interface DLTTouZhuViewController : BaseViewController <BetsListPopViewCellDelegate, UITableViewDataSource, UITableViewDelegate, LotteryManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource,MemberManagerDelegate>

@property (nonatomic, weak) id<TouZhuViewControllerDelegate> delegate;
@property (nonatomic, strong) Lottery *lottery;
// dlt  x115
@property (nonatomic, strong) LotteryTransaction *transaction;
//  竞彩

@property (nonatomic, readwrite) BOOL FLAG;//zwl
@property (nonatomic , readwrite) int resourceflag;
//添加controller标记
@property (nonatomic,strong) NSString *controllerId;
@property (nonatomic, readwrite) NSUInteger issue;
@property (nonatomic, readwrite) NSUInteger multiple;
@property(nonatomic,strong)NSString *rand;
@property(nonatomic,strong)NSString *isOmit;
@property (nonatomic, strong) NSTimer *timerForcurRound;
@end
