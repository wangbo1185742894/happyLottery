//
//  OmitEnquiriesViewController.m
//  Lottery
//
//  Created by only on 16/11/8.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "OmitEnquiriesViewController.h"
#import "OmitEnquiresTableViewCell.h"
#import "LotteryProfileSelectView.h"
#import "LotteryTitleView.h"
#import "ZDdropView.h"
#import "LotteryXHSection.h"

#import "LoadData.h"
#import "QmitModel.h"
#import "LotteryManager.h"
#import "TouZhuViewController.h"
#import "LotteryTransaction.h"
#import "LotteryBet.h"
#import "LotteryPlayViewController.h"
#import "DiscoverViewController.h"

#define qmitDictionary   @{@"前一":@"0", @"任选二":@"1", @"任选三":@"2", @"任选四":@"3", @"任选五":@"4", @"任选六":@"5", @"任选七":@"6", @"任选八":@"7", @"前二直选":@"8", @"前三直选":@"9", @"前二组选":@"10", @"前三组选":@"11"}
//,@"乐选二":@"2",@"乐选三":@"3",@"乐选四":@"4", @"乐选五":@"5"
//,@"2":@"乐选二", @"3":@"乐选三", @"4":@"乐选四", @"5":@"乐选五"
#define MyDictionary   @{@"0":@"前一",@"1":@"任选二", @"2":@"任选三", @"3":@"任选四", @"4":@"任选五", @"5":@"任选六", @"6":@"任选七",@"7": @"任选八", @"8":@"前二直选", @"9":@"前三直选", @"10":@"前二组选", @"11":@"前三组选"}
//#import "WBButton.h"


@interface OmitEnquiriesViewController ()<UITableViewDataSource, UITableViewDelegate, ZDdropViewDelegate,LotteryManagerDelegate, TouZhuViewControllerDelegate>
{
    NSUInteger hour;
    NSUInteger minute;
    NSUInteger second;
    NSTimer * timerForcurRound;
    BOOL isShow;
    NSString * qmitQiCi;
    LotteryManager*lotteryMan;
    //投注的金额
    int betCost;
    
    int btnCury;
    int  selectedBetCount;
    UITapGestureRecognizer * tap;
    
    NSMutableArray *mArraywan;
    NSMutableArray *mArrayqian;
    NSMutableArray *mArraybai;
    
    LotteryBet * lotteryBet;
}
@property (weak, nonatomic) IBOutlet UIButton *btnQianwei;
@property (weak, nonatomic) IBOutlet UIButton *btnWanwei;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnBaiwei;
@property(nonatomic,assign)NSInteger index;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDis;

@property (nonatomic,strong)NSArray *indexArray;
@property(nonatomic,strong)NSArray *titleArray;
@property (weak, nonatomic) IBOutlet UILabel *IssueLabel;

@property (weak, nonatomic) IBOutlet UILabel *JiangQiTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *OmitEnquiriesTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *EnquiriesLabelHeight;

@property (weak, nonatomic) IBOutlet UIButton *omitButton;
@property (weak, nonatomic) IBOutlet UIView *omitView;
@property (weak, nonatomic) IBOutlet UIView *areaView;

@property (weak, nonatomic) IBOutlet UIImageView *omitImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentIssueLabel;

@property (nonatomic, strong) ZDdropView * dropView;
@property (nonatomic, strong) UILabel * mytitleLabel;
@property (nonatomic, strong) UIImageView * titleImageView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property(nonatomic,strong)LoadData*loadDataTool;
@property (nonatomic , strong) NSString * touzhuErrorString;

@property (nonatomic, strong) NSMutableArray * buttonArray;

@end

@implementation OmitEnquiriesViewController
#pragma mark--懒加载
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc]init];
    }
    return _buttonArray;
}

- (NSMutableArray *)searchCodeArray
{
    if (!_searchCodeArray) {
        _searchCodeArray = [[NSMutableArray alloc]init];
    }
    return _searchCodeArray;
}
- (LotteryTransaction *)lotteryTransaction
{
    if (!_lotteryTransaction) {
        _lotteryTransaction = [[LotteryTransaction alloc]init];
    }
    return _lotteryTransaction;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.OmitEnquiriesTableView reloadData];
    lotteryMan = [[LotteryManager alloc] init];
    lotteryMan.delegate =self;
    [self updateSummary ];
    [self  getCurrentRound];
//    [self.lotteryTransaction removeAllBets];
    selectedBetCount = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([self isIphoneX]){
        _topDis.constant = 88;
        _bottomDis.constant = 38;
    }else{
        _topDis.constant = 64;
        _bottomDis.constant = 0;
    }
