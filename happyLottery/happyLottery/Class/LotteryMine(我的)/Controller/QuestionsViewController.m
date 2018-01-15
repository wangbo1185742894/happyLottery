//
//  QuestionsViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/15.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "QuestionsViewController.h"
#import "LYJHeaderView.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@interface QuestionsViewController ()<UITableViewDelegate,UITableViewDataSource,FoldSectionHeaderViewDelegate>{
    NSArray *_arr;//创建一个数据源数组
    NSMutableDictionary *_foldInfoDic;//创建一个字典进行判断收缩还是展开
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度
@end

@implementation QuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.estimatedRowHeight = 120;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self creatArr];
}

- (void)creatArr {
    NSString *s1=@"充值后，即时到账，根据规定，为避免洗钱行为，充值金额的30%只能用于购彩，不能提现。";
    NSString *s2=@"提现前需要设置好支付密码，实名认证并且添加银行卡，若银行卡开户名和认证姓名不一致，将无法提现成功，提现金额会原来返回账户。";
    NSString *s3=@"1.预测结果是根据大数据计算得出的，有些预测有双选，双选有利于稳定收益；\n2.目前只有竞彩足球胜平负和让球胜平负玩法有预测；\n3.精准预测是经过大数据分析之后，命中率较高比赛；\n4.预测数据是根据大数据变化而动态分析每一场比赛，当数据发生较大变化时，预测结果可能会跟着变化。" ;
    NSString *s4=@"1.方案每次最多十个，选择概率最高的推荐给彩民；\n2.对于高风险的方案，系统会自动给予屏蔽，因此有时候可能会无法显示生成方案。\n";
    _arr = [@[@[s1],@[s2],@[s3],@[s4]]mutableCopy];
    _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                   @"0":@"1",
                                                                   @"1":@"1",
                                                                   @"2":@"1",
                                                                   @"3":@"1"
                                                                   }];
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    
//    if (section == 0) {
//        return folded?1:0;
//    } else if (section == 1) {
//        return folded?1:0;
//    } else if (section == 2) {
//        return folded?_arr.count:0;
//    } else {
        return folded?1:0;
    //}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LYJHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[LYJHeaderView alloc] initWithReuseIdentifier:@"header"];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    }
    
    if (section == 0) {
        [headerView setFoldSectionHeaderViewWithTitle:@"充值问题"  type: HerderStyleTotal section:0 canFold:YES];
    } else if (section == 1) {
        [headerView setFoldSectionHeaderViewWithTitle:@"提现问题"  type:HerderStyleTotal section:1 canFold:YES];
    } else if (section == 2){
        [headerView setFoldSectionHeaderViewWithTitle:@"预测问题"  type:HerderStyleNone section:2 canFold:YES];
    } else {
        [headerView setFoldSectionHeaderViewWithTitle:@"方案问题" type:HerderStyleTotal section:3 canFold:YES];
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
//        if (tableView.sectionIndexMinimumDisplayRowCount == 0) {
//           cell.textLabel.text = _arr[0];
//        } else if (tableView.sectionIndexMinimumDisplayRowCount == 1) {
//            cell.textLabel.text = _arr[1];
//        } else if (tableView.sectionIndexMinimumDisplayRowCount == 2) {
//           cell.textLabel.text = _arr[2];
//        } else  if (tableView.sectionIndexMinimumDisplayRowCount == 4){
//  cell.textLabel.text = _arr[3];
//    }
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
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
    
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
