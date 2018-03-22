//
//  LotteryInstructionViewController.h
//  Lottery
//
//  Created by YanYan on 6/7/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "BaseViewController.h"

@interface LotteryInstructionViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

-(void)toDetailVC:(NSInteger)index andTarget:(UIViewController*)targetVC;

@end
