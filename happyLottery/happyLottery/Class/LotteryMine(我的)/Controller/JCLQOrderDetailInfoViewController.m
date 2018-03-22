//
//  JCLQOrderDetailInfoViewController.m
//  Lottery
//
//  Created by 王博 on 16/10/13 lala.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQOrderDetailInfoViewController.h"
#import "JCLQOrderDetailViewCell.h"

#define JCLQOrderCell @"JCLQOrderDetailViewCell"

@interface JCLQOrderDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labTotalNumbe;
@property(nonatomic,strong)NSMutableArray <NSMutableArray<HomeYCModel *> *> *dataArray;
@property (nonatomic,assign)NSInteger page;
@property (weak, nonatomic) IBOutlet UIImageView *imgLotteryIcon;
@property (weak, nonatomic) IBOutlet UILabel *labLotteryName;
@property (weak, nonatomic) IBOutlet UILabel *labIsWon;

@end

@implementation JCLQOrderDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    if([self.lotteryCode isEqualToString:@"DLT"]){
        self.labLotteryName.text  = @"大乐透";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"daletou.png"];
    }else if([self.lotteryCode isEqualToString:@"JCZQ"]){
        self.labLotteryName.text = @"竞彩足球";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"footerball.png"];
    }else if([self.lotteryCode isEqualToString:@"RJC"]){
        self.labLotteryName.text = @"任9场";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"shengfucai.png"];
    }else if([self.lotteryCode isEqualToString:@"SFC"]){
        self.labLotteryName.text = @"14场";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"shengfucai.png"];
    }
    self.page = 1;
    self.tabListDetail.dataSource = self;
    self.tabListDetail.delegate = self;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.tabListDetail registerClass:[JCLQOrderDetailViewCell class] forCellReuseIdentifier:JCLQOrderCell];
    
    
    self.lotteryMan.delegate = self;
    [UITableView refreshHelperWithScrollView:self.tabListDetail target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    
    [self loadNewData];
}

-(void)loadNewData{
    _page = 1;

    [self.lotteryMan getJczqTicketOrderDetail:@{@"schemeNo":self.schemeNO,@"page":@(_page),@"pageSize":@(KpageSize)} andLottery:self.lotteryCode];
}

-(void)loadMoreData{
    _page ++;

    [self.lotteryMan getJczqTicketOrderDetail:@{@"schemeNo":self.schemeNO,@"page":@(_page),@"pageSize":@(KpageSize)} andLottery:self.lotteryCode];
}

-(void)gotJczqTicketOrderDetail:(NSArray *)infoArray errorMsg:(NSString *)msg{
    [self.tabListDetail tableViewEndRefreshCurPageCount:infoArray.count];
    if (infoArray == nil || infoArray .count == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    if (self.page == 1) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:infoArray];
    [self.tabListDetail reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JCLQOrderDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JCLQOrderCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell reloadData:dic];
    return cell;
}  
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.dataArray[indexPath.row];
   JCLQOrderDetailViewCell *cell = [[JCLQOrderDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JCLQOrderCell];
    
    return [cell getCellHeight:dic];

}

- (void) gotJCLQOrderInfoDetail:(NSArray *)dataArray{

    if (self.page == 1) {
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:dataArray];;
    
    [self.tabListDetail reloadData];
}

@end
