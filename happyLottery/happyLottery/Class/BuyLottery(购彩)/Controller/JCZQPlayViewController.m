//
//  JCZQPlayViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/11.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQPlayViewController.h"
#import "JCZQMatchViewCell.h"
#import "BaseProfile.h"
#import "WBButton.h"
#import "WebCTZQHisViewController.h"
#import "MatchLeagueSelectView.h"
#import "LotteryProfileSelectView.h"
#import "JCZQSelectAllPlayTypeVIew.h"
#import "JCZQTouZhuViewController.h"
#import "JCZQTranscation.h"
#import "JCZQMatchModel.h"
#import "JCZQLeaModel.h"

#import "JCZQSelectBQCVIew.h"
#import "JCZQSelectBFVIew.h"
#import "OptionSelectedView.h"
#import "UMChongZhiViewController.h"
#import "YuCeSchemeCreateViewController.h"
#import "FootBallPlayViewController.h"
#import "DiscoverViewController.h"
#import "PayOrderViewController.h"
#define KJCZQMatchViewCell @"JCZQMatchViewCell"
@interface JCZQPlayViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryProfileSelectViewDelegate,LotteryManagerDelegate,JCZQMatchViewCellDelegate,JCZQSelectVIewDelegate,MatchLeagueSelectViewDelegate,OptionSelectedViewDelegate>

{
    NSInteger numBackNum;  //未用
    MatchLeagueSelectView * matchSelectView;  //赛事选择view
    LotteryProfileSelectView *profileSelectView;//过关单关玩法选择框
    JCZQMatchModel *curShowModel;
    
}
@property (weak, nonatomic) IBOutlet UILabel *labSelectInfo;
@property (weak, nonatomic) IBOutlet UITableView *tabJCZQListView;
@property(nonatomic,strong)NSMutableArray *arrayTableSectionIsOpen;// section 展开或者关闭
@property (nonatomic,strong)NSMutableArray <BaseProfile * > *profiles;  //玩法配置
@property (weak, nonatomic) IBOutlet UIButton *btnTouzhu;
@property (weak, nonatomic) IBOutlet UILabel *labSummary;
@property(nonatomic,strong)NSMutableArray<NSMutableArray <JCZQMatchModel *> * > *matchArray;//服务器请求的所有赛事
@property(nonatomic,strong)NSMutableArray<JCZQLeaModel * > *leaArray;  //联赛名称
@property(nonatomic,strong)JCZQTranscation  *trancation;
@property(nonatomic,strong)NSMutableArray<NSMutableArray <JCZQMatchModel *> * > *showArray;//最终展示出来的赛事
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisBottom;

@end

@implementation JCZQPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // iPhone X 适配
    if ([self isIphoneX]) {
        self.viewDisBottom .constant = 34;
    }else{
        self.viewDisBottom.constant = 0;
    }
//    if ([self.curUser.whitelist boolValue] == NO) {
//        _btnTouzhu.hidden = YES;
//    }
    numBackNum = 0; //未用
    self.viewControllerNo = @"A001";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanMatch:) name:KSELECTMATCHCLEAN object:nil];
    self.matchArray = [NSMutableArray arrayWithCapacity:0];
    self.showArray = [NSMutableArray arrayWithCapacity:0];
    self.lotteryMan.delegate = self;
    [self getCurlotteryProfiles];
    [self setTableView];
    [self setVCInfo];  //未用
    [self setRightBarItems];
    [self setTitleView];
//    [self.tabJCZQListView reloadData];
    [self getLeaArray]; //获取联赛名称
    [self setSummary];
    self.btnTouzhu.layer.cornerRadius = 5;
    
}

-(void)cleanMatch:(NSNotification*)notification{
//    if (self.trancation.playType == JCZQPlayTypeGuoGuan) {
//        if (self.trancation.selectMatchArray.count <= 2) {
//            return;
//        }
//    }else{
//        if (self.trancation.selectMatchArray.count <=1) {
//            return;
//        }
//    }
    JCZQMatchModel *model = (JCZQMatchModel*)notification.object;
    if (model == nil) {
        [self cleanAllSelectMatch];
    }
    [self updataSummary];
    [self.tabJCZQListView reloadData];
}

