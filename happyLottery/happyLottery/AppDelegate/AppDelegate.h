//
//  AppDelegate.h
//  happyLottery
//
//  Created by 王博 on 2017/12/1.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, assign)BOOL versionFlag;
@property(nonatomic, retain)NSMutableDictionary   *Dic;
@property (assign, nonatomic)NSUserDefaults       *userDefaultes;
@property(nonatomic,strong)UINavigationController  *curNavVC;
+ (AppDelegate*) shareDelegate;
-(void) playSound;
- (void)showZhuihaoDetail:(NSString*) ordernumber;
@end

