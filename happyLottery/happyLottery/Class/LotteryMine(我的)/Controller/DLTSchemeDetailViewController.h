//
//  SchemeDetailViewController.h
//  happyLottery
//
//  Created by 王博 on 2018/1/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"

@interface DLTSchemeDetailViewController : BaseViewController
@property(nonatomic,strong)NSString *imageName;
@property(nonatomic,strong)NSString *schemeNO;
@property (nonatomic,strong) NSString *deadLineTime;
@property (nonatomic,strong) LotteryTransaction *lotteryTransaction;
@end
