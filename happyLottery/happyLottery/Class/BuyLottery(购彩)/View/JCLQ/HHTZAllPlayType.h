//
//  HHTZAllPlayType.h
//  Lottery
//
//  Created by 王博 on 16/8/16.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLQMatchModel.h"
#import "BaseCell.h"
#import "JCLQHHTZCell.h"

@interface HHTZAllPlayType : UIView
@property (weak, nonatomic) IBOutlet UILabel *labMatchName;
@property (weak, nonatomic) IBOutlet UIButton *btnGuestWinNO;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeWinNO;
@property (weak, nonatomic) IBOutlet UIButton *btnGuestWinR;
@property (weak, nonatomic) IBOutlet UIButton *btnHomeWinR;
@property (weak, nonatomic) IBOutlet UIButton *btnDXFDY;
@property (weak, nonatomic) IBOutlet UIButton *btnDXFXY;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCGuest1_5;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCGuest6_10;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCGuest11_15;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCGuest16_20;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCGuest21_25;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCGuest26_;

@property (weak, nonatomic) IBOutlet UIButton *btnSFCHome1_5;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCHome6_10;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCHome11_15;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCHome16_20;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCHome21_25;
@property (weak, nonatomic) IBOutlet UIButton *btnSFCHome26_;


@property(strong,nonatomic)id<JCLQCellDelegate>delegate;
@property(nonatomic,strong)JCLQHHTZCell *cell;
-(void)loadData:(JCLQMatchModel*)model;



@end
