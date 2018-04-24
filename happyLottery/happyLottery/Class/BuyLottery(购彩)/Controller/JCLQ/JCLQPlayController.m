//
//  JCLQPlayController.m
//  Lottery
//
//  Created by 王博 on 16/8/16.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQPlayController.h"
#import "LotteryProfileSelectView.h"
#import "LotteryTitleView.h"

#import "BaseCell.h"
#import "JCLQDXFCell.h"
#import "JCLQSFCCell.h"
#import "WBButton.h"
#import "JCLQHHTZCell.h"
#import "JCLQSFCell.h"
#import "JCLQRFSFCell.h"
#import "JCLQMatchModel.h"
#import "HHTZAllPlayType.h"
#import "JCLQSFCPlayTypeView.h"
#import "JCLQMatchModel.h"
#import "TableHeaderView.h"
#import "LotteryInstructionDetailViewController.h"

#import "ZLAlertView.h"

#import "OptionSelectedView.h"
#import "JCLQTouZhuController.h"
#import "JCLQTransaction.h"
#import "JCLQLotteryProfileSelectView.h"
#import "WebCTZQHisViewController.h"
#import "UITableView+XY.h"
typedef enum : NSUInteger {
    NotCanBuyTypeTimeCanNotBuy,
    NotCanBuyTypeCountCanNotBuy,
    NotCanBuyTypeCanBuy,
} NotCanBuyType;

@interface JCLQPlayController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,LotteryTitleViewDelegate,JCLQLotteryProfileSelectViewDelegate,JCLQCellDelegate,OptionSelectedViewDelegate>
{
    AppDelegate *appDelegate;
    LotteryTitleView *_titleView;
    JCLQLotteryProfileSelectView *profileSelectView;
    JCLQTransaction *transaction;
    OptionSelectedView *optionView;
    
    NSInteger indexOdd;
    
}

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray *showArray;
@property(nonatomic,strong)GlobalInstance *instance;
@property (weak, nonatomic) IBOutlet UITableView *tabPlayList;
@property (weak, nonatomic) IBOutlet UILabel *labPlayInfo;
@property(strong,nonatomic) NSString *curActivePlayType;

@property(strong,nonatomic)NSMutableArray *openRow;
@property(strong,nonatomic)NSMutableArray *profiles;
@property(strong,nonatomic)NSMutableArray *allTimeDate;
@end

@implementation JCLQPlayController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.profiles = [NSMutableArray arrayWithCapacity:0];
    self.viewControllerNo = @"A002";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanMatch:) name:KSELECTMATCHCLEAN object:nil];
    indexOdd = 0;
    self.curUser = [[GlobalInstance instance] curUser];
    self.showArray = [NSMutableArray arrayWithCapacity:0];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
    [self setUp];
    [self loadUI];
    self.lotteryMan.delegate = self;
    self.allTimeDate = [NSMutableArray arrayWithCapacity:0];
    self.tabPlayList.delegate = self;
    
    self.tabPlayList.dataSource = self;
    self.tabPlayList.rowHeight = 100;
    self.tabPlayList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabPlayList.bounces = NO;
    [self.tabPlayList reloadData];
    self.openRow = [NSMutableArray arrayWithCapacity:0];
    transaction = [[JCLQTransaction alloc]init];
    transaction.guanType = JCLQGuanTypeGuoGuan;
    [self .lotteryMan getJclqMatch:nil];
    [self showLoadingText:@"正在加载"];
    [self setRightBarItems];
    [self setSummary];
    [self setTitleView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(acitonDeleteMatchForTouzhu:) name:@"NSNotificationDeleteMatchForPlay" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleanAllSelect) name:@"NSNotificationDeleteAll" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabViewRefreshData:) name:@"NSNotificationCenterTouzhuReloadData" object:nil];
}

- (void) optionRightButtonAction {
    //    if (isShowFLag) {
    //        return;
    //    }
    
    NSArray *titleArr = @[@" 开奖详情",
                          @" 玩法规则"];
    CGFloat optionviewWidth = 100;
    CGFloat optionviewCellheight = 38;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    if (optionView == nil) {
           optionView = [[OptionSelectedView alloc] initWithFrame:CGRectMake(mainSize.width - optionviewWidth, 64, optionviewWidth, optionviewCellheight * titleArr.count) andTitleArr:titleArr];
    }else{
        optionView.hidden = NO;
    }
    
    optionView.delegate = self;
    [self.view.window addSubview:optionView];
}

