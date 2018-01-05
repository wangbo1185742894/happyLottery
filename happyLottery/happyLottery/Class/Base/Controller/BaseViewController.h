//
//  BaseViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/1.
//  Copyright © 2017年 onlytechnology. All rights reserved.asd
//

#import <UIKit/UIKit.h>
#import "MemberManager.h"
#import "LotteryManager.h"
#import "FMDB.h"

@interface BaseViewController : UIViewController

@property (nonatomic,strong)MemberManager * memberMan;
@property (nonatomic,strong)LotteryManager * lotteryMan;

@property (nonatomic,strong) FMDatabase *fmdb;
@property(nonatomic,strong)User *curUser;
- (void) showPromptText: (NSString *) text hideAfterDelay: (NSTimeInterval) interval;
- (void) showLoadingViewWithText: (NSString *) text
                  withDetailText: (NSString *) sText;
- (void) showLoadingText: (NSString *) text;
- (void) showLoadingViewWithText: (NSString *) text
                  withDetailText: (NSString *) sText
                        autoHide: (NSTimeInterval) interval;
- (void) showLoadingViewWithText: (NSString *) text;
- (void) showPromptText: (NSString *) text;
- (void) hidePromptText;
- (void) hideLoadingView;


-(BOOL)isIphoneX;

-(void)navigationBackToLastPage;

-(void)needLogin;

@end
