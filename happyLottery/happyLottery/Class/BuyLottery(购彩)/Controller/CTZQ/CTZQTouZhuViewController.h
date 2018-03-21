//
//  CTZQTouZhuViewController.h
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTZQTransaction.h"
#import "Lottery.h"

@interface CTZQTouZhuViewController : BaseViewController

@property (nonatomic, strong)Lottery* lottery;

@property (weak, nonatomic) IBOutlet UILabel *labTimeTitle;
@property (weak, nonatomic) IBOutlet UITableView *tabContentList;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (weak, nonatomic) IBOutlet UILabel *labSummary;

@property(strong,nonatomic)CTZQTransaction *cTransation;

@property (weak, nonatomic) IBOutlet UIButton *matchInfoBtn;
@property (nonatomic, strong)NSMutableArray *CTZQMatchArr;
@property (nonatomic, strong)NSMutableArray *CTZQMatchSelectedArr;




- (IBAction)actionTouZhu:(UIButton *)sender;

- (IBAction)actionEdit:(UIButton *)sender;
@end