-(void)setTitleView{
    if (transaction == nil) {
        transaction = [[JCLQTransaction alloc]init];
    }
    
    self.profiles = [NSMutableArray arrayWithCapacity:0];
    WBButton * titleBtn = [WBButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 10, 150, 40);
    [titleBtn addTarget:self action:@selector(showProfileType) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setTitle:@"混合过关" forState:0];
    [titleBtn setImage:[UIImage imageNamed:@"wanfaxiala"] forState:0];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    if (profileSelectView == nil) {
        profileSelectView = [[JCLQLotteryProfileSelectView alloc]initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64)];
    }
    profileSelectView.frame = CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64);
    profileSelectView.delegate = self;
    [self getCurlotteryProfiles];
    profileSelectView.lotteryPros = self.profiles;
    profileSelectView.hidden = YES;
    
    transaction.guanType = JCLQGuanTypeGuoGuan;
    transaction.curProfile = self.profiles[4];
        transaction.playType = transaction.curProfile.Desc;
    [self.view addSubview:profileSelectView];
    self.navigationItem.titleView = titleBtn;
}

-(void)acitonDeleteMatchForTouzhu:(NSNotification *) notification{
    JCLQMatchModel *match = [notification object];
    for (NSArray *array  in self.dataArray) {
        for (int i = 1; i<=array.count -1 ;i++) {
            JCLQMatchModel *model = array[i];
            if ([model.matchKey isEqual:match.matchKey]) {
                [self matchClean:model.RFSFSelectMatch];
                [self matchClean:model.SFSelectMatch];
                [self matchClean:model.SFCSelectMatch];
                [self matchClean:model.DXFSelectMatch];
            }
        }
    }
}

-(void)tabViewRefreshData:(NSNotification *) notification{
    
  
    [transaction.matchSelectArray removeAllObjects];
    for (NSMutableArray *array in self.showArray) {
        
    
    for (int i = 1 ;i<array.count ;i++) {
        
        JCLQMatchModel *model = array[i];
        NSInteger number = [self sumSelect:model.SFSelectMatch];
        
        
        number += [self sumSelect:model.SFCSelectMatch];
        number += [self sumSelect:model.DXFSelectMatch];
        number += [self sumSelect:model.RFSFSelectMatch];
        
        if (number != 0) {
            [transaction.matchSelectArray addObject:model];
        }
    }
    }
    
    
    
    [self updata];
    [self.tabPlayList reloadData];
}





-(void)loadOdd:(NSInteger)indexFlag{

    if (self.dataArray.count>0) {
        NSArray *array = self.dataArray[indexFlag];
        NSMutableArray *keyArray = [NSMutableArray arrayWithCapacity:0];
        for(int i = 1; i<=array.count-1; i++) {
            JCLQMatchModel*model = array[i];
            [keyArray addObject:model.matchKey];
        }
        [self.lotteryMan getJclqSp:@{@"lotterytype":@"JCLQ",@"playType":[transaction.playType substringFromIndex:4],@"matchDate":array.firstObject,@"matchKey":keyArray}];
    }
}