-(void)setSummary{
    if (self.trancation.playType == JCZQPlayTypeGuoGuan) {
        self.labSummary.text = @"至少选择2场比赛";
    }else{
        self.labSummary.text = @"至少选择1场比赛";
    }
}

-(void)getLeaArray{
    [self showLoadingText:@"正在加载"];
    [self.lotteryMan getJczqLeague:nil];
    
}

-(void)gotJczqLeague:(NSArray *)dataArray errorMsg:(NSString *)msg{
    if (self.leaArray == nil) {
        self.leaArray = [[NSMutableArray alloc]init];
    }
    if (dataArray == nil || dataArray.count == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
    }else{
        for (NSDictionary * dic in dataArray) {
            JCZQLeaModel *model = [[JCZQLeaModel alloc]initWith:dic];
            [self.leaArray addObject:model];
        }
         [self loadMatch];
         [self createUI];
    }
}


//请求所有赛事
-(void)loadMatch{

    [self.lotteryMan getJczqMatch:@{@"leagueIds":@[]}];
    
}

-(void)gotJczqMatch:(NSArray *)dataArray errorMsg:(NSString *)msg{
    if (dataArray == nil || dataArray.count == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
    }else{
        [self.matchArray removeAllObjects];
        [self.showArray removeAllObjects];
        //按照 matchDate 进行分组
        for (NSDictionary *itemDic in dataArray) {
            BOOL isExit = NO;
            JCZQMatchModel *model = [[JCZQMatchModel alloc]initWith:itemDic];
            model.leagueName = [self getLeaName:model.leagueId];
            for (NSMutableArray *itemArray in self.matchArray) {
                JCZQMatchModel *firstModel = [itemArray firstObject];
                if (firstModel == nil || model.matchDate == nil) {
                    break;
                }
                
                if ([firstModel.matchDate isEqualToString:model.matchDate]) {
                    [itemArray addObject:model];
                    isExit = YES;
                    break;
                }
            }
            
            if (isExit == NO) {
                NSMutableArray  *marray = [NSMutableArray arrayWithCapacity:0];
                [self.arrayTableSectionIsOpen addObject:@(YES)];
                [marray addObject:model];
                [self.matchArray addObject:marray];
            }
        }
        self.showArray = [self.matchArray mutableCopy];
        [self loadMatchSP];
        if (self.playType == JCZQPlayTypeDanGuan) {
            [self lotteryProfileSelectViewDelegate:self.trancation.curProfile andPlayType:JCZQPlayTypeDanGuan andRes:@"1"];
        }
    }
  
}

-(void)lookMatchForCurPlayType:(NSInteger)ind andGuanType:(JCZQPlayType)type{
    self.showArray = [NSMutableArray arrayWithCapacity:0];
    
    if ([self.trancation.curProfile.Desc isEqualToString:@"HHGG"]) {
        
        for (int i = 0; i<self.matchArray.count; i++) {
            NSMutableArray *array = self.matchArray[i];
            NSMutableArray *showArray = [NSMutableArray arrayWithCapacity:0];
            if (array.count>0) {
                
                
                for (int j = 0; j<array.count; j++) {
                    JCZQMatchModel *model = array[j];
                    [showArray addObject:model];
                    model.isDanGuan = NO;
                }
                
                
            }
            [self.showArray addObject:showArray];
        }
        
    }else{
        
        for (int i = 0; i<self.matchArray.count; i++) {
            NSMutableArray *array = self.matchArray[i];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
            for (int j = 0; j<array.count; j++) {
                JCZQMatchModel *model = array[j];
                NSString* flag = [model.openFlag substringWithRange:NSMakeRange(ind, 1)];
                if (type == JCZQPlayTypeDanGuan) {
                    if ([flag isEqualToString:@"1"]||[flag isEqualToString:@"0"]) {
                        model.isDanGuan = YES;
                        [temp addObject:model];
                    }
                }else{
                    if ([flag isEqualToString:@"2"]||[flag isEqualToString:@"0"]) {
                        
                        
                        if ([flag isEqualToString:@"2"]) {
                            model.isDanGuan = NO;
                        }else{
                            model.isDanGuan = YES;
                        }
                        
                        [temp addObject:model];
                    }
                    
                }
                
            }
            if (temp.count>0) {
                [self.showArray addObject:temp];
            }
        }
    }
}

