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

#define KSendPedPackCell   @"SendPedPackCell"

@interface SendRedPackViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,UITextFieldDelegate>

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

@end

@implementation SendRedPackViewController{
    NSMutableArray <RedPackCircleModal *>* dataArray;
    NSMutableArray <RedPackCircleModal *>* selectArray;
    NSInteger page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发红包";
    [self setSearchButtonItems];
    self.faRedPackBtn.layer.masksToBounds = YES;
    self.faRedPackBtn.layer.cornerRadius = 4;
    [self actionRiQi:self.jinQbtn];
//    dataArray = [NSMutableArray arrayWithCapacity:0];
//    selectArray = [NSMutableArray arrayWithCapacity:0];
    if ([self isIphoneX]) {
        self.viewDisTop.constant = 88;
        self.viewDisBottom.constant = 38;
    }else{
        self.viewDisTop.constant = 64;
        self.viewDisBottom.constant = 0;
    }
    [self setTableView];
    [self setTextFiled];
    self.searchView.hidden = YES;
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
    [dataArray removeAllObjects];
    [selectArray removeAllObjects];
    [_personListView reloadData];
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
}

#pragma mark    UITableView

-(void)setTableView{
    self.personListView.delegate = self;
    self.personListView.dataSource = self;
    self.personListView.rowHeight = 64;
    [self.personListView registerNib:[UINib nibWithNibName:KSendPedPackCell bundle:nil] forCellReuseIdentifier:KSendPedPackCell];
    self.lotteryMan.delegate =self;
//    [UITableView refreshHelperWithScrollView:self.personListView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
}

- (void)loadNewData{
    page = 1;
    
}

- (void)loadMoreData{
    page++;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.jinQbtn.selected) return 7;
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SendPedPackCell *cell = [tableView dequeueReusableCellWithIdentifier:KSendPedPackCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userNameLab.text = [NSString stringWithFormat:@"%ld",indexPath.row];
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
    
}

- (IBAction)returnSearchView:(id)sender {
    self.searchView.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
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
