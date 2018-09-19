//
//  PaySuccessViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"

@interface PaySuccessViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *labChuPiaoimg;
@property(nonatomic,strong)NSString *lotteryName;
@property(assign,nonatomic) BOOL isMoni;
@property(nonatomic,assign)BOOL isShowFaDan;
@property(nonatomic,strong)NSString *schemeNO;
@property(nonatomic,strong)NSString *orderCost;
@property(nonatomic,assign)NSInteger aniTime;

@property(assign,nonatomic)SchemeType  schemetype;
@end
