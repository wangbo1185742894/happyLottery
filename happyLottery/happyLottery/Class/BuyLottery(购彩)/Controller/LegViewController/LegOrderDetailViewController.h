//
//  LegOrderDetailViewController.h
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OrderProfile.h"
NS_ASSUME_NONNULL_BEGIN

@interface LegOrderDetailViewController : BaseViewController

@property (nonatomic,copy) NSString *schemeNo;  //购彩

@property (nonatomic,strong)OrderProfile *orderPro;//追号

@property (nonatomic,copy) NSString *lotteryName;

@property(assign,nonatomic)SchemeType  schemetype;

@end

NS_ASSUME_NONNULL_END
