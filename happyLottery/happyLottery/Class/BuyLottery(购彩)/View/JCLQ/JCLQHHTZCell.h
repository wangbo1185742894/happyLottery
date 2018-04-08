//
//  JCLQHHTZCell.h
//  Lottery
//
//  Created by 王博 on 16/8/16.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "BaseCell.h"

@interface JCLQHHTZCell : BaseCell
@property (weak, nonatomic) IBOutlet UILabel *labHHTZGameName;
@property (weak, nonatomic) IBOutlet UILabel *labHHTZGameDay;
@property (weak, nonatomic) IBOutlet UILabel *labHHTZGameTime;
@property (weak, nonatomic) IBOutlet UILabel *labHomeAndGoust;
@property (weak, nonatomic) IBOutlet UIButton *btnShowAll;

@property (weak, nonatomic) IBOutlet UIButton *btnGuestWinNo;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeWinNo;
@property (weak, nonatomic) IBOutlet UIButton *btnGuestWinR;
@property (weak, nonatomic) IBOutlet UIImageView *imgDanguan;

@property (weak, nonatomic) IBOutlet UIButton *btnHomeWinR;

-(void)updataSelected;

@end
 