//
//  DiscoverViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcDelegate <JSExport>

-(void)SharingLinks:(NSString *)code;
-(void)goToJczq;
-(NSString *)getCardCode;
-(void)goToLogin;


@end

@interface DiscoverViewController : BaseViewController

//-(void)SharingLinks:(NSString *)code;
//-(void)goToJczq;
//-(NSString *)getCardCode;
//-(void)goToLogin;

@end
