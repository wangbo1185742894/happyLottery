//
//  FunctionsViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/15.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FunctionsViewController.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "LYJHeaderView.h"

@interface FunctionsViewController ()<UITableViewDelegate,UITableViewDataSource,FoldSectionHeaderViewDelegate>{
    NSArray *_arr;//创建一个数据源数组
    NSMutableDictionary *_foldInfoDic;//创建一个字典进行判断收缩还是展开
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@end

@implementation FunctionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能指南";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.estimatedRowHeight = 120;//很重要保障滑动流畅性
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self creatArr];
}
- (void)creatArr {
    NSString *s1=@"进入登录页面-点击忘记密码-输入手机号-获取验证码-重新设置登录密码";
    NSString *s2=@"点击头像进入个人设置页面-点击修改登录密码-输旧密码-输入新设置的密码";
    NSString *s3=@"点击头像进入个人设置页面-点击修改支付密码-输旧密码-输入新设置的密码\n如果旧密码已经忘记，需要点击支付设置页面的忘记密码，然后输入账户绑定的手机号，获取验证码，最后重新设置支付密码\n" ;
    NSString *s4=@"进入充值界面后，输入充值金额，选择充值方式进行充值\n";
    NSString *s5=@"用户设置了支付密码，认证姓名并且添加银行卡之后，输入提现金额小于等于可提现金额时，用户申请提现，资金将会在一个工作日之内转入用户提现的银行卡，如果提现失败，提现金额将原路返回账户。";
    NSString *s6=@"用户可以选择积分和现金进行投注，积分投注赔率以提交订单时的赔率为准，现金投注赔率以出票票面赔率为准\n";
    NSString *s7=@"彩民中奖后，五万元（含五万元）一下的中奖奖金直接进入中奖者的指定账户，超过五万元，客户会主动联系大奖客户，引导客户携带身份资料至体彩中心领奖\n";
    _arr = [@[@[s1],@[s2],@[s3],@[s4],@[s5],@[s6],@[s7]]mutableCopy];
    _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                   @"0":@"1",
                                                                   @"1":@"1",
                                                                   @"2":@"1",
                                                                   @"3":@"1",
                                                                   @"4":@"1",
                                                                   @"5":@"1",
                                                                   @"6":@"1"
                                                                   }];
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    
  
    return folded?1:0;
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LYJHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[LYJHeaderView alloc] initWithReuseIdentifier:@"header"];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    }
    
    if (section == 0) {
        [headerView setFoldSectionHeaderViewWithTitle:@"忘记登录密码"  type: HerderStyleTotal section:0 canFold:YES];
    } else if (section == 1) {
        [headerView setFoldSectionHeaderViewWithTitle:@"修改登录密码"  type:HerderStyleTotal section:1 canFold:YES];
    } else if (section == 2){
        [headerView setFoldSectionHeaderViewWithTitle:@"修改支付密码"  type:HerderStyleNone section:2 canFold:YES];
    } else if (section == 3){
        [headerView setFoldSectionHeaderViewWithTitle:@"账户充值"  type:HerderStyleNone section:3 canFold:YES];
    }else if (section == 4){
        [headerView setFoldSectionHeaderViewWithTitle:@"账户提现"  type:HerderStyleNone section:4 canFold:YES];
    }else if (section == 5){
        [headerView setFoldSectionHeaderViewWithTitle:@"投注"  type:HerderStyleNone section:5 canFold:YES];
    }else {
        [headerView setFoldSectionHeaderViewWithTitle:@"领奖" type:HerderStyleTotal section:6 canFold:YES];
    }
    headerView.delegate = self;
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[_foldInfoDic valueForKey:key] boolValue];
    headerView.fold = folded;
    return headerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _arr[indexPath.section][indexPath.row];
    cell.textLabel.numberOfLines=0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    [UILabel changeLineSpaceForLabel:cell.textLabel WithSpace:5.0];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height)
    {
        return height.floatValue;
    }
    else
    {
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath
{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
}

- (void)foldHeaderInSection:(NSInteger)SectionHeader {
    NSString *key = [NSString stringWithFormat:@"%d",(int)SectionHeader];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    NSString *fold = folded ? @"0" : @"1";
    [_foldInfoDic setValue:fold forKey:key];
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:SectionHeader];
    [self.tableview reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
