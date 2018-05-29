//
//  BuyLotteryViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "netWorkHelper.h"
#import "VersionUpdatingPopView.h"
#import "JCLQPlayController.h"
#import "MyPostSchemeViewController.h"
#import "MyAttendViewController.h"
#import "ADSModel.h"

@interface BuyLotteryViewController : BaseViewController

-(void)adsImgViewClick:(ADSModel *)itemIndex navigation:(UINavigationController *)navgC;

@end
