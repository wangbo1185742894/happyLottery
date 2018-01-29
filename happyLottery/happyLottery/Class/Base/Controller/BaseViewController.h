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
#import "AppDelegate.h"




@interface BaseViewController : UIViewController
@property (nonatomic ,strong)NSString *viewControllerNo;
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

-(void)actionTelMe;

-(void)navigationBackToLastPage;

-(void)needLogin;

-(void)needLoginCompletion:(void (^ __nullable)(void))completion;

-(UIBarButtonItem *)creatBarItem:(NSString *)title icon:(NSString *)imgName andFrame:(CGRect)frame andAction:(SEL)action;

-(id)transFomatJson:(NSString *)strJson;

- (void)checkUpdateNetWork;
- (BOOL)stringContainsEmoji:(NSString *)string ;
- (BOOL)hasEmoji:(NSString*)string;
-(BOOL)isNineKeyBoard:(NSString *)string;
-(void)upLoadClientInfo;

- (BOOL)isValidateName:(NSString *)name;
- (BOOL)isValidateRealName:(NSString *)name;


@end
