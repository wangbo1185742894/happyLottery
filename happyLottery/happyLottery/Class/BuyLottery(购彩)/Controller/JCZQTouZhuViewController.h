//
//  JCZQTouZhuViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "JCZQTranscation.h"
#import "SchemeCashPayment.h"
#import "LoginViewController.h"
@interface JCZQTouZhuViewController : BaseViewController
@property(nonatomic,assign)SchemeType fromSchemeType;
@property(nonatomic,strong)JCZQTranscation *transction;

@end
