  //
//  GYJPlayViewController.m
//  Lottery
//
//  Created by 王博 on 2018/3/12.
//  Copyright © 2018年 AMP. All rights reserved.
//

#import "GYJPlayViewController.h"
#import "WCHomeGYJItemViewCell.h"
#import "HomeGJItemViewCell.h"
#import "SelectView.h"
#import "MGLabel.h"
#import "GYJLeagueSelectView.h"
#import "WebViewController.h"
#import "GYJTransaction.h"

#define KHomeGJItemViewCell @"HomeGJItemViewCell"
#define KWCHomeGYJItemViewCell  @"WCHomeGYJItemViewCell"

@interface GYJPlayViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,GYJLeagueSelectViewDelegate>{
    UIView *gyjSelectedView;
    UIButton* btnGJ;
    UIButton* btnGYJ;
    NSString* createTime;
    BOOL isShowGJ;
    GYJLeagueSelectView * matchSelectView;
}
@property (weak, nonatomic) IBOutlet SelectView *beiSelectView;

@property (weak, nonatomic) IBOutlet UITableView *gyjListTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property(nonatomic,strong)NSMutableArray <WordCupHomeItem *> * gjSellArray;

@property(nonatomic,strong)NSMutableArray <WordCupHomeItem *> *groupList;

@property (weak, nonatomic) IBOutlet MGLabel *alreadySelected;
@property (weak, nonatomic) IBOutlet MGLabel *labSchemeInfo;
@property (weak, nonatomic) IBOutlet MGLabel *labMaxBouns;
@property (weak, nonatomic) IBOutlet UITextField *tfBeiCount;
@property(strong,nonatomic)GYJTransaction *transaction;

@property(nonatomic,strong)NSMutableArray <WordCupHomeItem *> * gjSelectedArray;
@end

@implementation GYJPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableViewCell];
    self.gjSellArray = [NSMutableArray arrayWithCapacity:0];
    self.gjSelectedArray = [NSMutableArray arrayWithCapacity:0];
    self.groupList = [NSMutableArray arrayWithCapacity:0];
    self.lotteryMan.delegate = self;
    [self creatTitleView];
    [self initLable];
    [self setUpRightBtn];
    self.transaction = [[GYJTransaction alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationNameUserLogin object:nil];
}
- (IBAction)lessButton:(id)sender {
    self.tfBeiCount.text = [NSString stringWithFormat:@"%ld",[self.tfBeiCount.text integerValue]-1];
    [self update];
}
- (IBAction)plusButton:(id)sender {
    self.tfBeiCount.text = [NSString stringWithFormat:@"%ld",[self.tfBeiCount.text integerValue]+1];
    [self update];
}

- (IBAction)deleteSelected:(id)sender {
    if (self.gjSelectedArray.count>0) {
        for (WordCupHomeItem *item in self.gjSellArray) {
            if (item.isSelect == YES) {
                item.isSelect = NO;
            }
        }
        [self.gjSelectedArray removeAllObjects];
        [self.gyjListTableView reloadData];
        [self update];
    }
}

#pragma mark DateSource
- (void)refreshlistArray:(NSArray *)infoArray{
    [self hideLoadingView];
    [self.gjSellArray removeAllObjects];
    [self.groupList removeAllObjects];
    [self.gjSelectedArray removeAllObjects];
    [self update];
    for(int i= 0;i<infoArray.count;i++){
        NSDictionary *itemDic = infoArray[i];
        WordCupHomeItem *model = [[WordCupHomeItem alloc]initWith:itemDic];
        createTime = model.createTime;
        [self.gjSellArray addObject:model];
        [self.groupList addObject:model];
    }
    [self.gyjListTableView reloadData];
}

- (void)gotlistJcgjSellItem:(NSArray *)infoArray errorMsg:(NSString *)msg{
    [self refreshlistArray:infoArray];
}

- (void) gotlistJcgyjSellItem:(NSArray *)infoArray  errorMsg:(NSString *)msg
{
    [self refreshlistArray:infoArray];
}

-(void)setTableViewCell{
    self.gyjListTableView.delegate = self;
    self.gyjListTableView.dataSource = self;
     [self.gyjListTableView registerNib:[UINib nibWithNibName:KHomeGJItemViewCell bundle:nil] forCellReuseIdentifier:KHomeGJItemViewCell];
      [self.gyjListTableView registerNib:[UINib nibWithNibName:KWCHomeGYJItemViewCell bundle:nil] forCellReuseIdentifier:KWCHomeGYJItemViewCell];
}

