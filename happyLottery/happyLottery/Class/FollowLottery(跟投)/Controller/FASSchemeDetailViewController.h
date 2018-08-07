//
//  FASSchemeDetailViewController.h
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"

@interface FASSchemeDetailViewController : BaseViewController

@property (nonatomic,copy) NSString *schemeNo;
                                                                            //BUY_INITIATE
@property (nonatomic,copy) NSString *schemeType;  //BUY_INITIATE  BUY_FOLLOW

@property (nonatomic,copy) NSString *schemeFromView;

@property(nonatomic,assign)BOOL h5Init;

@end
