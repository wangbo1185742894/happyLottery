//
//  SendRedPackViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/9/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SendRedPackViewController.h"
#import "SearchViewController.h"
#import "SendPedPackCell.h"
#import "RedPackCircleModal.h"
#import "MGLabel.h"
#import "SendRedViewController.h"

#define KSendPedPackCell   @"SendPedPackCell"


@interface SendRedPackViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,UITextFieldDelegate,AgentManagerDelegate,XYTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *jinQbtn;

@property (weak, nonatomic) IBOutlet UIButton *jinsSbtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disImgLeft;

@property (weak, nonatomic) IBOutlet UIImageView *imgBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisBottom;

@property (weak, nonatomic) IBOutlet UITableView *personListView;

@property (weak, nonatomic) IBOutlet UIButton *quanXBtn;

@property (weak, nonatomic) IBOutlet MGLabel *countLab;
@property (weak, nonatomic) IBOutlet UIButton *faRedPackBtn;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *tfSearchKey;
@property (weak, nonatomic) IBOutlet UIButton *SearchChange;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeight;

@end


@implementation SendRedPackViewController{
    NSMutableArray <RedPackCircleModal *>* dataArray;
    NSMutableArray <RedPackCircleModal *>* selectArray;
    NSInteger page;
    BOOL  searchSH;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发红包";
    [self setSearchButtonItems];
    self.faRedPackBtn.layer.masksToBounds = YES;
    self.faRedPackBtn.layer.cornerRadius = 4;
    dataArray = [NSMutableArray arrayWithCapacity:0];
    selectArray = [NSMutableArray arrayWithCapacity:0];
    if ([self isIphoneX]) {
        self.topViewHeight.constant = 88;
        self.viewDisTop.constant = 88;
        self.viewDisBottom.constant = 38;
        self.searchViewHeight.constant = 131;
    }else{
        self.viewDisTop.constant = 64;
        self.topViewHeight.constant = 64;
        self.viewDisBottom.constant = 0;
        self.searchViewHeight.constant = 107;
    }
    [self setTableView];
    [self setTextFiled];
    [self actionRiQi:self.jinQbtn];
    self.searchView.hidden = YES;
    [self loadNewData];
    // Do any additional setup after loading the view from its nib.
}

-(void)setSearchButtonItems{
    UIBarButtonItem *itemSearch = [self creatBarItem:@" 搜索" icon:@"sousuo" andFrame:CGRectMake(0, 10, 58, 58) andAction:@selector(pressToSearch)];
    self.navigationItem.rightBarButtonItems = @[itemSearch];
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

//进入搜索页面,清空所有数据
- (void)pressToSearch {
    self.navigationController.navigationBar.hidden = YES;
    self.searchView.hidden = NO;
    [self animationEndFrame];
    [UIView animateWithDuration:0.3f animations:^{
        [self animationBeginFrame];
    } completion:^(BOOL finished) {
        [self animationBeginFrame];
    }];
    [dataArray removeAllObjects];
    [selectArray removeAllObjects];
    [_personListView reloadData];
    searchSH = NO;
    [self updateBottomView];
}

- (void)cleanKeyWord {
    self.tfSearchKey.text = @"";
    [selectArray removeAllObjects];
    [dataArray removeAllObjects];
    [_personListView reloadData];
    [self updateBottomView];
}

- (void)updateBottomView {
    self.countLab.text = [NSString stringWithFormat:@"共%ld人",selectArray.count];
    self.countLab.keyWord = [NSString stringWithFormat:@"%ld",selectArray.count];
    self.countLab.keyWordColor = RGBCOLOR(254, 165, 19);
    if (selectArray.count == dataArray.count && selectArray.count > 0) {
        self.quanXBtn.selected = YES;
    } else {
        self.quanXBtn.selected = NO;
    }
    if (selectArray.count > 0) {
        self.faRedPackBtn.userInteractionEnabled = YES;
        self.faRedPackBtn.alpha = 1.0f;
    }else {
        self.faRedPackBtn.userInteractionEnabled = NO;
        self.faRedPackBtn.alpha = 0.4f;
    }
}

#pragma mark    UITableView

-(void)setTableView{
    self.personListView.delegate = self;
    self.personListView.dataSource = self;
    self.personListView.rowHeight = 64;
    [self.personListView registerNib:[UINib nibWithNibName:KSendPedPackCell bundle:nil] forCellReuseIdentifier:KSendPedPackCell];
    self.agentMan.delegate =self;
    self.personListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [UITableView refreshHelperWithScrollView:self.personListView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
}

-(void )listAgentTotaldelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self.personListView tableViewEndRefreshCurPageCount:array.count];
    if (page ==1 ) {
        [dataArray removeAllObjects];
    }
    if (success == NO) {
        [self  showPromptViewWithText:msg hideAfter:1.8];
        [self.personListView reloadData];
        return;
    }else{
        if (array .count == 0) {
            [self.personListView reloadData];
            return;
        }
    }
    for (NSDictionary *itemDic in array) {
        RedPackCircleModal *model = [[RedPackCircleModal alloc]initWith:itemDic];
        model.isSelect = NO;
        [dataArray addObject:model];
    }
    [self.personListView reloadData];
    [self updateBottomView];
}

- (void)loadNewData{
    [selectArray removeAllObjects];
    if (self.searchView.hidden == NO && self.tfSearchKey.text.length == 0) {
        [self.personListView tableViewEndRefreshCurPageCount:KpageSize];
        return;
    }
    page = 1;
    [self.agentMan listAgentTotal: @{@"agentId":self.curUser.agentInfo._id,@"days":@([self setSearchDay]),@"page":@(page),@"pageSize":@(KpageSize),@"nickName":[self setNickNameStr],@"mobile":[self setMobileStr]}];
}

