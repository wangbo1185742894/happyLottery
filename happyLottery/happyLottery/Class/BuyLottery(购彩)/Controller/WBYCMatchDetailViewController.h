//
//  WBYCMatchDetailViewController.h
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BaseViewController.h"
#import "JczqShortcutModel.h"
#import "JCYCTransaction.h"
#import "BaseTransaction.h"

@interface WBYCMatchDetailViewController : BaseViewController

@property (nonatomic,strong)JczqShortcutModel * model;
@property(nonatomic,strong)NSString *curPlayType;
@property(assign,nonatomic)BOOL isFromYC;
@property(assign,nonatomic)BOOL isFromDGP;
@end