-(void)gotJclqSp:(NSArray *)OddsArray errorMsg:(NSString *)msg{
    indexOdd ++;
    if (OddsArray.count ==0) {
        [self showPromptText:msg hideAfterDelay:1.9];
        return;
    }
    for (NSDictionary *dic in OddsArray) {
        
        if (![dic isKindOfClass:[NSDictionary class]]) {
            break;
        }
        for (NSMutableArray *modelArray in self.dataArray) {
            
            for (int i = 1; i<=modelArray.count -1; i++) {
                
                JCLQMatchModel *model = modelArray[i];
                
                if ([dic[@"matchKey"] isEqual:model.matchKey]) {
                    if ([dic[@"playType"] isEqualToString:@"SF"] || [dic[@"playType"] isEqualToString:@"HHGG"]) {
                        NSString *spStr = dic[@"sp"];
                        if (spStr .length != 0 && spStr !=nil) {
                            NSString * sp = [spStr substringWithRange:NSMakeRange(1, spStr.length-2)];
                            NSRange r = [sp rangeOfString:@"]"];
                            if (r.length!= 0) {
                                sp = [sp substringToIndex:sp.length-1];
                            }
                            NSRange r1 = [sp rangeOfString:@"["];
                            if (r1.length != 0) {
                                sp = [sp  substringFromIndex:1];
                            }
                            
                            model.SFOddArray = [[sp componentsSeparatedByString:@","] mutableCopy];
//                            NSLog(@"%@",sp);
                        }
                                            }
                    if ([dic[@"playType"] isEqualToString:@"RFSF"] || [dic[@"playType"] isEqualToString:@"HHGG"]) {
                        NSString *spStr = dic[@"sp"];
                        if (spStr .length != 0&&spStr !=nil) {
                            NSString * sp = [spStr substringWithRange:NSMakeRange(1, spStr.length-2)];
                            NSRange r = [sp rangeOfString:@"]"];
                            if (r.length!= 0) {
                                sp = [sp substringToIndex:sp.length-1];
                            }
                            NSRange r1 = [sp rangeOfString:@"["];
                            if (r1.length != 0) {
                                sp = [sp  substringFromIndex:1];
                            }
                            model.RFSFOddArray = [[sp componentsSeparatedByString:@","] mutableCopy];
            
                        }
                    }
                    if ([dic[@"playType"] isEqualToString:@"DXF"] || [dic[@"playType"] isEqualToString:@"HHGG"]) {
                        NSString *spStr = dic[@"sp"];
                        if (spStr .length != 0&&spStr !=nil) {
                            NSString * sp = [spStr substringWithRange:NSMakeRange(1, spStr.length-2)];
                            NSRange r = [sp rangeOfString:@"]"];
                            if (r.length!= 0) {
                                sp = [sp substringToIndex:sp.length-1];
                            }
                            NSRange r1 = [sp rangeOfString:@"["];
                            if (r1.length != 0) {
                                sp = [sp  substringFromIndex:1];
                            }
                            model.DXFSOddArray = [[sp componentsSeparatedByString:@","] mutableCopy];
                            
                            
                        }
                    }
                    if ([dic[@"playType"] isEqualToString:@"SFC"] || [dic[@"playType"] isEqualToString:@"HHGG"]) {
                        NSString *spStr = dic[@"sp"];
                        if (spStr .length != 0&&spStr !=nil) {
                            NSString * sp = [spStr substringWithRange:NSMakeRange(1, spStr.length-2)];
                            NSRange r = [sp rangeOfString:@"]"];
                            if (r.length!= 0) {
                                sp = [sp substringToIndex:sp.length-1];
                            }
                            NSRange r1 = [sp rangeOfString:@"["];
                            if (r1.length != 0) {
                                sp = [sp  substringFromIndex:1];
                            }
                            model.SFCOddArray = [[sp componentsSeparatedByString:@","] mutableCopy];
                            
                            
                        }
                    }
                }
            }
            
        }
    }
    
   
    [self.tabPlayList reloadData];
    for (NSInteger i = indexOdd; i<self.dataArray.count; i++) {
        [self loadOdd:i];
    }
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.tabPlayList reloadData];
     self.curUser = [[GlobalInstance instance] curUser];
    [self updata];
    self.lotteryMan.delegate = self;
    
    
    if ([self.tempResource isEqualToString:@"BetPayViewController"]) {
        [self cleanAllSelect];
        self.tempResource = @"";
        [_tabPlayList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
   self.tabBarController.tabBar.hidden = YES;
}

-(void)getCurlotteryProfiles{
    NSDictionary *allLottery = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryProfilesConfig" ofType: @"plist"]];
    NSArray *profiles = allLottery[@"jclq"];
    for (NSDictionary *dic in profiles) {
        JCZQProfile *mod = [[JCZQProfile alloc]initWith:dic];
        [self.profiles addObject:mod];
    }
}
- (void)setUp{
    //    noDataView.hidden = YES;
    _instance = [GlobalInstance instance];
    
    if (nil == appDelegate) {
        appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    }
    [self getCurlotteryProfiles];
    

}

- (void)gotJclqMatch:(NSArray *)matchArr errorMsg:(NSString *)msg{
    [self hideLoadingView];
    NSMutableArray *tempMArray = [NSMutableArray arrayWithCapacity:0];
    if (matchArr == nil || matchArr.count == 0) {
        [self showPromptText:@"暂无赛事" hideAfterDelay:1.0];
    }else{
        for (NSDictionary *item in matchArr ) {

            int flag = 0;
            JCLQMatchModel *model = [[JCLQMatchModel alloc]initWithDic:item];
            if (model.handicap == nil) {
                model.handicap = @"0";
            }
            
            if (model.hilo == nil) {
                model.hilo = @"0";
            }
            
            for (NSMutableArray *array in tempMArray) {
                if ([[array firstObject] isEqualToString:model.matchDate]) {
                    [array addObject:model];
                    flag = 1;
                    break;
                }
            }
            
            if (flag == 0) {
                NSMutableArray *item = [NSMutableArray arrayWithCapacity:0];
                [item addObject:model.matchDate];
                [item addObject:model];
                [tempMArray addObject:item];
                [self.openRow addObject:@"1"];
            }

            // section data
            self.dataArray = [tempMArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSString * timeFir = [(NSArray *)obj1 firstObject];
                NSString * timeSec = [(NSArray *)obj2 firstObject];
                NSDate * dateFir = [Utility dateFromDateStr:timeFir withFormat:@"yyyy-MM-dd"];
                NSDate * dateSec = [Utility dateFromDateStr:timeSec withFormat:@"yyyy-MM-dd"];
                NSTimeInterval intervalFir = [dateFir timeIntervalSince1970];
                NSTimeInterval intervalSec = [dateSec timeIntervalSince1970];
                if (intervalFir > intervalSec) {
                    return NSOrderedDescending;
                }else{
                    return NSOrderedAscending;
                }
            }];
            
        }
        for (NSArray *time in self.dataArray) {
            [self.allTimeDate addObject:[time firstObject]];
        }
        for (int i = 0; i<self.dataArray.count; i++) {
            [self.showArray addObject:self.dataArray[i]];
        }
        
        
        [self loadOdd:0];
        [self.tabPlayList reloadData];
    }
    
}