-(void)gotJczqSp:(NSArray *)dataArray errorMsg:(NSString *)msg{
    
    for (NSMutableArray *mArray in self.matchArray) {
        for (JCZQMatchModel *model in mArray) {
            for (NSDictionary *spDic in dataArray) {
                if ([spDic[@"matchKey"] integerValue] == [model.matchKey integerValue]) {
                    NSString *funname = [NSString stringWithFormat:@"set%@_OddArray:",spDic[@"playType"]];
                    NSArray *sps = [Utility objFromJson:spDic[@"sp"]];
                    SEL function = NSSelectorFromString(funname);
                    if ([model respondsToSelector:function]) {
                         [model performSelector:function withObject:sps];
                    }

                    NSString *funname1 = [NSString stringWithFormat:@"set%@_ChangeArray:",spDic[@"playType"]];
                    NSArray *sps1 = [Utility objFromJson:spDic[@"changed"]];
                    SEL function1 = NSSelectorFromString(funname1);
                    if ([model respondsToSelector:function1]) {
                        [model performSelector:function1 withObject:sps1];
                    }
                }
            }
        }
    }
    [self hideLoadingView];
    [self. tabJCZQListView reloadData];
}

-(void)netCommplet{
    
    
}

//联赛名称
-(NSString *)getLeaName:(NSString *)_id{
    for (JCZQLeaModel *model in _leaArray) {
        if ([model._id integerValue] == [_id integerValue]) {
            return model.name;
        }
    }
    return @"足球";
}

-(void)loadMatchSP{
    [self.lotteryMan getJczqSp:nil];
}

-(void)setTitleView{
    self.trancation = [[JCZQTranscation alloc]init];
    self.profiles = [NSMutableArray arrayWithCapacity:0];
    
    // 下拉button设置
    WBButton * titleBtn = [WBButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 10, 150, 40);
    [titleBtn addTarget:self action:@selector(showProfileType) forControlEvents:UIControlEventTouchUpInside];
    if (self.playType == JCZQPlayTypeDanGuan) {
        [titleBtn setTitle:@"单场混投" forState:0];
    }else{
        [titleBtn setTitle:@"混合过关" forState:0];
    }
    
    [titleBtn setImage:[UIImage imageNamed:@"wanfaxiala"] forState:0];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    //赛事选择框
    if (profileSelectView == nil) {
        profileSelectView = [[LotteryProfileSelectView alloc]initWithFrame:CGRectMake(0, NaviHeight, KscreenWidth, KscreenHeight - 64)];
    }
    [profileSelectView setPlayVIew:self.playType];
    
    profileSelectView.frame = CGRectMake(0, NaviHeight, KscreenWidth, KscreenHeight - 64);
    profileSelectView.delegate = self;
    [self getCurlotteryProfiles];
    profileSelectView.lotteryPros = self.profiles;
    profileSelectView.hidden = YES;
    if (self.playType == JCZQPlayTypeDanGuan) {
        self.trancation.playType = JCZQPlayTypeDanGuan;
        self.trancation.curProfile = self.profiles[4];
        self.trancation.curProfile.Title = @"单场混投";
    }else{
        self.trancation.playType = JCZQPlayTypeGuoGuan;
        self.trancation.curProfile = self.profiles[4];
    }
    
    
    [self.view addSubview:profileSelectView];
    self.navigationItem.titleView = titleBtn;
}