- (void)loadMoreData{
    if (self.searchView.hidden == NO && self.tfSearchKey.text.length == 0) {
        [self.personListView tableViewEndRefreshCurPageCount:KpageSize];
        return;
    }
    page++;
    [self.agentMan listAgentTotal: @{@"agentId":self.curUser.agentInfo._id,@"days":@([self setSearchDay]),@"page":@(page),@"pageSize":@(KpageSize),@"nickName":[self setNickNameStr],@"mobile":[self setMobileStr]}];
    
}

-(NSString *)setMobileStr {
    if (self.searchView.hidden) {
        return @"";
    }else if ([self isNum:self.tfSearchKey.text]){
        return self.tfSearchKey.text;
    }else {
        return @"";
    }
}

-(NSString *)setNickNameStr {
    if (self.searchView.hidden) {
        return @"";
    }else if ([self isNum:self.tfSearchKey.text]){
        return @"";
    }else {
        return self.tfSearchKey.text;
    }
}

-(NSInteger)setSearchDay {
    if (self.searchView.hidden == NO) {
        if (searchSH) {
            return 30;
        }
        return 7;
    } else if (self.jinQbtn.selected){
        return 7;
    }
    return 30;
}

-(BOOL)havData{
    if (self.searchView.hidden == YES) {
        if (dataArray.count == 0) {
            return NO;
        }
        return YES;
    } else {
        if (_tfSearchKey.text.length == 0) {
            return YES;
        } else {
            if (dataArray.count  == 0) {
                return NO;
            }
            return YES;
        }
    }
}

//判断字符串是否为纯数字
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SendPedPackCell *cell = [tableView dequeueReusableCellWithIdentifier:KSendPedPackCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell reloadDate:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPackCircleModal *model = [dataArray objectAtIndex:indexPath.row];
    model.isSelect = !model.isSelect;
    if (model.isSelect) {
        [selectArray addObject:model];
    } else {
        [selectArray removeObject:model];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self updateBottomView];
}


#pragma mark  IBAction

/*
  切换日期时，1，selectArray清空，更新底部view 2，请求新数据，
  3，新数据全部设置为未选 4，刷新tableView
 */
- (IBAction)actionRiQi:(UIButton *)sender {
    [selectArray removeAllObjects];
    [self updateBottomView];
    self.jinQbtn.selected = NO;
    self.jinsSbtn.selected = NO;
    self.disImgLeft.constant = sender.mj_x+10;
    [UIView animateWithDuration:0.5 animations:^{
        [self.imgBottom.superview layoutIfNeeded];
    }];
    sender.selected = YES;
    [self loadNewData];
    [self.personListView reloadData];
    
}

/*
 点击全选  1，之前是未选中的 selectArray移除所有，dataArray遍历，全部设置成已选，
            将dataArray copy 到 selectArray
         2，之前是已经选中的 selectArray移除所有 dataArray遍历，全部设置成未选
         3，刷新tableView
         4, 更新底部数据框
 */
- (IBAction)actionQuanX:(UIButton *)sender {
    sender.selected = !sender.selected;
    [selectArray removeAllObjects];
    for (RedPackCircleModal *person in dataArray) {
        person.isSelect = sender.isSelected;
    }
    if (sender.selected) {
        selectArray = [dataArray mutableCopy];
    }
    [self.personListView reloadData];
    [self updateBottomView];
}

- (IBAction)actionToSendRed:(id)sender {
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
    for (RedPackCircleModal *model in selectArray) {
        [array addObject:model.cardCode];
    }
    SendRedViewController *sendVC = [[SendRedViewController alloc]init];
    sendVC.circleMember = [array copy];
    [self.navigationController pushViewController:sendVC animated:YES];
  //  selectArray   选中的人
}

- (IBAction)actionToSearchS:(id)sender {
    if ([self.SearchChange.titleLabel.text isEqualToString:@"切换至近30日"]) {
        searchSH = YES;
        [self.SearchChange setTitle:@"切换至近7日" forState:UIControlStateNormal];
    } else {
        searchSH = NO;
        [self.SearchChange setTitle:@"切换至近30日" forState:UIControlStateNormal];
    }
    [self loadNewData];
}

- (IBAction)returnSearchView:(id)sender {
    self.navigationController.navigationBar.hidden = NO;
    self.tfSearchKey.text = @"";
    [self animationBeginFrame];
    [UIView animateWithDuration:0.3f animations:^{
        [self animationEndFrame];
    } completion:^(BOOL finished) {
        [self animationBeginFrame];
        self.searchView.hidden = YES;
        [self loadNewData];
    }];
}

- (IBAction)actionSearch:(id)sender {
    [selectArray removeAllObjects];
    [dataArray removeAllObjects];
    [self.personListView reloadData];
    if (self.tfSearchKey.text.length == 0) {
        [self showPromptText:@"昵称不能为空" hideAfterDelay:1.9];
        return;
    }
    [self loadNewData];
}

- (void)animationBeginFrame{
    self.searchView.frame = CGRectMake(0, self.searchView.mj_y, self.searchView.mj_w, self.searchView.mj_h);
    self.personListView.frame = CGRectMake(0, self.personListView.mj_y, self.personListView.mj_w, self.personListView.mj_h);
}


- (void)animationEndFrame{
    self.searchView.frame = CGRectMake(KscreenWidth, self.searchView.mj_y, self.searchView.mj_w, self.searchView.mj_h);
    self.personListView.frame = CGRectMake(KscreenWidth, self.personListView.mj_y, self.personListView.mj_w, self.personListView.mj_h);
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

@end
