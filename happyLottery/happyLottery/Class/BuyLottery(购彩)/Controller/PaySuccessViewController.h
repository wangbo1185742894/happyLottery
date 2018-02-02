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
@property(assign,nonatomic) BOOL isMoni;
@property(nonatomic,strong)NSString *schemeNO;
@end