-(void)showProfileType{
    profileSelectView.hidden = !profileSelectView.hidden;
}

-(void) getCurlotteryProfiles{
    //LotteryProfilesConfig.plist   玩法切换配置文件
    NSDictionary *allLottery = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryProfilesConfig" ofType: @"plist"]];
    NSArray *profiles = allLottery[@"jczq"];
    for (NSDictionary *dic in profiles) {
        JCZQProfile *mod = [[JCZQProfile alloc]initWith:dic];
        [self.profiles addObject:mod];
    }
}

-(void)setRightBarItems{

    UIBarButtonItem *itemQuery = [self creatBarItem:@" 助手" icon:@"helper.png" andFrame:CGRectMake(0, 10, 65, 25) andAction:@selector(optionRightButtonAction)];
    UIBarButtonItem *itemCleanLeague = [self creatBarItem:@"" icon:@"liansaixuanze" andFrame:CGRectMake(0, 10, 25, 25)andAction:@selector(actionSelectLeague)];
    self.navigationItem.rightBarButtonItems = @[itemQuery,itemCleanLeague];
}

- (void) optionRightButtonAction {

    NSArray *titleArr = @[@" 开奖详情",
                         @" 玩法规则"];
    CGFloat optionviewWidth = 100;
    CGFloat optionviewCellheight = 38;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    
    OptionSelectedView *optionView = [[OptionSelectedView alloc] initWithFrame:CGRectMake(mainSize.width - optionviewWidth, DisTop, optionviewWidth, optionviewCellheight * titleArr.count) andTitleArr:titleArr];
    
    optionView.delegate = self;
    [self.view.window addSubview:optionView];
    
}

- (void)optionDidSelacted:(OptionSelectedView *)optionSelectedView andIndex:(NSInteger)index{
    if (index == 1) {
        //clear selection
        [self actionPlayTypeRecom];
        NSLog(@"玩法");
    }else if (index == 0){
        //        [self showExtrendViewCtr];
        [self showWinHistoryViewCtr];
        NSLog(@"开奖历史");
    }else if (index == 2){
        //
    }
}
- (void) showWinHistoryViewCtr{
    WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/jzOpenAward",H5BaseAddress];
    playViewVC.pageUrl = [NSURL URLWithString:strUrl];
    playViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playViewVC animated:YES];
}

-(void)actionPlayTypeRecom{
    FootBallPlayViewController *footBallPlayVC = [[FootBallPlayViewController alloc]init];
    [self.navigationController pushViewController:footBallPlayVC animated:YES];
    
}

