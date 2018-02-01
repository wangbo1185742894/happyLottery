//
//  HomeJumpViewController.h
//  Lottery
//
//  Created by LC on 16/6/1.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "BaseViewController.h"
#import "ADSModel.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSJumpDelegate <JSExport>

-(void)goToJczq;

-(void)goToLogin;
-(void)exchangeToast:(NSString *)msg;

@end

@interface HomeJumpViewController : BaseViewController
@property(strong , nonatomic)ADSModel *infoModel;
@property(assign,nonatomic)BOOL isNeedBack;
@end
