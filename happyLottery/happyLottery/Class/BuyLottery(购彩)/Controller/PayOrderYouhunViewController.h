//
//  PayOrderYouhunViewController.h
//  happyLottery
//
//  Created by 王博 on 2018/1/18.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"

#import "Coupon.h"
@class PayOrderViewController;
@interface PayOrderYouhunViewController : BaseViewController
@property(weak,nonatomic)PayOrderViewController * payOrderVC;
@property(strong,nonatomic)NSMutableArray <Coupon *> *couponList;
@end
