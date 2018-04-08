//
//  JCLQSFCPlayTypeView.h
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLQMatchModel.h"
#import "BaseCell.h"
#import "JCLQSFCCell.h"

@interface JCLQSFCPlayTypeView : UIView

@property (weak, nonatomic) IBOutlet UILabel *labMatchName;
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
@property(strong,nonatomic)JCLQSFCCell*cell;


-(void)loadDataWith:(JCLQMatchModel*)model;
@end