-(void) reloadDate:(BOOL)isShowGJ{
    [self showLoadingViewWithText:@"正在加载"];
    if (isShowGJ) {
       
        [self.lotteryMan listJcgjSellItem:nil];
    } else {
      
        [self.lotteryMan listJcgyjSellItem:nil];
    }
    
}

-(void)selectedLeagueItem:(NSArray *)leaTitleArray{
    [self.gjSellArray removeAllObjects];
    if (leaTitleArray.count == 0) {
        for (WordCupHomeItem *item in self.groupList) {
            item.isSelect = NO;
            [self.gjSellArray addObject:item];
        }
    }else{
        for (WordCupHomeItem *item in self.groupList) {
            item.isSelect = NO;
            for (NSNumber *index in leaTitleArray) {
                if ([item.guanKey integerValue]== [index integerValue] ||[item.yaKey integerValue]== [index integerValue] ) {
                    if (![self.gjSellArray containsObject:item]) {
                        
                        [self.gjSellArray addObject:item];
                    }
                }
            }
        }
        
    }
    [self.gyjListTableView reloadData];
}

#pragma mark TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.gjSellArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.gjSellArray[indexPath.row].isSelect = !self.gjSellArray[indexPath.row].isSelect;
    if (self.gjSellArray[indexPath.row].isSelect) {
        [self.gjSelectedArray addObject:self.gjSellArray[indexPath.row]];
    } else {
        [self.gjSelectedArray removeObject:self.gjSellArray[indexPath.row]];
    }
    [self update];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (isShowGJ) {
        HomeGJItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHomeGJItemViewCell];
//        [HomeGJItemViewCell cellWithTableView:tableView];
        NSString *strRow = [NSString stringWithFormat:@"%ld",indexPath.row +1];
        [cell loadDataWith:self.gjSellArray[indexPath.row] strRow:strRow];
        cell.backgroundColor = RGBCOLOR(245, 245, 245);
        return cell;
    }
    else {
//        WCHomeGYJItemViewCell *cell = [WCHomeGYJItemViewCell  cellWithTableView:tableView];
        HomeGJItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KWCHomeGYJItemViewCell];
        NSString *strRow = [NSString stringWithFormat:@"%ld",indexPath.row +1];
        [cell loadDataWith:self.gjSellArray[indexPath.row] strRow:strRow];
        cell.backgroundColor = RGBCOLOR(245, 245, 245);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isShowGJ) {
        return 75;
    }
    else {
        return 82;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //设置 title 区域高度
    return 30.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor =RGBCOLOR(245, 245, 245);
    //设置 title 区域
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.contentSize.width, 20)];
    //设置 title 文字内容
    titleLabel.text = createTime;
    //设置 title 颜色
    titleLabel.textColor = RGBCOLOR(141, 141, 141);
    [view addSubview:titleLabel];
    return view;
}

#pragma mark ClickAction

