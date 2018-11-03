//
//  LegSelectViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/10/31.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegSelectViewController.h"
#import "SelectLegTableViewCell.h"
#import "LegSelectFooterView.h"
#import "CunLegTableViewCell.h"
#import "ZhuanLegTableViewCell.h"
#import "LegCashInfoViewController.h"

#define KSelectLegTableViewCell    @"SelectLegTableViewCell"
#define KCunLegTableViewCell       @"CunLegTableViewCell"
#define KZhuanLegTableViewCell     @"ZhuanLegTableViewCell"



@interface LegSelectViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,PostboyManagerDelegate>{
    
    __weak IBOutlet UITableView *personTableView;
    
}

@property (nonatomic, strong)NSMutableArray <PostboyAccountModel *> *personArray;



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
    self.postboyMan.delegate = self;
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
    [self.postboyMan getPostboyAccountList:@{@"cardCode":self.curUser.cardCode}];
}

#pragma mark  PostboyManagerDelegate
-(void )getPostboyAccountListdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success == NO) {
        [self showPromptViewWithText:msg hideAfter:1.9];
        return;
    }
    if (array.count == 0) {
        [self showPromptText:@"暂无小哥" hideAfterDelay:1.0];
    }else{
        //添加数据
        for (NSDictionary *dic in array) {
            PostboyAccountModel *postModel = [[PostboyAccountModel alloc]initWith:dic];
            if ([postModel.enabled boolValue]) {
                if ([postModel._id isEqualToString:self.curModel._id]) {
                    postModel.isSelect = YES;
                } else {
                    postModel.isSelect = NO;
                }
                [_personArray addObject:postModel];
            }
        }
        [self hideLoadingView];
    }
    [personTableView reloadData];
}

#pragma mark  tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

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
    return [UIView new];
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
    PostboyAccountModel *legModel = self.personArray[indexPath.row];
    legModel.isSelect = YES;
    if ([self.titleName isEqualToString:@"选择代买小哥"]) {
        [self.delegate alreadySelectModel:legModel];
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.titleName isEqualToString:@"存款"]) {
        LegCashInfoViewController *legCashInfoVC = [[LegCashInfoViewController alloc]init];
        legCashInfoVC.postboyModel = legModel;
        [self.navigationController pushViewController:legCashInfoVC animated:YES];
    } else {
        
    }
    
}


@end

