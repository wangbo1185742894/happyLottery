//
//  SearchViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SearchViewController.h"
#import "HotFollowSchemeViewCell.h"
#import "FollowDetailViewController.h"
#define KHotFollowSchemeViewCell @"HotFollowSchemeViewCell"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>
{
    NSMutableArray <HotSchemeModel *> * schemeList;
}
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *tfSearchKey;
@property(assign,nonatomic)NSInteger page;
@property (weak, nonatomic) IBOutlet UITableView *tabSearchResultList;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isIphoneX]) {
        self.topViewHeight.constant = 88;
    }else{
        self.topViewHeight.constant = 64;
    }
    self.viewControllerNo = @"A421";
    self.lotteryMan.delegate = self;
    _page = 0;
    schemeList = [NSMutableArray arrayWithCapacity:0];
    [self setTableView];
    self.tabSearchResultList.hidden = YES;
    [self setTextFiled];
    [self getHotFollowScheme];
    [UITableView refreshHelperWithScrollView:self.tabSearchResultList target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
}



-(void)loadNewData{
    _page = 0;
    [self getHotFollowScheme];
}

-(void)loadMoreData{
    _page ++;
    [self getHotFollowScheme];
}

-(void)getHotFollowScheme{
    if (self.tfSearchKey.text .length == 0) {
        [self showPromptText:@"请输入要查询的昵称" hideAfterDelay:1.9];
        [schemeList removeAllObjects];
        [self.tabSearchResultList reloadData];
        
        return;
    }
    NSDictionary *parc = @{@"nickName":self.tfSearchKey.text,@"page":@(_page),@"pageSize":@(KpageSize),@"isHis":@NO};
    [self.lotteryMan getFollowSchemeByNickName:parc];
}

-(void)getHotFollowScheme:(NSArray *)personList errorMsg:(NSString *)msg{
    self.tabSearchResultList.hidden = NO;
    [self.tabSearchResultList tableViewEndRefreshCurPageCount:personList.count];
    if (personList == nil) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    if (_page == 0) {
        [schemeList removeAllObjects];
    }
    for (NSDictionary *dic in personList) {
        [schemeList addObject:[[HotSchemeModel alloc]initWith:dic]];
    }
    [self.tabSearchResultList  reloadData];
}

-(void)setTextFiled{
    self.tfSearchKey.layer.cornerRadius = self.tfSearchKey.mj_h / 2;
    self.tfSearchKey.layer.masksToBounds = YES;
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"请输入您要搜索的昵称" attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.tfSearchKey.attributedPlaceholder = firstPart;
    UIButton *leftView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftView setImage:[UIImage imageNamed:@"sousuo"] forState:0];
    
    UIButton *rightView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightView setImage:[UIImage imageNamed:@"delete"] forState:0];

    self.tfSearchKey.rightView = rightView;
    [rightView addTarget:self action:@selector(cleanKeyWord) forControlEvents:UIControlEventTouchUpInside];
    self.tfSearchKey.rightViewMode =  UITextFieldViewModeAlways;
    self.tfSearchKey.leftView =leftView ;
    self.tfSearchKey.leftViewMode =  UITextFieldViewModeAlways;
}

-(void)cleanKeyWord{
    self.tfSearchKey.text = @"";
}

-(void)setTableView{
    self.tabSearchResultList.delegate = self;
    self.tabSearchResultList.dataSource = self;

    [self.tabSearchResultList registerNib:[UINib nibWithNibName:KHotFollowSchemeViewCell bundle:nil] forCellReuseIdentifier:KHotFollowSchemeViewCell];

    [self.tabSearchResultList reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return schemeList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotFollowSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHotFollowSchemeViewCell];
    [cell loadDataWithModelInDaT:schemeList[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 202;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowDetailViewController *followVC = [[FollowDetailViewController alloc]init];
    followVC.model = schemeList[indexPath.row];
    followVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:followVC animated:YES];
}

- (IBAction)actionBack:(id)sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionSearch:(id)sender {
     [self loadNewData];
}


@end
