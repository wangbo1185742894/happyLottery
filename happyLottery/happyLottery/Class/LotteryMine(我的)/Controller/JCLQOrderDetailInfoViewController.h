//
//  JCLQOrderDetailInfoViewController.h
//  Lottery
//
//  Created by 王博 on 16/10/13.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCLQOrderDetailInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tabListDetail;

@property(nonatomic,strong)NSString *schemeNO;
@property (nonatomic,strong)NSString *lotteryCode;

@end
