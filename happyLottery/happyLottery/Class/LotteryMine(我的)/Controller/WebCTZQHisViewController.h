//
//  WebShowViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/15.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcCTZQHisDelegate <JSExport>

-(void)exchangeToast:(NSString *)msg;

@end

@interface WebCTZQHisViewController : BaseViewController

@property(nonatomic,strong)NSURL *pageUrl;

@end