- (void)actionPlayTypeSelect:(UIButton *)button
{
    self.transaction.beiCount = 5;
    [matchSelectView refreshItemState];
    [button setTitleColor:SystemGreen forState:0];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];
    
    if ([button isEqual:btnGJ]) {//点击冠军
        isShowGJ = YES;
        [btnGYJ setTitleColor:[UIColor whiteColor] forState:0];
        [btnGYJ setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    }
    else{
        isShowGJ = NO;
        [btnGJ setTitleColor:[UIColor whiteColor] forState:0];
        [btnGJ setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    }
    [self reloadDate:[button isEqual:btnGJ]];
    [self update];
    [self setUpRightBtn];
}

-(void)actionRightItemClick{
    [self.tfBeiCount resignFirstResponder];
    [self createUI];
}

#pragma mark UI设置

-(UIBarButtonItem *)creatBarItem:(NSString *)title icon:(NSString *)imgName andFrame:(CGRect)frame andAction:(SEL)action{
    UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btnItem.frame = frame;
    if (title != nil) {
        [btnItem setTitle:title forState:0];
    }
    
    if (imgName != nil) {
        [btnItem setImage:[UIImage imageNamed:imgName] forState:0];
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btnItem];
    return barItem;
}

- (void)pressplayIntroduce{
    WebViewController *webVC = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    webVC.type = @"html";
    if (isShowGJ) {
        webVC.title = @"冠军玩法规则介绍";
        webVC.htmlName = @"gjplaytype";
    }else{
        webVC.title = @"冠亚军玩法规则介绍";
        webVC.htmlName = @"gyjplaytype";
    }
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)pressselectGroup{
    [self.tfBeiCount resignFirstResponder];
    [self createUI];
}

- (void)setUpRightBtn{
    
    UIBarButtonItem *playIntroduce = [self creatBarItem:@"" icon:@"wanfajieshao" andFrame:CGRectMake(0, 10, 25, 25) andAction:@selector(pressplayIntroduce)];
    UIBarButtonItem *selectGroup = [self creatBarItem:@"" icon:@"liansaixuanze" andFrame:CGRectMake(0, 10, 25, 25)andAction:@selector(pressselectGroup)];
    
    if (isShowGJ) {
        self.navigationItem.rightBarButtonItems = @[playIntroduce];
    } else {
        self.navigationItem.rightBarButtonItems = @[selectGroup,playIntroduce];
    }
}

- (IBAction)yuyue:(id)sender {
    self.transaction.schemeSource = @"BET";
    self.transaction.betSource = @"2";
//    if (self.curUser == nil || self.curUser.isLogin == NO) {
//        [self needLogin];
//        return;
//    }
//    if (self.gjSelectedArray.count == 0) {
//        return;
//    }
    
}

-(void)createUI{
    if (matchSelectView == nil) {
        matchSelectView = [[GYJLeagueSelectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    matchSelectView.delegate = self;
    matchSelectView.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:matchSelectView];
}

-(void)initLable {
    self.alreadySelected.text = @"至少选择一种";
    self.tfBeiCount.text = @"5";
    self.labSchemeInfo.text = [NSString stringWithFormat:@"0注%ld倍,共0元",[self.tfBeiCount.text integerValue]];
    self.labMaxBouns.text = [NSString stringWithFormat:@"预计奖金:0元"];
}

-(void)update{
    NSInteger selectNum = 0;
    CGFloat maxBouns = 0;
    for (WordCupHomeItem *item in self.gjSellArray) {
        if (item.isSelect == YES) {
            selectNum ++;
            if ([item.odds doubleValue] > maxBouns) {
                maxBouns =[item.odds doubleValue];
            }
        }
    }
    self.alreadySelected.text = [NSString stringWithFormat:@"已选%ld场对阵",selectNum];
    self.alreadySelected.keyWord = [NSString stringWithFormat:@"%ld",selectNum];
    self.alreadySelected.keyWordColor = SystemRed;
    self.labSchemeInfo.text = [NSString stringWithFormat:@"%ld注%ld倍,共%ld元",selectNum,[self.tfBeiCount.text integerValue],selectNum * [self.tfBeiCount.text integerValue] * 2];
    self.labSchemeInfo.keyWord = [NSString stringWithFormat:@"%ld",selectNum * [self.tfBeiCount.text integerValue] * 2];
    self.labSchemeInfo.keyWordColor = TEXTGRAYOrange;
    if(selectNum==0){
        self.labMaxBouns.text = [NSString stringWithFormat:@"预计奖金：0元"];
        return;
    }
    self.labMaxBouns.text = [NSString stringWithFormat:@"预计奖金：%ld-%.2f元",selectNum * [self.tfBeiCount.text integerValue] * 2,maxBouns * 2 * [self.tfBeiCount.text integerValue]];
}

//设置冠亚军切换按钮
- (void)creatTitleView{
    if(gyjSelectedView != nil){
        return;
    }
    gyjSelectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 164, 38)];
    gyjSelectedView.backgroundColor = SystemGreen;
    gyjSelectedView.layer.cornerRadius = 20;
    gyjSelectedView.layer.masksToBounds = YES;
    gyjSelectedView.layer.borderColor = [UIColor whiteColor].CGColor;
    gyjSelectedView.layer.borderWidth = 1;
    btnGJ = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGJ.layer.cornerRadius = 18;
    btnGJ.layer.masksToBounds = YES;
    [btnGJ setTitle:@"冠军" forState:0];
    [btnGJ setTitleColor:SystemGreen forState:UIControlStateSelected];
    [btnGJ setTitleColor:[UIColor whiteColor] forState:0];
    [btnGJ setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [btnGJ setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    [btnGJ setFrame: CGRectMake(4, 4, 76, 29)];
    btnGJ.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnGJ addTarget: self action:@selector(actionPlayTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnGYJ = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGYJ.layer.cornerRadius = 18;
    btnGYJ.layer.masksToBounds = YES;
    btnGYJ.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnGYJ setTitle:@"冠亚军" forState:0];
    [btnGYJ setTitleColor:SystemGreen forState:UIControlStateSelected];
    [btnGYJ setTitleColor:[UIColor whiteColor] forState:0];
    [btnGYJ setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [btnGYJ setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:0];
    [btnGYJ setFrame: CGRectMake(84, 4, 76, 29)];
    [gyjSelectedView addSubview:btnGJ];
    [gyjSelectedView addSubview:btnGYJ];
    [btnGYJ addTarget: self action:@selector(actionPlayTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = gyjSelectedView;
    [self actionPlayTypeSelect:btnGJ];
}

@end