#pragma mark - LotteryProfileSelectViewDelegate methods
- (void) userDidSelectLotteryProfile {
    [self cleanAllSelect];
    transaction.playType = transaction.curProfile.Desc;
    
    NSLog(@"当前选择玩法%@",self.lottery.activeProfile.title);
    transaction.beitou = @"5";
    transaction.selectItems = nil;
    if(transaction.guanType == JCLQGuanTypeDanGuan ){
        
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"SF"]) {
            [self lookMatchForCurPlayType:0 andGuanType:JCLQGuanTypeDanGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"RFSF"]) {
            [self lookMatchForCurPlayType:1 andGuanType:JCLQGuanTypeDanGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"DXF"]) {
            [self lookMatchForCurPlayType:3 andGuanType:JCLQGuanTypeDanGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"SFC"]) {
            [self lookMatchForCurPlayType:2 andGuanType:JCLQGuanTypeDanGuan];
        }
        
       
    }else if(transaction.guanType == JCLQGuanTypeGuoGuan){
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"SF"]) {
            [self lookMatchForCurPlayType:0 andGuanType:JCLQGuanTypeGuoGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"RFSF"]) {
            [self lookMatchForCurPlayType:1 andGuanType:JCLQGuanTypeGuoGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"DXF"]) {
            [self lookMatchForCurPlayType:3 andGuanType:JCLQGuanTypeGuoGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"SFC"]) {
            [self lookMatchForCurPlayType:2 andGuanType:JCLQGuanTypeGuoGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"HHGG"]) {
            [self lookMatchForCurPlayType:-1 andGuanType:JCLQGuanTypeGuoGuan];
        }
        
        NSLog(@"当前过关方式！过关！！！");
    }
    indexOdd = 0;
    [self loadOdd:0];
    
    [_titleView updateWithLottery: self.lottery];
    
    [self.tabPlayList reloadData];
//    self.curActivePlayType = self.lottery.activeProfile.desc;

}
-(void)setSummary{
    if (transaction.guanType ==JCLQGuanTypeGuoGuan) {
        self.labPlayInfo.text = @"至少选择2场比赛";
    }else{
        self.labPlayInfo.text = @"至少选择1场比赛";
    }
}

