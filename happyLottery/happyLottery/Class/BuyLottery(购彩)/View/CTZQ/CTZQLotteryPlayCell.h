//
//  CTZQLotteryPlayCell.h
//  Lottery
//
//  Created by only on 16/3/24.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTZQMatch.h"

@class CTZQLotteryPlayCell;
@protocol CTZQLotteryPlayCellDelegate <NSObject>

- (void)CTZQLPCell:(CTZQLotteryPlayCell *)cell DidSelected:(CTZQWinResultType)selectedResult;

@end

@interface CTZQLotteryPlayCell : UITableViewCell

@property (nonatomic, weak) id<CTZQLotteryPlayCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *matchNumStr;
@property (weak, nonatomic) IBOutlet UILabel *matchLegueNum;
@property (weak, nonatomic) IBOutlet UILabel *matchBeginTime;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


@property (weak, nonatomic) IBOutlet UIView *matchInfo;
@property (weak, nonatomic) IBOutlet UILabel *homeName;
@property (weak, nonatomic) IBOutlet UILabel *guestName;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArr;

@property (weak, nonatomic) IBOutlet UIButton *win;
@property (weak, nonatomic) IBOutlet UIButton *draw;
@property (weak, nonatomic) IBOutlet UIButton *lose;


@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UILabel *homeRank;
@property (weak, nonatomic) IBOutlet UILabel *guestRank;
@property (weak, nonatomic) IBOutlet UILabel *counterInfo;
@property (weak, nonatomic) IBOutlet UIButton *moreMoreBtn;

@property (nonatomic , strong)CTZQMatch *match;


- (void)updateWithMatch:(CTZQMatch *)match;
@end


