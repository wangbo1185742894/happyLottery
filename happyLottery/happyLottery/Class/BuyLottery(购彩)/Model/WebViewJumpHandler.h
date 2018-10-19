//
//  WebViewJumpHandler.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/7.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol WebViewJumpHandlerDelegate <JSExport>

-(void)goToJczq;
-(void)SharingLinks;
- (void)telPhone;
-(void)goToLogin;
-(void)exchangeToast:(NSString *)msg;
-(NSString *)getCardCode;
-(void)goCathectic:(NSString *)lotteryCode :(NSString *)cardCode;
-(void)hiddenFooter:(BOOL )isHiden;
- (void)openWX;
@end

@interface WebViewJumpHandler : NSObject
-(id)initWithCurVC:(UIViewController *)vc;
@end
