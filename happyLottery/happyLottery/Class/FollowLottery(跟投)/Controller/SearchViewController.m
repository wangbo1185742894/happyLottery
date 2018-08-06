//
//  SearchViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SearchViewController.h"
#import "FollowDetailViewController.h"
#import "PersonCenterViewController.h"
#import "SearchPerModel.h"
#import "SearchViewCell.h"

#define KSearchViewCell  @"SearchViewCell"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,MemberManagerDelegate,UITextFieldDelegate>
{
    NSMutableArray <SearchPerModel *> * schemeList;
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
    self.memberMan.delegate = self;
    _page = 1;
    schemeList = [NSMutableArray arrayWithCapacity:0];
    [self setTableView];
    self.tabSearchResultList.hidden = YES;
    [self setTextFiled];
    [self getHotFollowScheme];
    [UITableView refreshHelperWithScrollView:self.tabSearchResultList target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
}



-(void)loadNewData{
    _page = 1;
    [self getHotFollowScheme];
}

-(void)loadMoreData{
    _page ++;
    [self getHotFollowScheme];
    
}

-(void)getHotFollowScheme{
    if (self.tfSearchKey.text.length == 0) {
//        [self showPromptText:@"昵称不能为空" hideAfterDelay:1.9];
        [schemeList removeAllObjects];
        [self.tabSearchResultList reloadData];
        return;
    }
    NSDictionary *parc = @{@"nickName":self.tfSearchKey.text,@"page":@(_page),@"pageSize":@(KpageSize)};
    [self.memberMan searchGreatFollow:parc];
}

-(void)searchGreatFollow:(NSArray*)infoList errorMsg:(NSString *)msg{
    self.tabSearchResultList.hidden = NO;
    [self.tabSearchResultList tableViewEndRefreshCurPageCount:infoList.count];
    if (infoList == nil||infoList.count == 0) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    if (_page == 1) {
        [schemeList removeAllObjects];
    }
    for (NSDictionary *dic in infoList) {
        [schemeList addObject:[[SearchPerModel alloc]initWith:dic]];
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
    [rightView setImage:[UIImage imageNamed:@"deletesearch"] forState:0];

    self.tfSearchKey.rightView = rightView;
    [rightView addTarget:self action:@selector(cleanKeyWord) forControlEvents:UIControlEventTouchUpInside];
    self.tfSearchKey.rightViewMode =  UITextFieldViewModeAlways;
    self.tfSearchKey.leftView =leftView ;
    self.tfSearchKey.leftViewMode =  UITextFieldViewModeAlways;
    self.tfSearchKey.delegate = self;
}

-(void)cleanKeyWord{
    self.tfSearchKey.text = @"";
    [schemeList removeAllObjects];
    [self.tabSearchResultList reloadData];
}

-(void)setTableView{
    self.tabSearchResultList.delegate = self;
    self.tabSearchResultList.dataSource = self;

    [self.tabSearchResultList registerNib:[UINib nibWithNibName:KSearchViewCell bundle:nil] forCellReuseIdentifier:KSearchViewCell];
    [self.tabSearchResultList reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return schemeList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KSearchViewCell];
    [cell loadDataWithModel:schemeList[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 80;
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
    PersonCenterViewController *viewContr = [[PersonCenterViewController alloc]init];
    SearchPerModel *model = schemeList[indexPath.row];
    viewContr.cardCode = model.cardCode;
    viewContr.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewContr animated:YES];
}

- (IBAction)actionBack:(id)sender {
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)actionSearch:(id)sender {
    if (self.tfSearchKey.text.length == 0) {
        [self showPromptText:@"昵称不能为空" hideAfterDelay:1.9];
        [schemeList removeAllObjects];
        [self.tabSearchResultList reloadData];
        return;
    }
    [self loadNewData];
}

#pragma UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"\n"]) {
        
    }
    if ([textField isFirstResponder]) {
        
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([self isNineKeyBoard:string] ){
            return YES;
        }else{
            if ([self hasEmoji:string] || [self stringContainsEmoji:string]){
                return NO;
            }
        }
    }
    if (textField == self.tfSearchKey) {
        if (![self isValidateName:string]) {
            return NO;
        }
    }
    return YES;
}

-(void)itemClickToPerson:(NSString *)carcode{
 
}

@end
