//
//  PayOrderViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "SchemeCashPayment.h"
#import "PayTypeListCell.h"
@interface PayOrderViewController : BaseViewController
@property(nonatomic,strong)SchemeCashPayment *cashPayMemt;
@end
