//
//  OrderTableViewCell.h
//  Lottery
//
//  Created by Yang on 15/6/22.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryScheme.h"
#import "OrderProfile.h"

@interface OrderTableViewCell : UITableViewCell{

    __weak IBOutlet UILabel *priceLb;
    __weak IBOutlet UILabel *timeLb;
    __weak IBOutlet UILabel *issueNumLb;
    __weak IBOutlet UILabel *lotteryTypeLb;
    __weak IBOutlet UIImageView *lotteryIconImgV;
    
    __weak IBOutlet UILabel *winningStateLb;
    
    __weak IBOutlet UILabel *prizeMoney;
    __weak IBOutlet UILabel *hintTitle;
    
    NSArray * orderWinningStateArray;
    
}
-(void)orderInforZhuihao:(OrderProfile *)order;

-(void)orderInfoShow:(LotteryScheme *)order;

-(void)refreshPrice:(BOOL)isInit :(BOOL)isOff :(LotteryScheme *)order ;


@end
