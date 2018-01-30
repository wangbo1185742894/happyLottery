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
- (void)telPhone;
-(void)goToLogin;
-(void)hiddenFooter:(BOOL )isHiden;
@end

@interface DiscoverViewController : BaseViewController


@property(nonatomic,strong)NSString *pageUrl;
//-(void)SharingLinks:(NSString *)code;
//-(void)goToJczq;
//-(NSString *)getCardCode;
//-(void)goToLogin;

@end
