//
//  LotteryAreaViewController.h
//  happyLottery
//
//  Created by LYJ on 2018/4/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol LotterySelectViewObjcDelegate <JSExport>
-(void)goCathectic:(NSString *)lotteryName;
-(void)exchangeToast:(NSString *)msg;
@end

@interface LotteryAreaViewController : BaseViewController

@property (nonatomic,strong) NSArray *lotteryDS;

@end
