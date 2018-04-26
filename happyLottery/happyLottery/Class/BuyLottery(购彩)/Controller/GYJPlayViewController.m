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
#import "PayOrderViewController.h"

#define KHomeGJItemViewCell @"HomeGJItemViewCell"
#define KWCHomeGYJItemViewCell  @"WCHomeGYJItemViewCell"

@interface GYJPlayViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,GYJLeagueSelectViewDelegate,UITextFieldDelegate>{
    UIView *gyjSelectedView;
    UIButton* btnGJ;
    UIButton* btnGYJ;
    NSString* createTime;
    BOOL isShowGJ;
    GYJLeagueSelectView * matchSelectView;
    BOOL showJQ;
    UIView * gYJview;
    UIButton *playIntroduce;
    UIButton *selectGroup;
}
@property (weak, nonatomic) IBOutlet SelectView *beiSelectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisTop;

@property (weak, nonatomic) IBOutlet UITableView *gyjListTableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property(nonatomic,strong)NSMutableArray <WordCupHomeItem *> * gjSellArray;

@property(nonatomic,strong)NSMutableArray <WordCupHomeItem *> *groupList;

@property (weak, nonatomic) IBOutlet MGLabel *alreadySelected;
@property (weak, nonatomic) IBOutlet MGLabel *labSchemeInfo;
@property (weak, nonatomic) IBOutlet MGLabel *labMaxBouns;
@property (weak, nonatomic) IBOutlet UITextField *tfBeiCount;
@property (weak, nonatomic) IBOutlet MGLabel *labCount;
@property(strong,nonatomic)GYJTransaction *transaction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisBottom;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic,strong)NSMutableArray <WordCupHomeItem *> * gjSelectedArray;
@property(nonatomic,strong)Lottery *lottery;
@end

@implementation GYJPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isIphoneX]) {
        self.viewDisTop .constant = 88;
        self.viewDisBottom.constant = 34;
    }else{
        self.viewDisBottom.constant = 0;
        self.viewDisTop .constant = 64;
    }
    
    
    self.viewControllerNo = @"A009";
    [self setTableViewCell];
    self.gjSellArray = [NSMutableArray arrayWithCapacity:0];
    self.gjSelectedArray = [NSMutableArray arrayWithCapacity:0];
    self.groupList = [NSMutableArray arrayWithCapacity:0];
    if (self.lotteryMan == nil) {
        self.lotteryMan = [[LotteryManager alloc]init];
    }
    self.lotteryMan.delegate = self;
    self.tfBeiCount.delegate = self;
   
    self.lottery = [self.lotteryMan getAllLottery][8];
    
    [self navigationBarInit];
    [self actionPlayTypeSelect:btnGJ];
//    [self setUpRightBtn];
//    [self setUpLeftBtn];
    [self initLable];
    self.transaction = [[GYJTransaction alloc]init];
    
}

//自定义navigationBar
- (void)navigationBarInit{
    gYJview = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, DisTop)];
    UIImageView *itemImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_guanyajun_beijing"]];
    itemImage.contentMode =UIViewContentModeScaleToFill;
    itemImage.frame = gYJview.frame;
    itemImage.contentMode= UIViewContentModeScaleToFill;
    [gYJview addSubview:itemImage];
    [self.navigationBar addSubview:gYJview];
    [self creatTitleView];
    [self setRightButton];
    [self setLeftButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self showLoadingText:nil];
    self.navigationController.navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NotificationNameUserLogin object:nil];
}

- (void)returnToRootView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark DateSource
- (void)refreshlistArray:(NSArray *)infoArray{
  
    [self.gjSellArray removeAllObjects];
    [self.groupList removeAllObjects];
    [self.gjSelectedArray removeAllObjects];
    [self initLable];
    for(int i= 0;i<infoArray.count;i++){
        NSDictionary *itemDic = infoArray[i];
        WordCupHomeItem *model = [[WordCupHomeItem alloc]initWith:itemDic];
        [self.gjSellArray addObject:model];
        [self.groupList addObject:model];
    }
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
    if (isShowGJ) {
        self.alreadySelected.text = [NSString stringWithFormat:@"已选%ld场球队",selectNum];
    } else {
        self.alreadySelected.text = [NSString stringWithFormat:@"已选%ld场对阵",selectNum];
    }
    self.alreadySelected.keyWord = [NSString stringWithFormat:@"%ld",selectNum];
    self.alreadySelected.keyWordColor = SystemRed;
    
    self.labSchemeInfo.text = [NSString stringWithFormat:@"%ld注%ld倍,",selectNum,[self.tfBeiCount.text integerValue]];
    
    self.labCount.text = [NSString stringWithFormat:@"共%ld元",selectNum * [self.tfBeiCount.text integerValue] * 2];
    self.labCount.keyWord = [NSString stringWithFormat:@"%ld",selectNum * [self.tfBeiCount.text integerValue] * 2];
    self.labCount.keyWordColor = TEXTGRAYOrange;
    
    if(selectNum==0){
        self.labMaxBouns.text = [NSString stringWithFormat:@"最高可中：0元"];
        return;
    }
    self.labMaxBouns.text = [NSString stringWithFormat:@"最高可中：%.2f元",maxBouns * 2 * [self.tfBeiCount.text integerValue]];
}

