//
//  JCLQTouZhuController.h
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLQTransaction.h"

#import "JingCaiChaunFaSelectView.h"

@interface JCLQTouZhuController : BaseViewController
@property (nonatomic, strong) Lottery *lottery;
@property (weak, nonatomic) IBOutlet UIView *costTypeSelectView;

@property (weak, nonatomic) IBOutlet UILabel *labMaxJiangjie;
@property (assign,nonatomic)SchemeType fromSchemeType;
@property(nonatomic,strong)JCLQTransaction *transaction;
@property (weak, nonatomic) IBOutlet UILabel *labNumBetCount;
- (IBAction)actionTouzhu:(UIButton *)sender;

@end
