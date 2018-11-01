//
//  LegSelectViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/10/31.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegSelectViewController.h"
#import "SelectLegTableViewCell.h"
#import "LegWordModel.h"
#import "LegSelectFooterView.h"
#import "CunLegTableViewCell.h"
#import "ZhuanLegTableViewCell.h"


#define KSelectLegTableViewCell    @"SelectLegTableViewCell"
#define KCunLegTableViewCell       @"CunLegTableViewCell"
#define KZhuanLegTableViewCell     @"ZhuanLegTableViewCell"

@interface LegSelectViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>{
    
    __weak IBOutlet UITableView *personTableView;
    
}

@property (nonatomic, strong)NSMutableArray <LegWordModel *> *personArray;

@end

@implementation LegSelectViewController {
    LegSelectFooterView * footView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleName;
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    [self setTableView];
    self.lotteryMan.delegate = self;
    [self loadNewDate];
    footView = [[LegSelectFooterView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 74)];
    // Do any additional setup after loading the view from its nib.
}


-(void)setTableView{
    personTableView.delegate = self;
    personTableView.dataSource = self;
    [personTableView registerNib:[UINib nibWithNibName:KSelectLegTableViewCell bundle:nil] forCellReuseIdentifier:KSelectLegTableViewCell];
    [personTableView registerNib:[UINib nibWithNibName:KCunLegTableViewCell bundle:nil] forCellReuseIdentifier:KCunLegTableViewCell];
    [personTableView registerNib:[UINib nibWithNibName:KZhuanLegTableViewCell bundle:nil] forCellReuseIdentifier:KZhuanLegTableViewCell];
}

- (void)loadNewDate {
    [self showLoadingText:@"正在加载中"];
    [self.lotteryMan getLegWorkList:nil];
}

#pragma mark  Lotterydelegate
- (void) gotLegWorkList:(NSArray *)redList errorInfo:(NSString *)errMsg{
    if (redList == nil) {
        [self showPromptViewWithText:errMsg hideAfter:1.9];
        return;
    }
    if (redList.count == 0) {
        [self showPromptText:@"暂无小哥" hideAfterDelay:1.0];
    }else{
        //添加数据
        for (NSDictionary *dic in redList) {
            LegWordModel *model = [[LegWordModel alloc]initWith:dic];
            if ([model.enabled boolValue]) {
              [_personArray addObject:model];
            }
        }
        [self hideLoadingView];
    }
    [personTableView reloadData];
}


#pragma mark  tableview delegate


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.titleName isEqualToString:@"选择代买小哥"]) {
        return 74;
    }
    return 0.1;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.titleName isEqualToString:@"选择代买小哥"]) {
        return footView;
    }
    return nil;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.titleName isEqualToString:@"选择代买小哥"]) {
        SelectLegTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSelectLegTableViewCell];
        [cell loadLegDate:[self.personArray objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    if ([self.titleName isEqualToString:@"给跑腿小哥转账"]) {
        ZhuanLegTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KZhuanLegTableViewCell];
        [cell loadLegDate:[self.personArray objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    CunLegTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCunLegTableViewCell];
    [cell loadLegDate:[self.personArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.titleName isEqualToString:@"选择代买小哥"]) {
       return 110;
    }
    if ([self.titleName isEqualToString:@"给跑腿小哥转账"]) {
       return 98;
    }
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   self.personArray[indexPath.row].isSelect = !self.personArray[indexPath.row].isSelect;
   [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


@end