- (void)gotlistJcgjSellItem:(NSArray *)infoArray errorMsg:(NSString *)msg{
    showJQ = YES;
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":self.lottery.identifier}];
    [self refreshlistArray:infoArray];
}

- (void) gotlistJcgyjSellItem:(NSArray *)infoArray  errorMsg:(NSString *)msg

{
    showJQ = YES;
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":self.lottery.identifier}];
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
    //查看奖期

    if (isShowGJ) {
        [self.lotteryMan listJcgjSellItem:nil];
    } else {
        [self.lotteryMan listJcgyjSellItem:nil];
    }
}

-(void)selectedLeagueItem:(NSArray *)leaTitleArray{
    [self.gjSellArray removeAllObjects];
    [self.gjSelectedArray removeAllObjects];
    [self initLable];
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
        [cell loadDataWith:self.gjSellArray[indexPath.row]];
        cell.backgroundColor = RGBCOLOR(245, 245, 245);
        return cell;
    }
    else {
        HomeGJItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KWCHomeGYJItemViewCell];
        [cell loadDataWith:self.gjSellArray[indexPath.row]];
        cell.backgroundColor = RGBCOLOR(245, 245, 245);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isShowGJ) {
        return 72;
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
    if (createTime.length>0) {
        if (![createTime isEqualToString:@"奖期不在售"]&&![createTime containsString:@"截止"]) {
            createTime = [NSString stringWithFormat:@"%@截止",createTime];
        }
        titleLabel.text = createTime;
    }
    //设置 title 颜色
    titleLabel.textColor = RGBCOLOR(141, 141, 141);
    [view addSubview:titleLabel];
    return view;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text integerValue] ==0) {
        textField.text = @"1";
    }
    textField.text = [NSString stringWithFormat:@"%ld",[textField .text integerValue]];
    [self updateTextField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString*numStr = [[NSMutableString alloc]initWithString:textField.text];
    [numStr appendString:string];
    NSInteger num = [numStr integerValue];
    NSInteger limitNum;

    limitNum = 9999;
    if (num > limitNum) {
        return NO;
    }
    if (num<1) {
        return NO;
    }
    
    if ([textField.text isEqualToString:@""]&&[string isEqualToString:@"0"]) {
        return NO;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSString * regex;
    regex = @"^[0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

- (void)updateTextField{
    [self update];
}

#pragma mark ClickAction

- (void)actionPlayTypeSelect:(UIButton *)button
{
    [self.gyjListTableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.transaction.beiCount = 5;
    [matchSelectView refreshItemState];
    [button setTitleColor:SystemGreen forState:0];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];
    
    if ([button isEqual:btnGJ]) {//点击冠军
        self.lottery = [self.lotteryMan getAllLottery][8];
        isShowGJ = YES;
        [btnGYJ setTitleColor:[UIColor whiteColor] forState:0];
        [btnGYJ setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:0];
    }
    else{
        self.lottery = [self.lotteryMan getAllLottery][9];
        isShowGJ = NO;
        [btnGJ setTitleColor:[UIColor whiteColor] forState:0];
        [btnGJ setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:0];
    }
    [self reloadDate:[button isEqual:btnGJ]];
    [self initLable];
    if (isShowGJ) {
        selectGroup.hidden=YES;
    } else {
        selectGroup.hidden=NO;
    }
}

-(void)actionRightItemClick{
    [self.tfBeiCount resignFirstResponder];
    [self createUI];
}


//点击预约
- (IBAction)yuyue:(id)sender {
    // 是否在售
    self.transaction.costType = CostTypeCASH;
    [self gyjCurrentRound];
}

- (IBAction)lessButton:(id)sender {
    if ([self.tfBeiCount.text integerValue] <=1 ) {
        return;
    }
    self.tfBeiCount.text = [NSString stringWithFormat:@"%ld",[self.tfBeiCount.text integerValue]-1];
    [self update];
}

- (IBAction)plusButton:(id)sender {
    if ([self.tfBeiCount.text integerValue] ==9999 ) {
        return;
    }
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
        [self initLable];
    }
}

- (void)pressPlayIntroduce{
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

- (void)pressSelectGroup{
    [self.tfBeiCount resignFirstResponder];
    [self createUI];
}

#pragma mark UI设置

//-(UIBarButtonItem *)creatBarItem:(NSString *)title icon:(NSString *)imgName andFrame:(CGRect)frame andAction:(SEL)action{
//    UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnItem addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
//    btnItem.frame = frame;
//    if (title != nil) {
//        [btnItem setTitle:title forState:0];
//    }
//    
//    if (imgName != nil) {
//        [btnItem setImage:[UIImage imageNamed:imgName] forState:0];
//    }
//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btnItem];
//    return barItem;
//}

- (UIButton*)creatBar:(NSString *)title icon:(NSString *)imgName andFrame:(CGRect)frame andAction:(SEL)action{
    UIButton *btnItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btnItem.frame = frame;
    if (title != nil) {
        [btnItem setTitle:title forState:0];
    }
    
    if (imgName != nil) {
        [btnItem setImage:[UIImage imageNamed:imgName] forState:0];
    }
    return btnItem;
}

- (void)setRightButton {
    playIntroduce = [self creatBar:@"" icon:@"wanfajieshao" andFrame:CGRectMake(self.view.frame.size.width - 35, DisTop - 40, 25, 25) andAction:@selector(pressPlayIntroduce)];
    selectGroup = [self creatBar:@"" icon:@"liansaixuanze" andFrame:CGRectMake(self.view.frame.size.width-50-20, DisTop - 40, 25, 25)andAction:@selector(pressSelectGroup)];
    [gYJview addSubview:playIntroduce];
    [gYJview addSubview:selectGroup];
    if (isShowGJ) {
        selectGroup.hidden=YES;
    } else {
        selectGroup.hidden=YES;
    }
}

//- (void)setUpRightBtn{
//    UIBarButtonItem *playIntroduce = [self creatBarItem:@"" icon:@"wanfajieshao" andFrame:CGRectMake(0, 10, 25, 25) andAction:@selector(pressPlayIntroduce)];
//    UIBarButtonItem *selectGroup = [self creatBarItem:@"" icon:@"liansaixuanze" andFrame:CGRectMake(0, 10, 25, 25)andAction:@selector(pressSelectGroup)];
//    if (isShowGJ) {
//        self.navigationItemView.rightBarButtonItems = @[playIntroduce];
//    } else {
//        self.navigationItemView.rightBarButtonItems = @[playIntroduce,selectGroup];
//    }
//}

- (void)setLeftButton{
    UIButton *returnToRoot = [self creatBar:@"" icon:@"common_top_bar_back" andFrame:CGRectMake(20,DisTop - 33 , 12,18) andAction:@selector(returnToRootView)];
    [gYJview addSubview:returnToRoot];
}

//- (void)setUpLeftBtn{
//    UIBarButtonItem *returnToRoot = [self creatBarItem:@"" icon:@"common_top_bar_back" andFrame:CGRectMake(10, (60-18)/2, 12,18) andAction:@selector(returnToRootView)];
//    self.navigationItemView.leftBarButtonItems = @[returnToRoot];
//}

//奖期
-(void)gotSellIssueList:(NSArray *)infoDic errorMsg:(NSString *)msg{
    self.lottery.currentRound = [infoDic firstObject];
    self.transaction.lottery.currentRound = [infoDic firstObject];
//    if (infoDic == nil || infoDic .count == 0) {
//
//        createTime = @"奖期不在售";
//        [self showPromptText:msg hideAfterDelay:1.9];
//    }
    if (showJQ) {
        if ([self.lottery.currentRound isExpire] ||![self.lottery.currentRound.sellStatus isEqualToString:@"ING_SELL"]||infoDic == nil || infoDic .count == 0) {
            createTime = @"奖期不在售";
        } else {
            createTime = self.lottery.currentRound.stopTime;
        }
        [self.gyjListTableView reloadData];
        [self hideLoadingView];
        return;
    }
    if ([self.lottery.currentRound isExpire] ||![self.lottery.currentRound.sellStatus isEqualToString:@"ING_SELL"]||infoDic == nil || infoDic .count == 0) {
        [self showPromptText:@"奖期不在售" hideAfterDelay:2.0];
        return;
    }
    //无选项
    if (self.gjSelectedArray.count == 0) {
        [self showPromptText:@"请至少选择一项" hideAfterDelay:2.0];
        return;
    }
    if ([self.tfBeiCount.text isEqualToString:@""]||[self.tfBeiCount.text isEqualToString:@"0"]) {
        [self showPromptText:@"倍数必须为1-9999" hideAfterDelay:2.0];
        return;
    }
    //在售有选项
    //1.存储数据
    self.transaction.schemeSource = SchemeSourceBet;
    self.transaction.betSource = @"2";
    self.transaction.beiCount = [_tfBeiCount.text integerValue];
    if (self.transaction.beiCount == 0) {
        self.transaction.beiCount = 1;
    }
    if (isShowGJ) {
        self.transaction.playType = LotteryGJ;
    } else {
        self.transaction.playType = LotteryGYJ;
    }
    if (self.transaction.selectArray.count!=0) {
        [self.transaction.selectArray removeAllObjects];
    }
    self.transaction.selectArray = [self.gjSelectedArray mutableCopy];
    //    2.判断用户状态
    if (self.curUser == nil || self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    //登陆状态
    self.transaction.betCost = self.transaction.selectArray.count * 2 * self.transaction.beiCount;
    self.transaction.betCount = self.transaction.selectArray.count;
    [self showLoadingViewWithText:@"正在提交"];
    self.transaction.schemeType = SchemeTypeZigou;
    self.transaction.lottery = self.lottery;
    if (self.transaction.betCost > 300000) {
        [self showPromptText:@"单注投注金额不得超过30万" hideAfterDelay:2];
        return;
    }
    [self.lotteryMan betLotteryScheme:self.transaction];
}

- (void) betedLotteryScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    if (schemeNO == nil || schemeNO.length == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    PayOrderViewController *payVC = [[PayOrderViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;
    if (isShowGJ) {
        schemeCashModel.lotteryName = @"冠军";
    } else {
        schemeCashModel.lotteryName = @"冠亚军";
    }
    schemeCashModel.schemeNo = schemeNO;
    schemeCashModel.subCopies = 1;
    schemeCashModel.costType = CostTypeCASH;
    if (self.transaction.betCost  > 300000) {
        [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
        return;
    }
    [self hideLoadingView];
    schemeCashModel.subscribed = self.transaction.betCost;
    schemeCashModel.realSubscribed = self.transaction.betCost;
    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)gyjCurrentRound{
    [self showLoadingText:@"正在提交订单"];
    showJQ = NO;
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":self.lottery.identifier}];
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
    if (isShowGJ) {
        self.alreadySelected.text = @"已选0场球队";
    } else {
        self.alreadySelected.text = @"已选0场对阵";
    }
    self.alreadySelected.keyWord =@"0";
    self.alreadySelected.keyWordColor = SystemRed;
    self.tfBeiCount.text = @"5";
    self.tfBeiCount.textColor = TEXTGRAYOrange;
    self.labSchemeInfo.text = [NSString stringWithFormat:@"0注%ld倍,",[self.tfBeiCount.text integerValue]];
    self.labCount.text = [NSString stringWithFormat:@"共0元"];
    self.labMaxBouns.text = [NSString stringWithFormat:@"最高可中:0元"];
    self.labCount.keyWord = [NSString stringWithFormat:@"0"];
    self.labCount.keyWordColor = TEXTGRAYOrange;
}


//设置冠亚军切换按钮
- (void)creatTitleView{
    if(gyjSelectedView != nil){
        return;
    }
    gyjSelectedView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-82, DisTop - 40, 164,  30)];
    gyjSelectedView.backgroundColor = [UIColor clearColor];
    
    gyjSelectedView.layer.cornerRadius = 16;
    gyjSelectedView.layer.masksToBounds = YES;
    gyjSelectedView.layer.borderColor = [UIColor whiteColor].CGColor;
    gyjSelectedView.layer.borderWidth = 1;
    btnGJ = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGJ.layer.cornerRadius = 11;
    btnGJ.layer.masksToBounds = YES;
    [btnGJ setTitle:@"冠军" forState:0];
    [btnGJ setTitleColor:SystemGreen forState:UIControlStateSelected];
    [btnGJ setTitleColor:[UIColor whiteColor] forState:0];
    [btnGJ setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [btnGJ setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [btnGJ setFrame: CGRectMake(4, 4, 76, 22)];
    btnGJ.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnGJ addTarget: self action:@selector(actionPlayTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnGYJ = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGYJ.layer.cornerRadius = 11;
    btnGYJ.layer.masksToBounds = YES;
    btnGYJ.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnGYJ setTitle:@"冠亚军" forState:0];
    [btnGYJ setTitleColor:SystemGreen forState:UIControlStateSelected];
    [btnGYJ setTitleColor:[UIColor whiteColor] forState:0];
    [btnGYJ setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [btnGYJ setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
    [btnGYJ setFrame: CGRectMake(84, 4, 76, 22)];
    [gyjSelectedView addSubview:btnGJ];
    [gyjSelectedView addSubview:btnGYJ];
    [btnGYJ addTarget: self action:@selector(actionPlayTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.titleView = gyjSelectedView;
    [gYJview addSubview:gyjSelectedView];
}

#pragma mark 工具方法


@end

