//
//  IntegralMallViewController.h
//  happyLottery
//
//  Created by LYJ on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcIntegralDelegate <JSExport>

-(void)exchangeToast:(NSString *)msg;

@end

@interface IntegralMallViewController : BaseViewController

@end
