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

#define KSelectLegTableViewCell    @"SelectLegTableViewCell"

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
    self.title = @"选择代码小哥";
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
    return 74;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return footView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.personArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectLegTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSelectLegTableViewCell];
    [cell loadLegDate:[self.personArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   self.personArray[indexPath.row].isSelect = !self.personArray[indexPath.row].isSelect;
   [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


@end

