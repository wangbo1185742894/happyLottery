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
    NSString *s1=@"找回步骤：如果您不小心忘记了登录密码，可通过绑定的手机号码召回。在【登录】页点击【忘记密码】，进入该页面后通过绑定的手机号和验证码，即可设置新的登录密码。";
    NSString *s2=@"进入【我的】页面，点击【充值】。进入该页面后输入充值金额，选择支付方式后点击充值按钮即可。";
    NSString *s3=@"提现的银行账户，点击【申请提现】即可完成。注：您的提现审核通过后，资金将在24小时内转入银行账户。不排除因通讯或银行方面原因造成延迟的可能。若审核未通过或银行转账失败，则资金将会退回您的投必中账户。" ;
    NSString *s4=@"你可通过充值到投必中账户进行余额投注，也可在投注是选择第三方支付方式进行投注。";
    NSString *s5=@"彩民中奖后，由系统直接将中奖金额自动转至该彩民账户中。注：根据相关规定单注中奖金额超过1万元，应缴纳个人所得税，由彩票中心代扣代缴。选择倍投投注时，只要开奖后单注奖金不超过1万元，就算翻倍后奖金超过1万元，也无须缴纳个人所得税。";
//    NSString *s6=@"用户可以选择积分和现金进行投注，积分投注赔率以提交订单时的赔率为准，现金投注赔率以出票票面赔率为准\n";
//    NSString *s7=@"彩民中奖后，五万元（含五万元）一下的中奖奖金直接进入中奖者的指定账户，超过五万元，客户会主动联系大奖客户，引导客户携带身份资料至体彩中心领奖\n";
    _arr = [@[@[s1],@[s2],@[s3],@[s4],@[s5]]mutableCopy];
    _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                   @"0":@"1",
                                                                   @"1":@"0",
                                                                   @"2":@"0",
                                                                   @"3":@"0",
                                                                   @"4":@"0"
                           }];
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    
  
    return folded?1:0;
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LYJHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[LYJHeaderView alloc] initWithReuseIdentifier:@"header"];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    }
    
    if (section == 0) {
        [headerView setFoldSectionHeaderViewWithTitle:@"忘记密码"  type: HerderStyleTotal section:0 canFold:YES];
    } else if (section == 1) {
        [headerView setFoldSectionHeaderViewWithTitle:@"账户充值"  type:HerderStyleTotal section:1 canFold:YES];
    } else if (section == 2){
        [headerView setFoldSectionHeaderViewWithTitle:@"账户提现"  type:HerderStyleNone section:2 canFold:YES];
    } else if (section == 3){
        [headerView setFoldSectionHeaderViewWithTitle:@"投注"  type:HerderStyleNone section:3 canFold:YES];
    }else if (section == 4){
        [headerView setFoldSectionHeaderViewWithTitle:@"兑奖"  type:HerderStyleNone section:4 canFold:YES];
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
    if([height integerValue] != 0)
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