-(void)lookMatchForCurPlayType:(NSInteger)ind andGuanType:(JCLQGuanType)type{
    self.showArray = [NSMutableArray arrayWithCapacity:0];
    
    if ([transaction.playType isEqualToString:@"JCLQHHGG"]) {
        
        for (int i = 0; i<self.dataArray.count; i++) {
            NSMutableArray *array = self.dataArray[i];
            if (array.count>1) {
                
            
            for (int j = 1; j<array.count; j++) {
                JCLQMatchModel *model = array[j];
                model.isDanGuan = NO;
            }
            }
            [self.showArray addObject:self.dataArray[i]];
        }
        
    }else{
    
    for (int i = 0; i<self.dataArray.count; i++) {
        NSMutableArray *array = self.dataArray[i];
         NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
        [temp addObject:[array firstObject]];
        for (int j = 1; j<array.count; j++) {
            JCLQMatchModel *model = array[j];
           
            
            NSString* flag = [model.openFlag substringWithRange:NSMakeRange(ind, 1)];
            if (type ==JCLQGuanTypeDanGuan ) {
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
        if (temp.count>1) {
            [self.showArray addObject:temp];
        }
    }
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  UITableViewDelegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSArray*array= self.showArray[section];
    
    TableHeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"TableHeaderView" owner:nil options:nil] lastObject];
    
    
    header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    header.labTime.text = [array firstObject];
    
    header.labMatchInfo.text = [NSString stringWithFormat:@"共有%zd场赛事可投",array.count-1];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:header.labMatchInfo.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:TextCharColor range:NSMakeRange(2, header.labMatchInfo.text.length - 7)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, header.labMatchInfo.text.length)];
    header.labMatchInfo.attributedText = attrStr;
    
    header.btnActionClick.tag = section;
    [header.btnActionClick addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.openRow [section] isEqualToString:@"1"]) {
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_up"]];
       
    }else{
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    return header;

}


