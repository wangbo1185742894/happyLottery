//
//  YuCeLiShiZhanJViewController.m
//  Lottery
//
//  Created by onlymac on 2017/10/13.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "YuCeLiShiZhanJViewController.h"
#import "YuCeLiShiZhanJCell.h"
#import "yucezjModel.h"
@interface YuCeLiShiZhanJViewController ()<UITableViewDataSource,UITableViewDelegate,LotteryManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *YuCeZJTableView;


@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation YuCeLiShiZhanJViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"历史战绩";
    [self.YuCeZJTableView registerNib:[UINib nibWithNibName:@"YuCeLiShiZhanJCell" bundle:nil] forCellReuseIdentifier:@"YuCeLiShiZhanJCell"];
    self.YuCeZJTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.YuCeZJTableView.delegate = self;
    self.YuCeZJTableView.dataSource = self;
    [self setLotteryManager];
    [self showLoadingViewWithText:@"正在加载"];
    
}

- (void)gotListByHisGains:(NSArray *)infoArr errorMsg:(NSString *)errorMsg{
    [self hideLoadingView];
    if (infoArr != nil) {
        if (self.dataArr != nil) {
            [self.dataArr removeAllObjects];
        }
        for (NSDictionary *dic in infoArr) {
            yucezjModel *model = [[yucezjModel alloc]initWith:dic];
            [self.dataArr addObject:model];
        }
    }
    
 
    [self.YuCeZJTableView reloadData];
}

-(void)setLotteryManager{
    self.curUser = [GlobalInstance instance].curUser;
    if (self.lotteryMan  == nil) {
        self.lotteryMan = [[LotteryManager alloc]init];
    }
    self.lotteryMan.delegate = self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YuCeLiShiZhanJCell *cell = [YuCeLiShiZhanJCell cellWithTableView:tableView];
    [cell refreshData:self.dataArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 94;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
