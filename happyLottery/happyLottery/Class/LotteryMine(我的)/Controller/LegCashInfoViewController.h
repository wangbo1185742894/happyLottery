//
//  LegCashInfoViewController.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    CashInfoGoucai = 0,
    CashInfoZhuihao,
    CashInfoChongzhi,
    CashInfoPaijiang,
    CashInfoTixian,
    CashInfoYongJin,
}LegCashInfoType;

@interface LegCashInfoViewController : BaseViewController

@property (nonatomic , copy)NSString *vcTitle;

@property (nonatomic , copy)NSString *postboyId;

-(void)setMenuOffset:(LegCashInfoType)index;

@end
