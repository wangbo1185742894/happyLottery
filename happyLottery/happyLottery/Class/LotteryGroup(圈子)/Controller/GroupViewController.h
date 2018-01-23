//
//  GroupViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcGourpDelegate <JSExport>
- (void)telPhone;
@end

@interface GroupViewController : BaseViewController

@end