-(void)headerViewClick:(UIButton *)btn{

   NSString *is = self.openRow[btn.tag];
    if ([is isEqualToString:@"1"]) {
        [self.openRow removeObjectAtIndex:btn.tag];
        [self.openRow insertObject:@"0" atIndex:btn.tag];
    }else{
        [self.openRow removeObjectAtIndex:btn.tag];
        [self.openRow insertObject:@"1" atIndex:btn.tag];
    }
    [self.tabPlayList reloadData];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ([self.openRow[section] isEqualToString:@"1"]) {
        NSArray *item = self.showArray[section];
        return item.count-1;
    }else{
        return 0;
    }
    
 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.showArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BaseCell *cell;
    
    if ([transaction.curProfile.Desc isEqualToString:@"JCLQHHGG"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"JCLQHHGG"];
        if (cell == nil) {
            cell = [[JCLQHHTZCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JCLQHHGG"];
        }
    }
    if ([transaction.curProfile.Desc isEqualToString:@"JCLQSF"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"JCLQSF"];
        if (cell == nil) {
            cell = [[JCLQSFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JCLQSF"];
        }
    }
    if ([transaction.curProfile.Desc isEqualToString:@"JCLQRFSF"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"JCLQRFSF"];
        if (cell == nil) {
            cell = [[JCLQRFSFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JCLQRFSF"];
        }
    }
    if ([transaction.curProfile.Desc isEqualToString:@"JCLQSFC"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"JCLQSFC"];
        if (cell == nil) {
            cell = [[JCLQSFCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JCLQSFC"];
        }
        
    }
    if ([transaction.curProfile.Desc isEqualToString:@"JCLQDXF"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"JCLQDXF"];
        if (cell == nil) {
            cell = [[JCLQDXFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JCLQDXF"];
        }
    }
    
    cell.delegate = self;
    
     NSArray*array= self.showArray[indexPath.section];
    JCLQMatchModel *model = array[indexPath.row +1];
    
    [cell loadDataWithModel:model];
    
    //赛事结束，添加遮罩不允许点击
    NotCanBuyType notCanBuy = [self matchCanBuy:model];
    if (!cell.notBuyBtn) {
        cell.notBuyBtn = [[UIButton alloc] initWithFrame:cell.bounds];
        cell.notBuyBtn.backgroundColor = [UIColor clearColor];
        
    }
    
    if(notCanBuy == NotCanBuyTypeCountCanNotBuy){
        if (!model.isSelected) {
            [cell.notBuyBtn addTarget:self action:@selector(canNotbuy:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:cell.notBuyBtn];
        }
    }else if(notCanBuy == NotCanBuyTypeTimeCanNotBuy){
        
        [cell.notBuyBtn addTarget:self action:@selector(canNotbuy:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.notBuyBtn];

    }else{
         [cell.notBuyBtn removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 99.5, CGRectGetWidth(cell.frame), SEPHEIGHT)];
    bottomLine.backgroundColor = SEPCOLOR;
    [cell addSubview:bottomLine];
    return cell;
}
- (NotCanBuyType)matchCanBuy:(JCLQMatchModel *)_match{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *  date =[NSDate date];
    NSString *dateTime = [formatter stringFromDate:date];
    
    NSString * stopTime_ = [_match.stopBuyTime substringToIndex:19];
    //  NSDate * stopTime = [Utility dateFromDateStr:stopTime_ withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (transaction.matchSelectArray.count >= 15) {
        return NotCanBuyTypeCountCanNotBuy;
    }
    
    if ([stopTime_ compare:dateTime] == NSOrderedDescending) {
        
    }else{
        return NotCanBuyTypeTimeCanNotBuy;
    }
    
    return NotCanBuyTypeCanBuy;

}
-(NSInteger)sumSelect:(NSArray*)array{
    NSInteger num = 0;
    for (NSString *item in array) {
        if ([item isEqualToString:@"1"]) {
            num ++;
        }
    }
    return num;
}
- (void)canNotbuy:(UIButton *)sender{
    if (transaction.matchSelectArray.count >= 15) {
        [self showPromptViewWithText:AlertForMotMoreMatchToChoose hideAfter:1.2];
    }else{
        [self showPromptViewWithText:AlertForMatchCannotSelect hideAfter:1.2];
    }
    
}

#pragma -mark 投注限制
- (NSString *)couldTouZhu{
    
    if (transaction.guanType == JCLQGuanTypeDanGuan) {
        if (transaction.matchSelectArray.count < 1) {
            return TextNotEnoughMatchDanGuan;
        }
    }
    if (transaction.guanType == JCLQGuanTypeGuoGuan) {
        if (transaction.matchSelectArray.count < 2 ) {
            if(transaction.matchSelectArray.count ==1){
                JCLQMatchModel *model = [transaction.matchSelectArray firstObject];
                if (model.isDanGuan == YES) {
                    transaction.chuanFa = @"单场";
                    return nil;
                }
            return TextNotEnoughMatchForTouzhu;
            }else{
                return TextNotEnoughMatchForTouzhu;
            }
        
        }
    }
    
    
    return nil;
}

- (IBAction)actionTouZhu:(UIButton *)sender {
    NSString *errorMsg = [self couldTouZhu];
    if (errorMsg) {
        [self showPromptText:errorMsg hideAfterDelay:2.0];
        return;
    }
    
    JCLQTouZhuController *touzhuVC = [[JCLQTouZhuController alloc]init];
    touzhuVC.lottery = self.lottery;
    touzhuVC.transaction = transaction;
    [self.navigationController pushViewController:touzhuVC animated:YES];
}
- (IBAction)actionClean:(UIButton *)sender {
    
    [self cleanAllSelect];
    [self.tabPlayList reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)clickItem:(NSString *)title model:(JCLQMatchModel *)model andIndex:(NSInteger)index{

//    胜负 100 让分胜负 200  大小分 300 胜分差  400  混合投注 500
    BOOL isSelect = NO;
    NSInteger num = index/100;
    
    
    if (model.openFlag .length !=4) {
        model.openFlag = @"3333";
    }
    
    NSString *flag;
    if (num == 4) {
        flag = [model.openFlag substringWithRange:NSMakeRange(2, 1)];
    }else if (num == 3){
        flag = [model.openFlag substringWithRange:NSMakeRange(3, 1)];
    }else{
        flag = [model.openFlag substringWithRange:NSMakeRange(num - 1, 1)];
    }
    
    if ([transaction.playType isEqualToString:@"JCLQHHGG"]) {
        if ([flag isEqualToString:@"3"] || [flag isEqualToString:@"1"]) {
            [self showPromptText:@"该场比赛暂不支持该玩法" hideAfterDelay:1.7];
            return;
        }
    }else  if ([flag isEqualToString:@"3"]) {
        [self showPromptText:@"该场比赛暂不支持该玩法" hideAfterDelay:1.7];
        return;
    }
    
    if (num == 1) {
        
        [model.SFSelectMatch replaceObjectAtIndex:index-100 withObject:title];
    }
    
    if (num == 2) {
        [model.RFSFSelectMatch replaceObjectAtIndex:index-200 withObject:title];
        
    }
    
    if (num == 3) {
        [model.DXFSelectMatch replaceObjectAtIndex:index-300 withObject:title];
        
    }
    
    if (num == 4) {
        [model.SFCSelectMatch replaceObjectAtIndex:index-400 withObject:title];
       
    }
    
    if (isSelect == NO) {
        for (NSString *is in model.SFSelectMatch) {
            if ([is isEqualToString:@"1"]) {
                isSelect = YES;
                break;
            }
        }
    }
    if (isSelect == NO) {
        for (NSString *is in model.RFSFSelectMatch) {
            if ([is isEqualToString:@"1"]) {
                isSelect = YES;
                break;
            }
        }
    }
    if (isSelect == NO) {
        for (NSString *is in model.DXFSelectMatch) {
            if ([is isEqualToString:@"1"]) {
                isSelect = YES;
                break;
                
            }
        }
    }
    if (isSelect == NO) {
        for (NSString *is in model.SFCSelectMatch) {
            if ([is isEqualToString:@"1"]) {
                isSelect = YES;
                break;
            }
        }
    }
    
    if (transaction.matchSelectArray.count == 0) {
        model.isSelected = isSelect;
        [transaction.matchSelectArray addObject:model];
    }else{
        for (int i = 0; i<transaction.matchSelectArray.count; i++) {
            
            JCLQMatchModel *itemModel = transaction.matchSelectArray[i];
            if ([itemModel.matchKey isEqual:model.matchKey]) {
                
                if (isSelect == YES) {
                    [transaction.matchSelectArray replaceObjectAtIndex:i withObject:model];
                    break;
                }else{
                    itemModel.isSelected = NO;
                    [transaction.matchSelectArray removeObject:itemModel];
                    break;
                    
                }
            }else if(i==transaction.matchSelectArray.count-1 && ![itemModel.matchKey isEqual:model.matchKey]){
                if (isSelect == YES) {
                    model.isSelected = YES;
                    [transaction.matchSelectArray addObject:model];
                    break;
                }
            }
        }
    }
    
    [self updata];
    [self performSelector:@selector(tableReload) withObject:nil afterDelay:0.1];
}
-(void)tableReload{
    [_tabPlayList reloadData];
}
-(void)updata{
    
    if (transaction.matchSelectArray.count == 0) {
        [self setSummary];
    }else{
    
    NSString *str = [NSString stringWithFormat:MatchCountLb,transaction.matchSelectArray.count];
    
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attstr addAttribute:NSForegroundColorAttributeName value:SystemRed range:NSMakeRange(4, str.length - 7)];

    self.labPlayInfo.attributedText = attstr;
    }
}

-(void)cleanAllSelect{

    
    for (NSArray *array in self.dataArray) {
        
        for (int i = 1; i<=array.count -1 ;i++) {
            JCLQMatchModel *model = array[i];
                [self matchClean:model.RFSFSelectMatch];
                [self matchClean:model.SFSelectMatch];
                [self matchClean:model.SFCSelectMatch];
                [self matchClean:model.DXFSelectMatch];
        }
    }
    [transaction.matchSelectArray removeAllObjects];
    transaction.beitou = @"5";
    [self updata];
}

-(void)matchClean:(NSMutableArray *)array{

    for (int i = 0; i< array.count; i++) {
        [array replaceObjectAtIndex:i withObject:@"0"];
    }

}

- (void)loadUI{
    [self useBackButton:YES];
//    [self addOptionRighButton];
    
}
- (void)navigationBackToLastPage{
    if (transaction.matchSelectArray.count > 0) {
        [self cleanAllSelect];
        [super navigationBackToLastPage];
    }else{
        [super navigationBackToLastPage];
    }
    
}

-(void)setRightBarItems{
    
    UIBarButtonItem *itemQuery = [self creatBarItem:@" 助手" icon:@"helper.png" andFrame:CGRectMake(0, 10, 65, 25) andAction:@selector(optionRightButtonAction)];
    self.navigationItem.rightBarButtonItems = @[itemQuery];
}

- (void)optionDidSelacted:(OptionSelectedView *)optionSelectedView andIndex:(NSInteger)index{
    if (index == 1) {
        //clear selection
        [self showPlayMethod];
        NSLog(@"玩法介绍");
    }else if (index == 0){
        //        [self showExtrendViewCtr];
        [self showWinHistoryViewCtr];
        NSLog(@"开奖历史");
    }
}

#pragma mark - 右上角跳转项目的实现
- (void)showPlayMethod{
    NSArray *infoArr = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    NSDictionary *infoDic = infoArr[7];
    LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
    detailVC.lotteryDetailDic = infoDic;
    [self.navigationController pushViewController: detailVC animated: YES];
}
- (void) showWinHistoryViewCtr{
    WebCTZQHisViewController * playViewVC = [[WebCTZQHisViewController alloc]init];
    NSString *strUrl = [NSString stringWithFormat:@"%@/app/award/jlOpenAward",H5BaseAddress];
    playViewVC.pageUrl = [NSURL URLWithString:strUrl];
    playViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playViewVC animated:YES];
}

-(void)jclqlotteryProfileSelectViewDelegate:(JCZQProfile *)lotteryPros andPlayType:(JCLQGuanType)playType andRes:(NSString *)res{
   
    WBButton * titleBtn = (WBButton*)self.navigationItem.titleView;
    
    if (![transaction.curProfile.Title isEqualToString:lotteryPros.Title] || transaction.guanType != playType) {
        [self cleanAllSelect];
    }
    transaction.playType = lotteryPros.Desc;
    transaction.curProfile = lotteryPros;
    transaction.guanType = playType;
    [titleBtn setTitle:lotteryPros.Title forState:0];
    
    if(transaction.guanType == JCLQGuanTypeDanGuan ){
        
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"SF"]) {
            [self lookMatchForCurPlayType:0 andGuanType:JCLQGuanTypeDanGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"RFSF"]) {
            [self lookMatchForCurPlayType:1 andGuanType:JCLQGuanTypeDanGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"DXF"]) {
            [self lookMatchForCurPlayType:3 andGuanType:JCLQGuanTypeDanGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"SFC"]) {
            [self lookMatchForCurPlayType:2 andGuanType:JCLQGuanTypeDanGuan];
        }
        
        
    }else if(transaction.guanType == JCLQGuanTypeGuoGuan){
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"SF"]) {
            [self lookMatchForCurPlayType:0 andGuanType:JCLQGuanTypeGuoGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"RFSF"]) {
            [self lookMatchForCurPlayType:1 andGuanType:JCLQGuanTypeGuoGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"DXF"]) {
            [self lookMatchForCurPlayType:3 andGuanType:JCLQGuanTypeGuoGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"SFC"]) {
            [self lookMatchForCurPlayType:2 andGuanType:JCLQGuanTypeGuoGuan];
        }
        if ([[transaction.playType substringFromIndex:4] isEqualToString:@"HHGG"]) {
            [self lookMatchForCurPlayType:-1 andGuanType:JCLQGuanTypeGuoGuan];
        }
        
        NSLog(@"当前过关方式！过关！！！");
    }
    
    [self updata];
    
    [self.tabPlayList reloadData];
}

-(void)cleanMatch:(NSNotification*)notification{

    JCLQMatchModel *model = (JCLQMatchModel*)notification.object;
    [transaction.matchSelectArray removeObject:model];
    [self.tabPlayList reloadData];
}

-(void)dealloc{
[[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationDeleteMatchForPlay" object:nil];

}
-(void)showProfileType{
    profileSelectView.hidden = !profileSelectView.hidden;
}

-(BOOL)canBuyThisMatch:(JCLQMatchModel *)model andIndex:(NSInteger)ind{
    NSString* flag = [model.openFlag substringWithRange:NSMakeRange(ind, 1)];
    if (transaction.playType ==JCLQGuanTypeDanGuan ) {
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


@end
