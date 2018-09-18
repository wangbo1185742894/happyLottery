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
#import "Coupon.h"
@interface PayOrderViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *labBack;
@property(nonatomic,strong)SchemeCashPayment *cashPayMemt;
@property(nonatomic,strong)Coupon *curSelectCoupon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgDisRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgDisLeft;
@property (weak, nonatomic) IBOutlet UILabel *labQiangdanSucc;
@property(assign,nonatomic)SchemeType  schemetype;
@property (weak, nonatomic) IBOutlet UILabel *labQiangdanBegin;
@property(assign,nonatomic)BOOL isYouhua;
@property (weak, nonatomic) IBOutlet UIButton *btnCom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disComBtn;

@end
