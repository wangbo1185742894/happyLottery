//
//  AppDelegate.h
//  happyLottery
//
//  Created by 王博 on 2017/12/1.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTZQMatch.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(assign,nonatomic)NSInteger  betlistcount;
@property(nonatomic, assign)BOOL versionFlag;
@property(nonatomic, retain)NSMutableDictionary   *ZHDic;
@property(nonatomic, retain)NSMutableDictionary   *Dic;
@property (assign, nonatomic)NSUserDefaults       *userDefaultes;
@property(nonatomic,strong)UINavigationController  *curNavVC;
@property(assign,nonatomic)BOOL iswinStop;

+ (AppDelegate*) shareDelegate;
-(void) playSound;
- (void)showZhuihaoDetail:(NSString*) ordernumber;
- (void)showZhuihaoDetailWin:(NSString*) ordernumber;
-(void)goToYunshiWithInfo:(NSString *)pageCode;
- (void)setGroupView;
-(void)setAppstoreRootVC;
-(void)setNomalRootVC;
@end