-(void)createUI{
    if (matchSelectView == nil) {
         matchSelectView = [[MatchLeagueSelectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    matchSelectView.delegate = self;
    [matchSelectView loadMatchLeagueInfo:self.leaArray];
    
    matchSelectView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:matchSelectView];
}



-(void)actionSelectLeague{
    matchSelectView.hidden = NO;
    [matchSelectView setLabSelectNumText: [self getMatchNum:self.showArray] ];
}

-(void)selectedLeagueItem:(NSArray *)leaTitleArray{
    [self lotteryProfileSelectViewDelegate:self.trancation.curProfile andPlayType:self.trancation.playType andRes:@"2"];
//    for (NSMutableArray *marray in self.showArray) {
    for (int i = 0; i < self.showArray.count; i++ ) {
        NSMutableArray *marray = self.showArray[i];
//            for (JCZQMatchModel *model in marray) {
         for (int j = 0; j < marray.count; j++ ) {
             JCZQMatchModel *model = marray[j];
                if (![leaTitleArray containsObject:model.leagueName]) {
                    [marray removeObject:model];
                    j--;
                }
            }
        if (marray.count == 0) {
            [self.showArray removeObject:marray];
            i--;
        }
    }
    
    [self.tabJCZQListView reloadData];
}

-(void)selectedLeagueItem:(NSArray *)leaTitleArray andGetNum:(GetLeaMatchNum)block{
    [self selectedLeagueItem:leaTitleArray];
   
    block([self getMatchNum:self.showArray]);
}

//展示比赛数目
-(NSInteger)getMatchNum:(NSMutableArray *)showArray{
    NSInteger numMatch = 0;
    for (NSMutableArray *matchArray in showArray) {
        numMatch +=matchArray.count;
    }
    return numMatch;
}

-(void)setVCInfo{ //未用



}

-(void)setTableView{
    
    self.arrayTableSectionIsOpen = [NSMutableArray arrayWithArray:@[@(YES),@(YES),@(YES),@(YES),@(YES),@(YES),@(YES),@(YES)]];
    self.tabJCZQListView.delegate = self;
    self.tabJCZQListView.dataSource = self;
    [self.tabJCZQListView registerClass:[JCZQMatchViewCell class] forCellReuseIdentifier:KJCZQMatchViewCell];
    [self.tabJCZQListView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  LotteryProfileSelectViewDelegate

-(void)lotteryProfileSelectViewDelegate:(JCZQProfile *)lotteryPros andPlayType:(JCZQPlayType)playType andRes:(NSString *)res{
    if ([res isEqualToString:@"1"]) {
        [matchSelectView refreshItemState];
    }
    WBButton * titleBtn = (WBButton*)self.navigationItem.titleView;
   
    if (![self.trancation.curProfile.Title isEqualToString:lotteryPros.Title] || self.trancation.playType != playType) {
        [self cleanAllSelectMatch];
    }
    self.trancation.curProfile = lotteryPros;
    self.trancation.playType = playType;
    [titleBtn setTitle:lotteryPros.Title forState:0];
    
    
    if ([self.trancation.curProfile.Desc isEqualToString:@"SPF"]) {
        
        [self lookMatchForCurPlayType:0 andGuanType:self.trancation.playType];
        
    } else if ([self.trancation.curProfile.Desc isEqualToString:@"RQSPF"]) {
        
        [self lookMatchForCurPlayType:4 andGuanType:self.trancation.playType];
        
    } else if ([self.trancation.curProfile.Desc isEqualToString:@"BQC"]) {
        
         [self lookMatchForCurPlayType:3 andGuanType:self.trancation.playType];
        
    } else if ([self.trancation.curProfile.Desc isEqualToString:@"JQS"]) {
        
        [self lookMatchForCurPlayType:1 andGuanType:self.trancation.playType];
        
    } else if ([self.trancation.curProfile.Desc isEqualToString:@"BF"]) {
        
        [self lookMatchForCurPlayType:2 andGuanType:self.trancation.playType];
        
    } else if ([self.trancation.curProfile.Desc isEqualToString:@"HHGG"]) {
        
        [self lookMatchForCurPlayType:-1 andGuanType:self.trancation.playType];
    }
    [matchSelectView setLabSelectNumText:[self getMatchNum:self.showArray]];
    
    [self updataSummary];
    
    [self.tabJCZQListView reloadData];
}

-(void)cleanAllSelectMatch{
    self.trancation.beitou = @"5";
    for (NSMutableArray *marrya in self.matchArray) {
        for (JCZQMatchModel *model in marrya) {
            if (model.isSelect == YES) {
                [model cleanAll];
            }
        }
    }
}

#pragma UITableViewDelegate,UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL isOpen = [self.arrayTableSectionIsOpen[section] boolValue];
    if (isOpen ) {
        return self.showArray[section].count;
    }else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.showArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JCZQMatchViewCell * cell = [tableView dequeueReusableCellWithIdentifier:KJCZQMatchViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell reloadDataMatch:self.showArray[indexPath.section][indexPath.row] andProfileTitle:self.trancation.curProfile.Desc andGuoguanType:self.trancation.playType];
    if (self.showArray[indexPath.section][indexPath.row].isShow == YES) {
        [cell refreshWithYcInfo:self.showArray[indexPath.section][indexPath.row].ycModel];
    }
   
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updataSummary];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_showArray[indexPath.section][indexPath.row].isShow == YES) {

        return 230;
    }else{
        
        return 120;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    JCZQMatchModel *firstMod = [self.showArray[section] firstObject];
    TableHeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"TableHeaderView" owner:nil options:nil] lastObject];
    header.backgroundColor =RGBCOLOR(245, 245, 245);
    header.labTime.text = firstMod.matchDate;
    NSString *strMatchInfo =[NSString stringWithFormat:@"共有%ld场比赛可投",self.showArray[section].count];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:strMatchInfo];
    [attrStr addAttribute:NSForegroundColorAttributeName value:SystemGreen range:NSMakeRange(2, strMatchInfo.length - 7)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, strMatchInfo.length)];
    header.labMatchInfo.attributedText = attrStr;
    header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    
    header.btnActionClick.tag = section;
    [header.btnActionClick addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.arrayTableSectionIsOpen [section] boolValue] == YES) {
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_up"]];
    }else{
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    return header;
}

