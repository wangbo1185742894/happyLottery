//
//  MyCricleFriendVC.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "MyAgentInfoModel.h"

@interface MyCricleYongJinVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tabFirendList;
@property(strong,nonatomic)MyAgentInfoModel *agentModel;
@end
