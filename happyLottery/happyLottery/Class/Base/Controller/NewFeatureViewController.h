//
//  NewFeatureViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"

@protocol NewFeatureViewDelegate
-(void)newFeatureSetRootVC;
@end
@interface NewFeatureViewController : BaseViewController
@property(weak,nonatomic) id<NewFeatureViewDelegate>delegate;

@end
