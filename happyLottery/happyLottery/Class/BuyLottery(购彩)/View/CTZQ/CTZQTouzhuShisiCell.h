//
//  CTZQTouzhuShisiCell.h
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTZQTouzhuRenjiuCellRefreshDelegate ;



@interface CTZQTouzhuShisiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labHomeName;
@property (weak, nonatomic) IBOutlet UILabel *labGuestName;
@property (weak, nonatomic) IBOutlet UIButton *btnWin;

@property (weak, nonatomic) IBOutlet UIButton *btnDraw;
@property (weak, nonatomic) IBOutlet UIButton *btnLose;

@property(nonatomic,strong) CTZQBet *cBet;

@property(weak,nonatomic)id<CTZQTouzhuRenjiuCellRefreshDelegate> delegate;
-(void)reloadData;
@end