//点击下拉
-(void)headerViewClick:(UIButton *)btn{
    [UIView animateWithDuration:1.0 animations:^{
        BOOL isOpen = [self.arrayTableSectionIsOpen[btn.tag] boolValue];
        if (isOpen == YES) {
            [self.arrayTableSectionIsOpen setObject:@(NO) atIndexedSubscript:btn.tag];
            
        }else{
            [self.arrayTableSectionIsOpen setObject:@(YES) atIndexedSubscript:btn.tag];
        }
        [self.tabJCZQListView reloadData];
    }];
}

- (IBAction)actionTouzhu:(id)sender {
    
    
    [self.trancation.selectMatchArray removeAllObjects];
    JCZQTouZhuViewController *touzhuVC = [[JCZQTouZhuViewController alloc]init];
    touzhuVC.fromSchemeType = self.fromSchemeType;
    for (NSMutableArray *marray in self.showArray) {
        for (JCZQMatchModel *model in marray) {
            if (model.isSelect) {
                [self.trancation.selectMatchArray addObject:model];
            }
        }
    }
    NSString *errorMsg = [self couldTouzhu];
    if (errorMsg) {
        [self showPromptText:errorMsg hideAfterDelay:2.0];
        return;
    }
    
    touzhuVC.transction = self.trancation;
    [self.navigationController pushViewController:touzhuVC animated:YES];
}


-(NSString *)couldTouzhu{
    if (self.trancation.selectMatchArray.count >15 ) {
        return @"最多只能选15场比赛";
    }
    if (self.trancation.playType == JCZQPlayTypeDanGuan) {
        if (self.trancation.selectMatchArray.count < 1) {
            return  @"单关模式下，至少选择一场比赛";
        }
    }
    if (self.trancation.playType == JCZQPlayTypeGuoGuan) {
        if (self.trancation.selectMatchArray.count < 2 ) {
//            if(self.trancation.selectMatchArray.count ==1){
//                JCZQMatchModel *model = [self.trancation.selectMatchArray firstObject];
//                if (model.isDanGuan == YES) {
//                    self.trancation.chuanFa = @"单场";
//                    return nil;
//                }
//                return  @"过关模式下，至少选择两场比赛";
//
//            }else{
                return  @"过关模式下，至少选择两场比赛";
//            }
            
        }
    }
    return nil;
}

