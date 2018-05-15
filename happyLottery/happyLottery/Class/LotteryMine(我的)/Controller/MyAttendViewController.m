//
//  MyAttendViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "MyAttendViewController.h"
#import "AtttendPersonViewCell.h"
#import "AttentPersonModel.h"
#import "PersonCenterViewController.h"
#define KAtttendPersonViewCell @"AtttendPersonViewCell"
@interface MyAttendViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabAttendList;
@property(nonatomic,strong)NSMutableArray <AttentPersonModel *> *personList;
@end

@implementation MyAttendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableVIew];
    [UITableView refreshHelperWithScrollView:self.tabAttendList target:self loadNewData:@selector(loadData) loadMoreData:@selector(loadData) isBeginRefresh:NO];
    self.lotteryMan.delegate = self;
    self.title = @"我的关注";
    self.personList = [NSMutableArray arrayWithCapacity:0];
    
    [self loadData];
}

-(void)loadData{
    if (self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    [self.lotteryMan getListAttent:@{@"cardCode":self.curUser.cardCode,@"attentType":@"FOLLOW"}];
}

-(void)gotListAttent:(NSArray *)personList errorMsg:(NSString *)msg{
    [self.tabAttendList tableViewEndRefreshCurPageCount:personList.count];
    
    if (personList == nil) {
        [self showPromptText:msg hideAfterDelay:1.9];
          [self.tabAttendList reloadData];
        return;
    }
    [_personList removeAllObjects];
    for (NSDictionary *itemDic in personList) {
        AttentPersonModel *model = [[AttentPersonModel alloc]initWith:itemDic];
        [_personList addObject:model];
    }
    [self.tabAttendList reloadData];
}

-(void)setTableVIew{
    self.tabAttendList.delegate = self;
    self.tabAttendList.dataSource =self;
    [self.tabAttendList registerNib:[UINib nibWithNibName:KAtttendPersonViewCell bundle:nil] forCellReuseIdentifier:KAtttendPersonViewCell];
    [self.tabAttendList reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _personList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AtttendPersonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KAtttendPersonViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadData:_personList[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCenterViewController *viewContr = [[PersonCenterViewController alloc]init];
    
    viewContr.cardCode = _personList[indexPath.row].cardCode;
    [self.navigationController pushViewController:viewContr animated:YES];
}


@end
