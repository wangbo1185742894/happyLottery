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
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger page;
@property (weak, nonatomic) IBOutlet UIImageView *imgLotteryIcon;
@property (weak, nonatomic) IBOutlet UILabel *labLotteryName;
@property (weak, nonatomic) IBOutlet UILabel *labIsWon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upIPhoneX;

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
    }else if ([self.lotteryCode isEqualToString:@"JCGJ"]){
        self.labLotteryName.text = @"冠军";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"first.png"];
    }else if ([self.lotteryCode isEqualToString:@"JCGYJ"]){
        self.labLotteryName.text = @"冠亚军";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"Championship.png"];
    }else if ([self.lotteryCode isEqualToString:@"SSQ"]){
        self.labLotteryName.text = @"双色球";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"shuangseqiu.png"];
    }else if ([self.lotteryCode isEqualToString:@"JCLQ"]){
        self.labLotteryName.text = @"竞彩篮球";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"basketball.png"];
    }else if ([self.lotteryCode isEqualToString:@"SX115"]){
        self.labLotteryName.text = @"陕西11选5";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"shiyixuanwu.png"];
    }else if ([self.lotteryCode isEqualToString:@"SD115"]){
        self.labLotteryName.text = @"山东11选5";
        self.imgLotteryIcon.image = [UIImage imageNamed:@"sdx115.png"];
    }
    self.page = 1;
    self.tabListDetail.dataSource = self;
    self.tabListDetail.delegate = self;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.tabListDetail registerClass:[JCLQOrderDetailViewCell class] forCellReuseIdentifier:JCLQOrderCell];
    
    
    self.lotteryMan.delegate = self;
    [UITableView refreshHelperWithScrollView:self.tabListDetail target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    }
    [self loadNewData];
    self.upIPhoneX.constant = [self isIphoneX]?88:64;
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
    if ([self.lotteryCode isEqualToString:@"JCGYJ"]||[self.lotteryCode isEqualToString:@"JCGJ"]) {
        [cell reloadDataGYJ:dic];
    }else if([self.lotteryCode isEqualToString:@"JCLQ"]){
        if ([self.fromView isEqualToString:@"FOLLOW_INIT"]) {
            [cell reloadDataFollowInit:dic openResult:self.lqOpenResult];
        }else {
            [cell reloadData:dic openResult:self.lqOpenResult];
        }
    } else {
        if ([self.fromView isEqualToString:@"FOLLOW_INIT"]) {
            [cell reloadDataFollowInit:dic openResult:self.trOpenResult];
        }else {
            [cell reloadData:dic openResult:self.trOpenResult];
        }
    }
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
