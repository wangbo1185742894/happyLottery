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
    _foldInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.estimatedRowHeight = 120;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self creatArr];
}

- (void)creatArr {
    _arr = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"questionAndAnswear" ofType: @"plist"]];
    for (int i = 0; i<_arr.count; i++) {
        NSString *stringInt = [NSString stringWithFormat:@"%d",i];
        if (i == 0) {
            [_foldInfoDic setValue:@"1" forKey:stringInt];
        } else {
            [_foldInfoDic setValue:@"0" forKey:stringInt];
        }
        
    }
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = [NSString stringWithFormat:@"%d", (int)section];
    BOOL folded = [[_foldInfoDic objectForKey:key] boolValue];
    return folded?1:0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LYJHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[LYJHeaderView alloc] initWithReuseIdentifier:@"header"];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    }
    NSDictionary *dic = _arr[section];
    [headerView setFoldSectionHeaderViewWithTitle:dic[@"question"] type:HerderStyleTotal section:section canFold:YES];
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
    NSDictionary *dic = _arr[indexPath.section];
    cell.textLabel.text = dic[@"answer"];
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