//    [self iphoneXViewFrame:_topDis andBottom:_bottomDis];
    self.viewControllerNo = @"A106";
    mArrayqian = [NSMutableArray arrayWithCapacity:0];
        mArraybai = [NSMutableArray arrayWithCapacity:0];
        mArraywan = [NSMutableArray arrayWithCapacity:0];
    self.lotteryMan.delegate = self;
    self.indexArray = @[@201,@202,@203,@204,@205,@206,@207,@208,@220,@230,@221,@231];
    self.titleArray = @[@"前一",@"任选二",@"任选三", @"任选四", @"任选五", @"任选六", @"任选七", @"任选八",@"前二直选", @"前三直选", @"前二组选", @"前三组选"];
    
    [self refreshAreaView];
    if (self.searchCodeArray.count == 0) {
        self.isQmit = NO;
        if ([self.titleString isEqualToString:@"乐选五"]) {
            self.index = 4;
            
        }else if ([self.titleString isEqualToString:@"乐选四"]) {
            self.index = 3;
            
        }else if ([self.titleString isEqualToString:@"乐选三"]) {
            self.index = 2;
            
        }else if ([self.titleString isEqualToString:@"乐选二"]) {
            self.index = 1;
            
        }else if ([self.titleString hasPrefix:@"胆拖"]) {
            if ([self.titleString isEqualToString:@"组二胆拖"]) {
                self.titleString = @"前二组选";
            }else if([self.titleString isEqualToString:@"组三胆拖"]){
                self.titleString = @"前三组选";
            }else{
                self.titleString = [self.titleString substringToIndex:self.titleString.length -2];
            }
            NSString *index  =qmitDictionary[self.titleString];
            self.index = [index integerValue];
        }else{
            NSString *index  =qmitDictionary[self.titleString];
            self.index = [index integerValue];
        }
    }else{
        self.index = -1;
    }
    
//    hour = _lottery.currentRound.abortHour;
//    minute = _lottery.currentRound.abortMinute;
//    second = _lottery.currentRound.abortSecond;
//    [self showTime];
//    timerForcurRound = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updataTimeAppear) userInfo:nil repeats:YES];
    
    self.loadDataTool = [LoadData singleLoadData];
    if (_lottery.currentRound==nil) {
        self.IssueLabel.text = [NSString stringWithFormat:@"当前暂无奖期"];
    }else{
        self.IssueLabel.text = [NSString stringWithFormat:@"第%@期", _lottery.currentRound.issueNumber];
    }

//    self.IssueLabel.text = [NSString stringWithFormat:@"第%@期", _lottery.currentRound.issueNumber];
//    self.titleString = self.lottery.activeProfile.title;
    if (self.isQmit == YES) {
        
        if ([self.titleString isEqualToString:@"前二直选"]) {
            self.btnBaiwei.hidden = YES;
            self.btnWanwei.hidden = NO;
            self.btnQianwei.hidden = NO;
            btnCury = 30;
            self.btnWanwei.selected = YES;
            self.areaViewHeight.constant = 140;
            
            if (self.searchCodeArray.count==2) {
                [mArraywan addObject:self.searchCodeArray[0]];
                [mArrayqian addObject:self.searchCodeArray[1]];
            }
           
            
        }else if([self.titleString isEqualToString:@"前三直选"]){
            self.areaViewHeight.constant = 140;
            btnCury = 30;
            self.btnBaiwei.hidden = NO;
            self.btnWanwei.hidden = NO;
            self.btnWanwei.selected = YES;
            self.btnQianwei.hidden = NO;
            
            if (self.searchCodeArray.count==3) {
                [mArraywan addObject:self.searchCodeArray[0]];
                [mArrayqian addObject:self.searchCodeArray[1]];
                [mArraybai addObject:self.searchCodeArray[2]];
            }
        }else{
           self.areaViewHeight.constant = 110;
            self.btnBaiwei.hidden = YES;
            self.btnWanwei.hidden = YES;
            self.btnQianwei.hidden = YES;
            btnCury = 0;
        }
        
        [self.omitButton setTitle:@"取消" forState:UIControlStateNormal];
        self.omitImageView.image = [UIImage imageNamed:@"omitshut.png"];
        self.EnquiriesLabelHeight.constant = 0;
    }else {
        
       
        if ([self.titleString isEqualToString:@"前二直选"]||[self.titleString isEqualToString:@"前三直选"]) {
            self.EnquiriesLabelHeight.constant = -140;
        }else{
            self.EnquiriesLabelHeight.constant = -110;
        }
        [self.omitButton setTitle:@"查找" forState:UIControlStateNormal];
        self.omitImageView.image = [UIImage imageNamed:@"omitreach.png"];
      
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSummary) name:NSNotificationModelSelect object:nil];
    [self initConfig];
    //查找区域设置
    [self omitAreaConfig];
    
    [self setUpTitleView];
    [self showLoadingViewWithText:@"正在加载..."];
    [self requestNetworking];
    if (self.lottery.activeProfile ==nil) {
       [self setLotteryProfile:0];
    }
    
//    if ([self.lottery.activeProfile.profileID integerValue] == 21) {
//        [self setLotteryProfile:1];
//        
//    }
//    if ([self.lottery.activeProfile.profileID integerValue] == 22) {
//        [self setLotteryProfile:2];
//    }
//    if ([self.lottery.activeProfile.profileID integerValue] == 23) {
//        [self setLotteryProfile:3];
//    }
//    if ([self.lottery.activeProfile.profileID integerValue] == 24) {
//        [self setLotteryProfile:4];
//    }
    
}


-(void)refreshAreaView{
    if ([self.titleString isEqualToString:@"前二直选"] ) {
        self.btnBaiwei.hidden = YES;
        self.btnWanwei.hidden = NO;
        self.btnQianwei.hidden = NO;
        btnCury = 30;
        self.areaViewHeight.constant = 140;
        
    }else if([self.titleString isEqualToString:@"前三直选"]){
        self.areaViewHeight.constant = 140;
        btnCury = 30;
        self.btnBaiwei.hidden = NO;
        self.btnWanwei.hidden = NO;
        self.btnQianwei.hidden = NO;
    }else{
        self.areaViewHeight.constant = 110;
        self.btnBaiwei.hidden = YES;
        self.btnWanwei.hidden = YES;
        self.btnQianwei.hidden = YES;
        btnCury = 0;
    }
    
    self.EnquiriesLabelHeight.constant= -self.areaViewHeight.constant;
    
    
    [self omitAreaConfig];
    
}

