//
//  RecommendPerViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RecommendPerViewController.h"
#import "RecomPerTableViewCell.h"
#import "RecomPerModel.h"

#define KRecomPerTableViewCell @"RecomPerTableViewCell"
@interface RecommendPerViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>


@property(nonatomic,strong)NSMutableArray <RecomPerModel *> * personArray;

@property (weak, nonatomic) IBOutlet UITableView *personList;

@end

@implementation RecommendPerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.personList.delegate = self;
    self.personList.dataSource = self;
    [self.personList registerNib:[UINib nibWithNibName:KRecomPerTableViewCell bundle:nil] forCellReuseIdentifier:KRecomPerTableViewCell];
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    [self setBarTitle];
    //data request
    if (self.lotteryMan == nil) {
        self.lotteryMan = [[LotteryManager alloc]init];
    }
    self.lotteryMan.delegate = self;
    NSDictionary *dic;
    if ([self.categoryCode isEqualToString:@"Cowman"]) {
        dic = @{@"channelCode":CHANNEL_CODE};
    } else {
        dic = nil;
    }
    [self.lotteryMan listRecommendPer:dic categoryCode:self.categoryCode];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setBarTitle{
    if ([self.categoryCode isEqualToString:@"Cowman"]) {
        self.title = @"牛人榜";
    } else if ([self.categoryCode isEqualToString:@"Redman"]){
        self.title = @"红人榜";
    } else {
        self.title = @"红单榜";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  lotteryMan

- (void) gotlistRecommend:(NSArray *)infoArray  errorMsg:(NSString *)msg{
    [self.personArray removeAllObjects];
    //添加数据
    for (NSDictionary *dic in infoArray) {
        RecomPerModel *model = [[RecomPerModel alloc]initWithDic:dic];
        [self.personArray addObject:model];
    }
    [self.personList reloadData];
    
}//牛人，红人，红单榜

#pragma mark  tableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecomPerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KRecomPerTableViewCell];
    RecomPerModel *model = [self.personArray objectAtIndex:indexPath.row];
    [cell reloadDate:model];
    return cell;

}

@end
