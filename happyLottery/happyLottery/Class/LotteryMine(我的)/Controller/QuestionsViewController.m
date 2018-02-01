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
    NSString *s1=@"通常情况下，充值后您的资金将会立即到账。若出现银行卡已经扣费，但资金并未到账，请拨打客服热线400-600-5558";
    NSString *s2=@"根据相关规定充值金额的30%只能用于购彩，不能提现。其中彩金是投必中发送给用户的专属购彩金，也是无法提现。";
    NSString *s3=@"预测结果通过多维度的大数据分析，进行数学建模和多维度的数据模型匹配，从而智能分析出比赛结果。" ;
 
    _arr = [@[@[s1],@[s2],@[s3]]mutableCopy];
    _foldInfoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                   @"0":@"1",
                                                                   @"1":@"0",
                                                                   @"2":@"0"
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
    return 3;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LYJHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[LYJHeaderView alloc] initWithReuseIdentifier:@"header"];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    }
    
    if (section == 0) {
        [headerView setFoldSectionHeaderViewWithTitle:@"充值未及时到账怎么办？"  type: HerderStyleTotal section:0 canFold:YES];
    } else if (section == 1) {
        [headerView setFoldSectionHeaderViewWithTitle:@"账户有余额为什么不能提现？"  type:HerderStyleTotal section:1 canFold:YES];
    } else if (section == 2){
        [headerView setFoldSectionHeaderViewWithTitle:@"预测结果有什么依据吗？"  type:HerderStyleNone section:2 canFold:YES];
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