-(void)navigationBackToLastPage{
    for (BaseViewController *baseVC  in self.navigationController.viewControllers) {
        if ([baseVC class] == [DiscoverViewController class]) {
            [self.navigationController popToViewController:baseVC animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSInteger)getSelectNum{
    NSInteger  count = 0;
    for (QmitModel *model in self.dataSource) {
        if ([model.isSelect isEqualToString:@"1"]) {
            count ++;}
    }
    return count;
}
-(void)updateSummary{
    [self.OmitEnquiriesTableView reloadData];
      selectedBetCount = 0;
    for (QmitModel *model in self.dataSource) {
        if ([model.isSelect isEqualToString:@"1"]) {
            selectedBetCount ++;}
    }
    betCost = selectedBetCount *2;
    self.labBeySummary.text = [NSString stringWithFormat:@"共%d注，金额：%d元",selectedBetCount,betCost];
}
- (void)clearAllButtonColor
{
    for (UIButton * button in self.buttonArray) {
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.selected = NO;
    }
    [self.searchCodeArray removeAllObjects];
}

#pragma mark 网络请求
- (void)requestNetworking {
    [self.dataSource removeAllObjects];
    NSString * newStr = [NSMutableString string];
    if ([self.titleString isEqualToString:@"前二直选"]) {
        
        if (mArraywan.count>1) {
            [self showPromptText:@"请每位只选择一个号码" hideAfterDelay:1.7];
            
            return;
        }
        if (mArrayqian.count >1) {
            [self showPromptText:@"请每位只选择一个号码" hideAfterDelay:1.7];
            return;
        }
        
        if (mArraywan.count != 0 && mArrayqian.count!=0) {
            if ([[mArraywan firstObject] integerValue] == [[mArrayqian firstObject] integerValue]) {
                [self showPromptText:@"各位不能相同" hideAfterDelay:1.7];
                return;
            }
        }
        
        
        newStr = [NSString stringWithFormat:@"%@,%@",[mArraywan firstObject],[mArrayqian firstObject]];
        self.searchCodeArray = [newStr componentsSeparatedByString:@","];
        
    }else if([self.titleString isEqualToString:@"前三直选"]){
        if (mArraywan.count>1) {
            [self showPromptText:@"请每位只选择一个号码" hideAfterDelay:1.7];
            return;
        }
        if (mArrayqian.count >1) {
            [self showPromptText:@"请每位只选择一个号码" hideAfterDelay:1.7];
            return;
        }
        if (mArraybai.count >1) {
            [self showPromptText:@"请每位只选择一个号码" hideAfterDelay:1.7];
            return;
        }
        
        if (mArraybai.count!=0 && mArraywan.count != 0&& mArrayqian.count!= 0) {
            if ([[mArraywan firstObject] integerValue] == [[mArrayqian firstObject] integerValue] ||  [[mArrayqian firstObject] integerValue] == [[mArraybai firstObject] integerValue] || [[mArraywan firstObject] integerValue]
                == [[mArraybai firstObject] integerValue]) {
                [self showPromptText:@"各位不能相同" hideAfterDelay:1.7];
                return;
            }
            
        }
        
        
        newStr = [NSString stringWithFormat:@"%@,%@,%@",[mArraywan firstObject],[mArrayqian firstObject],[mArraybai firstObject]];
        self.searchCodeArray = [newStr componentsSeparatedByString:@","];
        
    }else{
    
     [self.searchCodeArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger num1 = [obj1 integerValue];
        NSInteger num2 = [obj2 integerValue];
        if (num1 >num2) {
            return 1;
        }else{
            return  -1;
        }
     }];
         newStr = (NSString*)[self.searchCodeArray componentsJoinedByString:@","];
    }
   
    NSString *urls2 = [NSString stringWithFormat:@"/miss/getMissList"];
    NSString * titleStr = self.titleString;
    NSDictionary * titleDict = qmitDictionary;
    NSLog(@"ltype:%@", titleDict[titleStr]);
    
    
        if ([titleStr isEqualToString:@"乐选二"]) {
            titleStr = @"任选二";
        }else if ([titleStr isEqualToString:@"乐选三"]) {
            titleStr = @"任选三";
        }else if ([titleStr isEqualToString:@"乐选四"]) {
            titleStr = @"任选四";
        }else if ([titleStr isEqualToString:@"乐选五"]) {
            titleStr = @"任选五";
        }
    NSDictionary * params2 = @{@"ltype":@([titleDict[titleStr] integerValue]+ 1) , @"searchCode":newStr};
    NSLog(@"%@", newStr);
    
    
    
    NSString *theUrlStr = OmitServerURL;
    NSString *missUrl ;
    if ([self.lottery.identifier isEqualToString:@"SX115"]) {
        missUrl =[NSString stringWithFormat:@"%@%@", theUrlStr, urls2];
    }else{
        missUrl = self.sd115MissUrl;
    }
    [self.loadDataTool RequestWithString:missUrl isPost:YES andPara:params2 andComplete:^(id data, BOOL isSuccess) {
        [self hideLoadingView];
        if (isSuccess) {
            NSString*string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData*dataStr = [string dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary*dict = [NSJSONSerialization JSONObjectWithData:dataStr options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dict objectForKey:@"code"] integerValue] == 1) {
                NSArray * dataArray = dict[@"data"];
                NSLog(@"%@", dataArray);
                NSString *newstr;
                if ([self.titleString isEqualToString:@"前二直选"]||[self.titleString isEqualToString:@"前三直选"]) {
                    newstr = [self.searchCodeArray componentsJoinedByString:@","];
                }else{
                    NSArray * realArray =[self.searchCodeArray sortedArrayUsingSelector:@selector(compare:)];
                    newstr  = [realArray componentsJoinedByString:@","];
                }
                for (NSDictionary * subDict in dataArray) {
                    QmitModel * qmitModel = [[QmitModel alloc]initWith:subDict];
                    if ([newstr isEqualToString:qmitModel.number]) {
                        qmitModel.isSelect = @"1";
                    }else{
                        qmitModel.isSelect = @"0";
                    }
                    [self.dataSource addObject:qmitModel];
                }
                
                self.currentIssueLabel.text = [NSString stringWithFormat:@"遗漏期次：%@", dataArray[0][@"currentIssue"]];
                [self updateSummary];
                [self.OmitEnquiriesTableView reloadData];
            }else {
            [self showPromptText:@"查询失败，请重试" hideAfterDelay:1.7];
            }
            
            
        }else{
            [self showPromptText:@"请求网络超时，请检查网络设置" hideAfterDelay:1.7];
        }
    }];
    

}

- (void)initConfig
{
//    self.isQmit = NO;
    isShow = NO;
    //给查找的图片那块区域增加手势
    UITapGestureRecognizer * mytap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(omitBtnClicked:)];
    [self.omitView addGestureRecognizer:mytap];
    
    self.OmitEnquiriesTableView.bounces = NO;
    //去掉自带的分割线
    self.OmitEnquiriesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
- (void)omitAreaConfig
{
    [self.buttonArray removeAllObjects];
    int allwidth = KscreenWidth-65-8-12;
    int spacing = 10;//两个之间的横向距离
    int Height_Space = 10;////两个之间的纵向距离
    int left = 8;//第一个距离左边的距离
    int top = 10 + btnCury;//第一个距离上边的距离
    int width  = (allwidth-left*2-5*spacing)/6;
    int height = width;
    for (int i = 0; i < 11; i++) {
        
        UIButton *item = (UIButton*)[self.view viewWithTag:i+10000];
        
        if (item != nil) {
            [item removeFromSuperview];
        }
        
        NSInteger index = i % 6;
        NSInteger page = i / 6;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(left+index*(spacing+width), top+page*(height+Height_Space), width, height);
        button.tag = i+10000;
        button.layer.cornerRadius = width/2;
        button.clipsToBounds = YES;
        button.layer.borderWidth = 1;
        [button setTitle:[NSString stringWithFormat:@"%02d", i+1] forState:UIControlStateNormal];
        //比如传过来的号是6， 4
        
        if ([self.titleString isEqualToString:@"前二直选"]) {
            
          
            
            if (self.btnWanwei.selected == YES && [mArraywan containsObject:[NSNumber numberWithInteger:i+1]]) {
                
                [self setBtnState:@"1" andBtn:button index:i];
                
            }else if(self.btnQianwei.selected == YES && [mArrayqian containsObject:[NSNumber numberWithInteger:i+1]]){
                [self setBtnState:@"1" andBtn:button index:i];
                
            }else{
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = NO;
            
            }
            
        }else if ([self.titleString isEqualToString:@"前三直选"]){
           
            
                
            
            if (self.btnWanwei.selected == YES && [mArraywan containsObject:[NSNumber numberWithInteger:i+1]]) {
                
                [self setBtnState:@"1" andBtn:button index:i];
                
            }else if(self.btnQianwei.selected == YES && [mArrayqian containsObject:[NSNumber numberWithInteger:i+1]]){
                [self setBtnState:@"1" andBtn:button index:i];
                
            }else if(self.btnBaiwei.selected == YES && [mArraybai containsObject:[NSNumber numberWithInteger:i+1]]){
                [self setBtnState:@"1" andBtn:button index:i];
                
            
            }else{
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = NO;
            }
        }
        else{if ([self.searchCodeArray containsObject:[NSNumber numberWithInteger:i+1]]) {
            [button setBackgroundImage:[UIImage imageNamed:@"redBall"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor orangeColor].CGColor;
            button.selected = YES;
        }else {
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.selected = NO;
        }
        }

 
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(numberBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.areaView addSubview:button];
        [self.buttonArray addObject:button];
    }
}

-(void)setBtnState:(NSString*)num andBtn:(UIButton *)button index:(NSInteger)i{
    if ([num integerValue]==1) {
        [button setBackgroundImage:[UIImage imageNamed:@"redBall"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor orangeColor].CGColor;
        button.selected = YES;
    }else {
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.selected = NO;
    }

}


- (void)setUpTitleView{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 93, 25)];
    titleView.backgroundColor = [UIColor clearColor];
    
    self.mytitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 75, 21)];
    
    
    NSString * titleStr = self.titleString;
    if ([titleStr isEqualToString:@"乐选二"]) {
        titleStr = @"任选二";
    }else if ([titleStr isEqualToString:@"乐选三"]) {
        titleStr = @"任选三";
    }else if ([titleStr isEqualToString:@"乐选四"]) {
        titleStr = @"任选四";
    }else if ([titleStr isEqualToString:@"乐选五"]) {
        titleStr = @"任选五";
    }else if ([titleStr hasPrefix:@"胆拖"]) {
        if ([titleStr isEqualToString:@"组二胆拖"]) {
            titleStr = @"前二组选";
        }else if([titleStr isEqualToString:@"组三胆拖"]){
            titleStr = @"前三组选";
        }else{
            titleStr = [titleStr substringToIndex:titleStr.length -2];
        }
    }
    self.mytitleLabel.text = titleStr;
    
    self.mytitleLabel.textColor = [UIColor whiteColor];
    self.mytitleLabel.backgroundColor = [UIColor clearColor];
    self.mytitleLabel.font = TitleTextFont;
    self.mytitleLabel.textAlignment = NSTextAlignmentRight;
    [titleView addSubview:self.mytitleLabel];
    
    self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 14, 18, 11)];
    self.titleImageView.image = [UIImage imageNamed:@"wanfaxiala"];
    self.titleImageView.contentMode =UIViewContentModeCenter;
    [titleView addSubview:self.titleImageView];
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [titleView addGestureRecognizer:tap];
    
    
    self.navigationItem.titleView = titleView;
    
    NSArray * myArray = @[@"前一",@"任选二", @"任选三", @"任选四", @"任选五", @"任选六", @"任选七",@"任选八",  @"前二直选", @"前三直选", @"前二组选", @"前三组选"];
    NSInteger titleStrIndex = [myArray indexOfObject:self.titleString];
    self.dropView = [[ZDdropView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KscreenHeight) andDataArray:myArray andTitleStrIndex:titleStrIndex];
    self.dropView.delegate = self;

}
- (void)tap:(UIGestureRecognizer *)tap
{
    [[UIApplication sharedApplication].keyWindow  addSubview:self.dropView];
    //        isShow = YES;
//    if (isShow == NO) {
//        
//         [[UIApplication sharedApplication].keyWindow  addSubview:self.dropView];
//        isShow = YES;
//    }else {
//        [self.dropView removeFromSuperview];
//        isShow = NO;
//    }
}
- (IBAction)omitBtnClicked:(id)sender {
    if (self.isQmit == NO) {
        
        if ([self.titleString isEqualToString:@"前二直选"]) {
            self.btnBaiwei.hidden = YES;
            self.btnWanwei.hidden = NO;
            self.btnQianwei.hidden = NO;
            btnCury = 30;
            self.areaViewHeight.constant = 140;
            
        }else if([self.titleString isEqualToString:@"前三直选"]){
            self.areaViewHeight.constant = 140;
            btnCury = 30;
            self.btnBaiwei.hidden = NO;
            self.btnWanwei.hidden = NO;
            self.btnQianwei.hidden = NO;
        }else{
            self.areaViewHeight.constant = 110;
            self.btnBaiwei.hidden = YES;
            self.btnWanwei.hidden = YES;
            self.btnQianwei.hidden = YES;
            btnCury = 0;
        }
        
        [self.omitButton setTitle:@"取消" forState:UIControlStateNormal];
        self.omitImageView.image = [UIImage imageNamed:@"omitshut.png"];
        self.EnquiriesLabelHeight.constant = 0;
        self.isQmit = YES;
    }else {
        [self.omitButton setTitle:@"查找" forState:UIControlStateNormal];
        self.omitImageView.image = [UIImage imageNamed:@"omitreach.png"];
        if ([self.titleString isEqualToString:@"前二直选"]||[self.titleString isEqualToString:@"前三直选"]) {
            self.EnquiriesLabelHeight.constant = -140;
        }else{
            self.EnquiriesLabelHeight.constant = -110;
        }
        self.isQmit = NO;
        [self clearAllButtonColor];
    }
}
- (IBAction)searchBtn:(id)sender {

    
    if ([self.titleString isEqualToString:@"前二直选"]|| [self.titleString isEqualToString:@"前三直选"]) {
        [self showLoadingViewWithText:@"正在加载..."];
        [self requestNetworking];
    }else
    {
    if (self.searchCodeArray.count > 0 ) {
        NSString * titleStr = self.titleString;
        NSDictionary * titleDict = qmitDictionary;
        NSLog(@"ltype:%@", titleDict[titleStr]);
        if ([titleDict[titleStr] intValue] > 0 && [titleDict[titleStr] intValue]< 8) {
            if (self.searchCodeArray.count != [titleDict[titleStr] intValue]+1) {
                [self showPromptText:[NSString stringWithFormat:@"请选择%d个号码", [titleDict[titleStr] intValue] + 1] hideAfterDelay:1.7];
                return;
            }
        }else if([titleDict[titleStr] intValue] == 8 || [titleDict[titleStr] intValue] == 10){
            if (self.searchCodeArray.count != 2) {
                [self showPromptText:@"请选择2个号码" hideAfterDelay:1.7];
                return;
            }
            
        }else if([titleDict[titleStr] intValue] == 9 || [titleDict[titleStr] intValue] == 11){
            if (self.searchCodeArray.count != 3) {
                [self showPromptText:@"请选择3个号码" hideAfterDelay:1.7];
                return;
            }

        }
        
        [self showLoadingViewWithText:@"正在加载..."];
        [self requestNetworking];
    }
    }
    
}

