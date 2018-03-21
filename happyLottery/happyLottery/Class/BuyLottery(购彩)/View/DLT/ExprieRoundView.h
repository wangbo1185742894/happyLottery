//
//  ExprieRoundView.h
//  Lottery
//
//  Created by Yang on 15/6/18.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lottery.h"
#import "DltOpenResult.h"

#define ExpireTableViewCellH  24

@interface ExprieRoundView : UITableView<UITableViewDataSource,UITableViewDelegate>{

   
}

@property(nonatomic,strong) NSArray * rounds;
@property (nonatomic , strong) Lottery * lottery;


- (void)refreshWithProfileID:(NSInteger )profileID;

@end