#pragma JCZQMatchViewCellDelegate
-(void)showAllPlayType:(JCZQMatchModel *)model :(NSDictionary *)titleDic{
    JCZQSelectAllPlayTypeVIew * matchSelectView = [[JCZQSelectAllPlayTypeVIew alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:matchSelectView];
    matchSelectView.delegate = self;
    [matchSelectView loadAllItemTitle:model andTitleDic:titleDic];
    
}

-(void)JCZQPlayViewSelected{
    
    [self .tabJCZQListView reloadData];
    [self updataSummary];
}

-(void)showSPFARQSPFSelecedMsg:(NSString *)msg{
    if (msg != nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
    }
    [self updataSummary];
    
}

-(NSInteger)getSelectMatchNum{
    NSInteger selectNum = 0;
    for (NSMutableArray *matchArray in self.showArray) {
        for (JCZQMatchModel *model in matchArray) {
            if ([model isSelect] == YES) {
                selectNum ++;
            }
        }
    }
    return selectNum;
}

-(void)updataSummary{
    if ([self getSelectMatchNum] == 0) {
        [self setSummary];
    }else{
        
        self.labSummary.text = [NSString stringWithFormat:@"已经选择%ld场比赛",[self getSelectMatchNum]];
    }
}

-(void)showBFPlayType:(JCZQMatchModel *)model :(NSDictionary *)titleDic{
    
    JCZQSelectBFVIew * matchSelectView = [[JCZQSelectBFVIew alloc]initWithFrame:[UIScreen mainScreen].bounds];
    matchSelectView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:matchSelectView];
    [matchSelectView loadAllItemTitle:model andTitleDic:titleDic];
    
}

-(void)showBQCPlayType:(JCZQMatchModel *)model :(NSDictionary *)titleDic{
    
    JCZQSelectBQCVIew * matchSelectView = [[JCZQSelectBQCVIew alloc]initWithFrame:[UIScreen mainScreen].bounds];
    matchSelectView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:matchSelectView];
    [matchSelectView loadAllItemTitle:model andTitleDic:titleDic];
    
}

- (IBAction)acitonCleanAll:(id)sender {
    [self cleanAllSelectMatch];
    [self updataSummary];
    [self.tabJCZQListView reloadData];
}

-(void)showForecastDetailForCellBottom:(JCZQMatchModel *)model{
    [self.tabJCZQListView reloadData];
    curShowModel = model;
    if (model.isShow) {
        if (model.matchKey == nil) {
            [self showPromptText:@"该场比赛暂无预测信息" hideAfterDelay:1.7];
            return;
        }
        [self.lotteryMan getForecastByMatch:@{@"lotteryCode":@"jczq",@"matchKey":model.matchKey}];
    }
}

-(void)gotForecastByMatch:(NSDictionary *)resDic errorMsg:(NSString *)msg{
    if (resDic == nil) {
        [self showPromptText:@"该场比赛暂无预测信息" hideAfterDelay:1.7];
        return;
    }
    HomeYCModel *model = [[HomeYCModel alloc]initWithDic:resDic];
    curShowModel.ycModel = model;
    [self.tabJCZQListView reloadData];
    
}


-(void)showMatchDetailWith:(HomeYCModel *)model{
    UMChongZhiViewController *matchDetailVC = [[UMChongZhiViewController alloc]init];
    matchDetailVC.model = [model jCZQScoreZhiboToJcForecastOptions]  ;
    if (model == nil) {
        [self showPromptText:@"暂无详情" hideAfterDelay:1.7];
        return;
    }
    matchDetailVC.curPlayType = @"jczq";
    [self.navigationController pushViewController:matchDetailVC animated:YES];
}

-(void)showSchemeRecom{
    YuCeSchemeCreateViewController *vc = [[YuCeSchemeCreateViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)canBuyThisMatch:(JCZQMatchModel *)model andIndex:(NSInteger)ind{
    NSString* flag = [model.openFlag substringWithRange:NSMakeRange(ind, 1)];
    if (self.trancation.playType ==JCZQPlayTypeDanGuan ) {
        if ([flag isEqualToString:@"1"]||[flag isEqualToString:@"0"]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        if ([flag isEqualToString:@"2"]||[flag isEqualToString:@"0"]) {
            
            return YES;
        }else{
            return NO;
        }
        
    }
    
}

- (void)navigationBackToLastPage{
    for (UIViewController *controller in self.navigationController.viewControllers) {\
        NSLog(@"---%@----",controller);
        if ([controller isKindOfClass:[DiscoverViewController class]]) {
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [super navigationBackToLastPage];
}

@end
