//
//  WebViewController.h
//  Lottery
//
//  Created by 王博 on 2017/6/28.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BaseViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol WebViewObjcDelegate <JSExport>
-(void)goCathectic:(NSString *)lotteryCode;
-(void)exchangeToast:(NSString *)msg;
-(void)SharingLinks:(NSString *)code;
-(NSString *)getCardCode;
@end

@interface WebViewController : BaseViewController

@property(strong,nonatomic)NSString *pageUrl;
@property(strong,nonatomic)NSString *type;
@property (strong,nonatomic)NSString *title;
@property(strong,nonatomic)NSString *htmlName;

@end
