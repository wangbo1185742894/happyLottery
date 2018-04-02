//
//  ExprieRoundViewCell.h
//  Lottery
//
//  Created by only on 16/1/19.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryRound.h"
#import "DltOpenResult.h"

@interface ExprieRoundViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *qiHaoLa;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ballArr;

@property (assign, nonatomic) BOOL isX115;

-(void)roundDesInfo:(DltOpenResult *)round andProfileID:(NSInteger )profileID;
@end
