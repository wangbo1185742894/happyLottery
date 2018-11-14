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



@interface LegSelectViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,PostboyManagerDelegate,ZhuanLegDelegate>{
    
    __weak IBOutlet UITableView *personTableView;
    
    __weak IBOutlet UIButton *queDingBtn;
}

@property (nonatomic, strong)NSMutableArray <PostboyAccountModel *> *personArray;

@property (nonatomic, strong)PostboyAccountModel *selectlegModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightCons;

@end

@implementation LegSelectViewController {
    LegSelectFooterView * footView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titleName;
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    [self setTableView];
    [UITableView refreshHelperWithScrollView:personTableView target:self loadNewData:@selector(loadNewDate) loadMoreData:nil isBeginRefresh:NO];
    [self loadNewDate];
    self.lotteryMan.delegate = self;
    self.postboyMan.delegate = self;
    
    footView = [[LegSelectFooterView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 74)];
    if ([self.titleName isEqualToString:@"选择代买小哥"]||[self.titleName isEqualToString:@"存款"]) {
        self.bottomHeightCons.constant = 0;
    }else {
        queDingBtn.layer.masksToBounds = YES;
        queDingBtn.layer.cornerRadius = 4;
        if ([self isIphoneX]) {
            self.bottomHeightCons.constant = 50+34;
        }else{
            self.bottomHeightCons.constant = 50;
        }
    }
  
    // Do any additional setup after loading the view from its nib.
}


-(void)setTableView{
    personTableView.delegate = self;
    personTableView.dataSource = self;
    [personTableView registerNib:[UINib nibWithNibName:KSelectLegTableViewCell bundle:nil] forCellReuseIdentifier:KSelectLegTableViewCell];
    [personTableView registerNib:[UINib nibWithNibName:KCunLegTableViewCell bundle:nil] forCellReuseIdentifier:KCunLegTableViewCell];
    [personTableView registerNib:[UINib nibWithNibName:KZhuanLegTableViewCell bundle:nil] forCellReuseIdentifier:KZhuanLegTableViewCell];
    personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadNewDate {
    [self showLoadingText:@"正在加载中"];
    [self.postboyMan getPostboyAccountList:@{@"cardCode":self.curUser.cardCode}];
}

#pragma mark  PostboyManagerDelegate
-(void )getPostboyAccountListdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self hideLoadingView];
    [personTableView tableViewEndRefreshCurPageCount:array.count];
    [_personArray removeAllObjects];
    if (success == NO) {
        [self showPromptViewWithText:msg hideAfter:1.9];
        return;
    }
    if (array.count == 0) {
        [self showPromptText:@"暂无小哥" hideAfterDelay:1.0];
    }else{
        //添加数据，用过的小哥 按照服务器返回排列，没有用过的随机排列
        NSMutableArray<PostboyAccountModel *> * notUseArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in array) {
            PostboyAccountModel *postModel = [[PostboyAccountModel alloc]initWith:dic];
            if ([postModel._id isEqualToString:self.curModel._id]) {
                postModel.isSelect = YES;
            } else {
                postModel.isSelect = NO;
            }
            if (postModel.totalBalance.length != 0) {
                [_personArray addObject:postModel];
            } else {
                [notUseArray addObject:postModel];
            }
        }
        if (![self.titleName isEqualToString:@"存款"]) { //存款中的小哥只显示用户使用过的小哥
            if (notUseArray.count >= 2) {
                for (int i = 0 ;i < notUseArray.count; i ++) {
                    NSInteger index1 = arc4random_uniform(notUseArray.count - 1);
                    NSInteger index2 = arc4random_uniform(notUseArray.count - 1);
                    PostboyAccountModel *model = notUseArray[index1];
                    notUseArray[index1] = notUseArray[index2];
                    notUseArray[index2] = model;
                }
            }
            [_personArray addObjectsFromArray:notUseArray];
        }
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
        cell.delegate = self;
        personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
    CunLegTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KCunLegTableViewCell];
    [cell loadLegDate:[self.personArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.titleName isEqualToString:@"选择代买小哥"]) {
       return 110;
    }
    if ([self.titleName isEqualToString:@"给跑腿小哥转账"]) {
       return 90;
    }
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([self.titleName isEqualToString:@"选择代买小哥"]) {
        PostboyAccountModel *legModel = self.personArray[indexPath.row];
        if (![legModel.overline boolValue] && [legModel.totalBalance doubleValue]<[self.realCost doubleValue]){
            [self showPromptViewWithText:@"该小哥已离线且余额不足，请选择其他小哥" hideAfter:1.7];
            return;
        }
        legModel.isSelect = YES;
        [self.delegate alreadySelectModel:legModel];
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.titleName isEqualToString:@"存款"]) {
        PostboyAccountModel *legModel = self.personArray[indexPath.row];
        legModel.isSelect = YES;
        LegCashInfoViewController *legCashInfoVC = [[LegCashInfoViewController alloc]init];
        legCashInfoVC.postboyModel = legModel;
        [self.navigationController pushViewController:legCashInfoVC animated:YES];
    } else {
        PostboyAccountModel *legModel = self.personArray[indexPath.row];
        if (![legModel.overline boolValue]){
            [self showPromptViewWithText:@"该小哥已离线，请选择其他小哥转账" hideAfter:1.7];
            return;
        }
        for (PostboyAccountModel *model  in self.personArray) {
            model.isSelect = NO;
        }
        self.selectlegModel = self.personArray[indexPath.row];
        self.selectlegModel.isSelect = YES;
        [tableView reloadData];
    }
    
}


- (void)actionToWeiXin:(NSString *)weiXin{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    if (weiXin == nil || weiXin.length == 0) {
        [self showPromptText:@"暂未上传微信信息" hideAfterDelay:2.0];
    }else{
        [self showPromptText:@"微信号已复制到剪贴板" hideAfterDelay:2.0];
         pboard.string = weiXin;
    }
}

- (void)actionToTelephone:(NSString *)telephone{
    if (telephone.length == 0) {
        [self showPromptText:@"暂未上传手机号" hideAfterDelay:1.7];
        return;
    }
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telephone]]];
}

- (IBAction)actionQueDing:(id)sender {
    [self.delegate alreadySelectModel:self.selectlegModel];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