- (void)numberBtnClicked:(UIButton *)button
{
    
    if ([self.titleString isEqualToString:@"前二直选"]) {
        
        if(self.btnWanwei.selected == YES){
        
            if (button.selected == YES) {
                [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = NO;
                [mArraywan removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                 [self.searchCodeArray removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                
                
            }else {
                [button setBackgroundImage:[UIImage imageNamed:@"redBall"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor orangeColor].CGColor;
                button.selected = YES;
                [mArraywan addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                
                 [self.searchCodeArray addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
            }
            
        }else if ( self.btnQianwei.selected == YES){
        
            if (button.selected == YES) {
                [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = NO;
                [mArrayqian removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                 [self.searchCodeArray removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                
            }else {
                [button setBackgroundImage:[UIImage imageNamed:@"redBall"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor orangeColor].CGColor;
                button.selected = YES;
                [mArrayqian addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                 [self.searchCodeArray addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
            }
        }
        
    }else if([self.titleString isEqualToString:@"前三直选"]){
        if(self.btnWanwei.selected == YES){
            if (button.selected == YES) {
                [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = NO;
                [mArraywan removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                 [self.searchCodeArray removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                
                
            }else {
                [button setBackgroundImage:[UIImage imageNamed:@"redBall"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor orangeColor].CGColor;
                button.selected = YES;
                [mArraywan addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                 [self.searchCodeArray addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                
            }
            
        }else if ( self.btnQianwei.selected == YES){
            
            if (button.selected == YES) {
                [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = NO;
                [mArrayqian removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                 [self.searchCodeArray removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                
            }else {
                [button setBackgroundImage:[UIImage imageNamed:@"redBall"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor orangeColor].CGColor;
                button.selected = YES;
                [mArrayqian addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                 [self.searchCodeArray addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                
            }
        }else if ( self.btnBaiwei.selected == YES){
        
            if (button.selected == YES) {
                [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];
                
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor lightGrayColor].CGColor;
                button.selected = NO;
                [mArraybai removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                 [self.searchCodeArray removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                
            }else {
                [button setBackgroundImage:[UIImage imageNamed:@"redBall"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.layer.borderColor = [UIColor orangeColor].CGColor;
                button.selected = YES;
                [mArraybai addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                 [self.searchCodeArray addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
                
            }
        }
    
    }else {
        
      if (button.selected == YES) {
        [button setBackgroundImage:[UIImage imageNamed:@"ballWhiteBG"] forState:UIControlStateNormal];

        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.selected = NO;
        [self.searchCodeArray removeObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
        
     }else {
        [button setBackgroundImage:[UIImage imageNamed:@"redBall"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor orangeColor].CGColor;
        button.selected = YES;
        [self.searchCodeArray addObject:[NSNumber numberWithInteger:button.tag - 10000+1]];
        
      }
    }
}

- (NSString *) couldTouZhu {
    if ([_lottery.identifier isEqualToString:@"SX115"] || [_lottery.identifier isEqualToString:@"SD115"]) {
        if (selectedBetCount < 1) {
            return TextNotEnoughBet;
        }
        
    }
    return nil;
}

- (IBAction)TouZhuClicked:(id)sender {
    if ([self.lottery.activeProfile.profileID integerValue] >=21) {
        [self showPromptText:@"乐选玩法暂不支持遗漏投注" hideAfterDelay:1.7];
        return;
    }
    
//    if ([self.lottery.activeProfile.title hasSuffix:@"胆拖"]) {
//        [self showPromptText:@"胆拖玩法暂不支持遗漏投注" hideAfterDelay:1.7];
//        return;
//    }
    
    if(betCost > 300000)
    {
        [self showPromptText:TextTouzhuExceedLimit hideAfterDelay:1.7];
        return;
    }
    if (!_lottery.currentRound||[_lottery.currentRound isExpire]) {
        [self showPromptText:ErrorWrongRoundExpird hideAfterDelay:1.7];
        return;
    }
    
    NSString * errorMsg = [self couldTouZhu];
    _touzhuErrorString = errorMsg;
    if (_touzhuErrorString) {
        [self showPromptText: _touzhuErrorString hideAfterDelay: 1.7];
        self.touzhuErrorString = nil;
        return;
    }
    
    if (errorMsg) {
        [self showPromptText: errorMsg hideAfterDelay: 1.7];
        return;
    }
    for (QmitModel *model in self.dataSource) {
        if ([model.isSelect isEqualToString:@"1"]) {
//            selectedBetCount ++;
            NSMutableString *strTitle = [NSMutableString string];
  
            LotteryBet * Bet = [[LotteryBet alloc] init];
            
            Bet.lotteryDetails = self.lottery.activeProfile.details;
            Bet.betXHProfile = self.lottery.activeProfile;
            Bet.betLotteryIdentifier = self.lottery.identifier;
            Bet.betLotteryType = self.lottery.type;
            Bet.sectionDataLinkSymbol = self.lottery.dateSectionLinkSymbol;
            NSDictionary * dict = MyDictionary;

            [Bet setBetCount:1];
            [Bet setBetsCost:2];
            [Bet setBetTypeDesc:[dict valueForKey:model.ltype]];
            
            if(self.index != -1){
                Bet.betType = [self.indexArray[self.index] integerValue];
                Bet.betTypeDesc = self.titleArray[self.index];
            }
            
            
            if ([Bet.betProfile isEqualToString:@"乐选二"]) {
                Bet.betType = 202;
            }else if ([Bet.betProfile isEqualToString:@"乐选三"]) {
                Bet.betType = 203;
            }else if ([Bet.betProfile isEqualToString:@"乐选四"]) {
                Bet.betType = 204;
            }else if ([Bet.betProfile isEqualToString:@"乐选五"]) {
                Bet.betType = 205;
            }else if ([Bet.betProfile isEqualToString:@"任选二胆拖"]) {
                Bet.betType =202;
            }else if ([Bet.betProfile isEqualToString:@"任选三胆拖"]) {
                Bet.betType =203;
            }else if ([Bet.betProfile isEqualToString:@"任选四胆拖"]) {
                Bet.betType =204;
            }else if ([Bet.betProfile isEqualToString:@"任选五胆拖"]) {
                Bet.betType =205;
            }else if ([Bet.betProfile isEqualToString:@"任选六胆拖"]) {
                Bet.betType =206;
            }else if ([Bet.betProfile isEqualToString:@"任选七胆拖"]) {
                Bet.betType =207;
            }else if ([Bet.betProfile isEqualToString:@"组二胆拖"]) {
                Bet.betType =221;
            }else if ([Bet.betProfile isEqualToString:@"组三胆拖"]) {
                Bet.betType =231;
            }
            
            Bet.betProfile = Bet.betTypeDesc;
            
            if([Bet.betTypeDesc isEqualToString:@"前三直选"]||[Bet.betTypeDesc isEqualToString:@"前二直选"] ||[Bet.betTypeDesc isEqualToString:@"乐选二"]||[Bet.betTypeDesc isEqualToString:@"乐选三"]){
                for (NSString *item in [model.number componentsSeparatedByString:@","]) {
                    [strTitle appendFormat:@"%02zd#",[item integerValue]];
                }
                if (strTitle.length >=1) {
                    strTitle = [strTitle substringToIndex:strTitle.length-1];
                }
            }else{
                for (NSString *item in [model.number componentsSeparatedByString:@","]) {
                    [strTitle appendFormat:@"%02zd,",[item integerValue]];
                }
                if (strTitle.length >=1) {
                    strTitle = [strTitle substringToIndex:strTitle.length-1];
                }
            }
            Bet.orderBetNumberDesc = strTitle;
            
            
            NSAttributedString *numberAttributedString;
            numberAttributedString = [[NSAttributedString alloc]initWithString:strTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:SystemRed}];
            Bet.betNumbersDesc = numberAttributedString;
            model.isSelect = @"0";
            
            [self.lotteryTransaction addBet:Bet];
        }
    }

    
   
    LotteryPlayViewController *playVC = [[LotteryPlayViewController alloc] initWithNibName: @"LotteryPlayViewController" bundle: nil];
  
    playVC.lottery = self.lottery;
    
    TouZhuViewController *touzhuVC = [[TouZhuViewController alloc] initWithNibName: @"TouZhuViewController" bundle: nil];
    touzhuVC.lottery = self.lottery;
    
    touzhuVC.transaction = _lotteryTransaction;
    touzhuVC.timerForcurRound = timerForcurRound;
    
    touzhuVC.delegate = self.delegate == nil?playVC:self.delegate;
    
    _lotteryTransaction.needZhuiJia = NO;
    _lotteryTransaction.beiTouCount = 1;
    _lotteryTransaction.qiShuCount = 1;
    _lotteryTransaction.lottery = self.lottery;
   
     touzhuVC.isOmit = @"YES";
     playVC.isOmit = @"YES";

    
    if ([self.isOmit isEqualToString:@"YES"]) {
         [self.navigationController pushViewController:playVC animated:NO];
    }
    
     [self.navigationController pushViewController: touzhuVC animated: YES];
 
  
}
#pragma mark--TouZhuViewControllerDelegate
- (void) addRandomBet {
    [self newBet];
//    [lotteryXHView addRandomBet];
//    [self addBetToBasket];
//    [self clearAllSelection];
}
- (void) newBet {
    switch (_lottery.type) {
        case LotteryTypeSDShiYiXuanWu:
        case LotteryTypeShiYiXuanWu:{
            lotteryBet = [[LotteryBet alloc] init];
            lotteryBet.lotteryDetails = self.lottery.activeProfile.details;
            lotteryBet.betXHProfile = self.lottery.activeProfile;
            lotteryBet.betLotteryIdentifier = self.lottery.identifier;
            lotteryBet.betLotteryType = self.lottery.type;
            lotteryBet.sectionDataLinkSymbol = self.lottery.dateSectionLinkSymbol;
//            lotteryXHView.lotteryBet = lotteryBet;
            
            break;
        }
                default:
            break;
    }
}

- (void) betTransactionUpdated {
//    _badgeView.text = [NSString stringWithFormat: @"%lu", (unsigned long)[_lotteryTransaction betCount]];
}
- (void) betzhuihaodelegate
{

}
//投注按钮点击事件
#pragma mark---ZDdropViewDelegate
- (void)choiceIndex:(NSInteger)index andString:(NSString *)string
{  self.titleString = string;
    
    
    if ([self.titleString isEqualToString:@"前三直选"] || [self .titleString isEqualToString:@"前二直选"]) {
        self.btnWanwei.selected = YES;
        self.btnBaiwei.selected = NO;
        self.btnQianwei.selected = NO;
    }
    
    self.isQmit = NO;
    [self.omitButton setTitle:@"查找" forState:UIControlStateNormal];
    self.omitImageView.image = [UIImage imageNamed:@"search"];
    
  
    self.mytitleLabel.text = self.titleString;
    [self showLoadingViewWithText:@"正在加载..."];
    [self.searchCodeArray removeAllObjects];
    [mArraybai removeAllObjects];
    [mArrayqian removeAllObjects];
    [mArraywan removeAllObjects];
    
    [self requestNetworking];
    self.index = index;
    //改变play的玩法
    selectedBetCount = 0;
//    self.lottery.activeProfile = self.lottery.profiles[index+1];
    [self setLotteryProfile:index];
    [self.lotteryTransaction removeAllBets];
    [self clearAllButtonColor];
   
    
    [self refreshAreaView];
}

-(void)setLotteryProfile:(NSInteger)index{

    NSDictionary *lotteryDetailDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryProfilesConfig" ofType: @"plist"]];
    NSArray *profilesArray = lotteryDetailDic[[NSString stringWithFormat:@"%d", _lottery.type]];
    if (lotteryMan == nil) {
        lotteryMan = [[LotteryManager alloc]init];
        lotteryMan.delegate = self;
    }
    NSArray *profiles = [self.lotteryMan lotteryProfilesFromData: profilesArray];
//    self.lottery.activeProfile = profiles[index+1];
    self.lottery.needSectionRandom = @1;
    
    self.lottery.profiles = profiles;
}

-(void)setLotteryLexuanProfile:(NSInteger)index{
    
    NSDictionary *lotteryDetailDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryProfilesConfig" ofType: @"plist"]];
    NSArray *profilesArray = lotteryDetailDic[[NSString stringWithFormat:@"%d", _lottery.type]];
    if (lotteryMan == nil) {
        lotteryMan = [[LotteryManager alloc]init];
        lotteryMan.delegate = self;
    }
    NSArray *profiles = [lotteryMan lotteryProfilesFromData: profilesArray];
    self.lottery.activeProfile = profiles[index+1];
    self.lottery.needSectionRandom = @1;
    
    self.lottery.profiles = profiles;
}
#pragma mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array = self.searchCodeArray;

    QmitModel * model;
    if (self.dataSource.count >0) {
        model = self.dataSource[indexPath.row];
    }
    OmitEnquiresTableViewCell * cell = [OmitEnquiresTableViewCell cellWithTableView:tableView];
//    cell.sureString = newstr;
    [cell setCellValueFromModel:model andIndexPath:indexPath];
//    if(indexPath.row == 5){
//        selectedBetCount = 0;
//        QmitModel *model = [self.dataSource firstObject];
//            if ([model.isSelect isEqualToString:@"1"]) {
//                selectedBetCount ++;
//            }
//        betCost = selectedBetCount *2;
//        self.labBeySummary.text = [NSString stringWithFormat:@"共%d注，金额：%d元",selectedBetCount,betCost];
//    }
    cell.selectNum = [self getSelectNum];
    return cell;
}
#pragma mark--UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) getCurrentRound{
    NSLog(@"开始请求奖期。");
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":self.lottery.identifier}];
}
-(void)gotSellIssueList:(NSArray *)infoDic errorMsg:(NSString *)msg{
    LotteryRound  * round = [infoDic lastObject];
    if (round) {
        NSLog(@"得到奖期。");
        [timerForcurRound invalidate];
        NSLog(@"timer sile");
        _lottery.currentRound = round;
        hour = _lottery.currentRound.abortHour;
        minute = _lottery.currentRound.abortMinute;
        second = _lottery.currentRound.abortSecond;
        //展是定时器时间
        [self showTime];
        timerForcurRound = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updataTimeAppear) userInfo:nil repeats:YES];
        
    }else{
        NSLog(@"未得到奖期。");
    }
}

- (void)showTime
{
    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] init];
    
    NSMutableDictionary *textAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    textAttrsDictionary[NSForegroundColorAttributeName] = TEXTGRAYCOLOR;
    
    NSMutableDictionary *numberAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    numberAttrsDictionary[NSForegroundColorAttributeName] = TextCharColor;
    
    [timeString appendAttributedString: [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02zd", hour]  attributes: numberAttrsDictionary]];
    [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: @"时" attributes: textAttrsDictionary]];
    [timeString appendAttributedString: [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02zd", minute] attributes: numberAttrsDictionary]];
    
    [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: @"分" attributes: textAttrsDictionary]];
    [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"%02zd", second] attributes: numberAttrsDictionary]];
    [timeString appendAttributedString: [[NSAttributedString alloc] initWithString: @"秒" attributes: textAttrsDictionary]];
    self.JiangQiTimeLabel.attributedText = nil;
    self.JiangQiTimeLabel.attributedText = timeString;
    
    if (_lottery.currentRound==nil) {
        self.IssueLabel.text = [NSString stringWithFormat:@"当前暂无奖期"];
    }else{
        self.IssueLabel.text = [NSString stringWithFormat:@"第%@期", _lottery.currentRound.issueNumber];
    }
}
//刷新定时器
- (void)updataTimeAppear
{
    if (second != 0) {
        second -- ;
    }else{
        if (minute != 0) {
            minute -- ;
            second = 59;
        }else{
            if (hour != 0) {
                hour --;
                minute = 59;
                second = 59;
            }else{
                [timerForcurRound invalidate];
                
                
            }
        }
    }
    [self showTime];

}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationModelSelect object:nil];
}

- (IBAction)actionqianwei:(id)sender {
    
    self.btnBaiwei.selected = NO;
    self.btnQianwei.selected = YES;
    self.btnWanwei.selected = NO;
    [self  omitAreaConfig];
    
}
- (IBAction)actionwanwei:(id)sender {
    self.btnBaiwei.selected = NO;
    self.btnQianwei.selected = NO;
    self.btnWanwei.selected = YES;
    [self  omitAreaConfig];
}

- (IBAction)actionbaiwei:(id)sender {
    
    self.btnBaiwei.selected = YES;
    self.btnQianwei.selected = NO;
    self.btnWanwei.selected = NO;
    [self  omitAreaConfig];
}
- (IBAction)actionRemove:(id)sender {
    
    for (QmitModel * model in self.dataSource) {
        model.isSelect = @"0";
    }
    [self.OmitEnquiriesTableView reloadData];
    [self updateSummary];
}



@end
