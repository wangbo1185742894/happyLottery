 //
//  ZhuiHaoViewController.m
//  Lottery
//
//  Created by LIBOTAO on 15/9/19.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "ZhuiHaoViewController.h"
#import "AESUtility.h"

#import "LotteryExtrendViewController.h"
#import "TouZhuViewController.h"
#import "AppDelegate.h"
#import "SetPayPwdViewController.h"
#import "JPUSHService.h"
#import "ZhuiHaoInfoViewController.h"
#import "User.h"
#import "MemberManager.h"
#import "LotteryPlayViewController.h"
#import "WBInputPopView.h"
#import "WebViewController.h"
#import "ZhuiHaoCell.h"
#import "PayOrderLegViewController.h"
#define PhaseInfoHeight 20
#define VlineCount 5
#define ZHSURETAG 12321
#define KZhuihaoCell @"ZhuiHaoCell"

@interface ZhuiHaoViewController ()<UIAlertViewDelegate,LotteryPhaseInfoViewDelegate,MemberManagerDelegate,WBInputPopViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,ZhuiHaoCellDelegate,PayOrderLegDelegate>{
    
    LotteryPhaseInfoView *phaseInfoView;
    __weak IBOutlet UIView *ContentView;
    __weak IBOutlet UIView *BottomView;
    __weak IBOutlet UIButton *SubmitBtn;
    __weak IBOutlet UIButton *WinStop;
    __weak IBOutlet NSLayoutConstraint *topDis;
    __weak IBOutlet UILabel *bottomLabel;
    optimizeView *Optimizeview;
    NSArray *BetsList;
    UIScrollView *_scrollView;
    UITextField *beishuChoose;  //倍数选择框
    UITextField *JiangqiChoose; //期数选择框
    NSMutableArray *mutArry;
    UIScrollView *scrollView;
    UITableView *listTableView;
    UIButton *SbeishudownBtn;
    UIButton *SbeishuUpBtn;
    UILabel *beishulabel;
    UILabel *expenselabel;
    UILabel *profitlabel;
    UILabel *ratelabel;
    UILabel *numlabel;
    UILabel *isslabel;
    UILabel *downLine;
    
    NSUInteger curiss;
    float Allexpense;
    BOOL flag;
    BOOL poptype;

    
    NSInteger Maxprize;//最大中奖金额
    NSInteger maxwin;//最大中奖注数
    NSInteger  Maxmulcount;
    //临时变量，obj的行数
    int objLineIndex;
    NSMutableArray* objarray;
//    NSString * curRoundnum;
    
    NSTimer * timerForcurRound;
    NSString *strcurRound;
    
    NSArray * PushData;
    NSInteger maxQi;
    WBInputPopView *passInput;
    __weak IBOutlet NSLayoutConstraint *bottomDis;
}
@end

@implementation ZhuiHaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A109";
    self.title = @"追号设置";
    //期数
    if ([self.transaction.lottery.identifier isEqualToString:@"SX115"]) {
        maxQi = MAXQI11X5;
    }else{
        maxQi = MAXQISD11X5;
    }
    //默认倍数,期数
    _multiple = 1;
    _issue = 10;
    
    self.lotteryMan.delegate = self;
    self.memberMan.delegate = self;
    
    [self loadUI];
  
    topDis.constant= NaviHeight;
    bottomDis.constant = BOTTOM_BAR_HEIGHT  ;
    
    NSString * curRoundnum = [_lottery.currentRound valueForKey:@"issueNumber"];
    strcurRound = curRoundnum;//纪录期号，变化后不更新
    
    NSInteger location = [curRoundnum length] - 2;
    NSString *strcut;
    if(location > 0)
    {
        strcut = [curRoundnum substringFromIndex:location];
    }
    int intString = [strcut intValue];
    
    if (intString + 10 > maxQi) {
        _issue = maxQi - intString + 1;
    }
    curiss = intString; //纪录奖期，变化后即更新
    _lowrate = 30;
    _preissue = 5;
    _prerate = 50;
    _laterate = 20;
    _lowprofit = 30;
    _planType = 1;
    Maxmulcount = 1;
    flag = false;
    poptype = NO;
    SubmitBtn.layer.masksToBounds = YES;
    SubmitBtn.layer.cornerRadius = 4;
    
    [self getPlayType:0];//得到最大中奖金额Maxprize
    [self schemeValue:1 lowprofit:_lowrate];//默认全程最低盈利率
    
    ContentView.backgroundColor = RGBCOLOR(250, 250, 250);
    UIButton *optionButton = [UIButton buttonWithType: UIButtonTypeSystem];
    optionButton.frame = CGRectMake(0, 0, 80, 44);
    [optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [optionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [optionButton setTitle:@"规则介绍" forState:UIControlStateNormal];
    optionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [optionButton addTarget: self action: @selector(optionRightButtonAction) forControlEvents: UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: optionButton];
    

}
- (void)reloadTableView{
    if ([self isIphoneX]) {
        listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,128, KscreenWidth, KscreenHeight-334) style:UITableViewStylePlain];
    }
    else {
        listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,128, KscreenWidth, KscreenHeight-270) style:UITableViewStylePlain];
    }
    listTableView.delegate = self;
    listTableView.dataSource = self;
    [listTableView registerNib:[UINib nibWithNibName:KZhuihaoCell bundle:nil] forCellReuseIdentifier:KZhuihaoCell];
    listTableView.backgroundColor = RGBCOLOR(250, 250, 250) ;
    listTableView.layer.borderColor = SEPCOLOR.CGColor;
    listTableView.layer.borderWidth = SEPHEIGHT;
    listTableView.rowHeight = 45;
    [ContentView addSubview:listTableView];
    listTableView.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self updateSummary];
}

-(void)gotSellIssueList:(NSArray *)infoDic errorMsg:(NSString *)msg{
    if (infoDic == nil || infoDic .count == 0) {
        [self showPromptText:msg hideAfterDelay:1.9];
        return;
    }
    self.lottery.currentRound = [infoDic firstObject];
    self.transaction.lottery.currentRound = [infoDic firstObject];
    NSLog(@"timer sile");
    if (phaseInfoView) {
        [phaseInfoView showCurRoundInfo];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [JiangqiChoose.text integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     ZhuiHaoCell *cell = [tableView dequeueReusableCellWithIdentifier:KZhuihaoCell];
     cell.delegate = self;
    if (indexPath.row %2 == 0) {
        cell.backgroundColor = RGBCOLOR(252, 245, 232);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
     NSInteger location = [strcurRound length] - 2;
     if(location > 0)
     {
        NSString *strcut = [strcurRound substringFromIndex:location];
        cell.isslabel.text = [NSString stringWithFormat:@"%ld",[strcut integerValue]+indexPath.row];
     }
    
    cell.beiShutf.text = mutArry[indexPath.row];
    NSInteger total = 0;
    for (int i = 0; i <= indexPath.row; i++) {
        
        total += [mutArry[i] integerValue];
    }
     cell.expenselabel.text = [NSString stringWithFormat:@"%ld",total*2 * _zhushu];
    
     cell.profitlabel.text = [NSString stringWithFormat:@"%ld",Maxprize*[mutArry[indexPath.row] integerValue]*maxwin-[cell.expenselabel.text integerValue]];
     cell.ratelabel.text = [NSString stringWithFormat:@"%.0f%%",[cell.profitlabel.text doubleValue]/[cell.expenselabel.text doubleValue]*100];
    if ([cell.ratelabel.text doubleValue] > 0) {
        cell.ratelabel.textColor =RGBCOLOR(254, 58, 81);
    }else{
        cell.ratelabel.textColor =SystemGreen;
    }
     cell.beiUpBtn.tag = indexPath.row;
     cell.beidownBtn.tag = indexPath.row;
     return cell;
}


-(void)beishuChange:(NSString *)state sender:(id)sender{
    UIButton *but = sender;
    if (but.tag == 0) {
        if ([state isEqualToString:@"down"]) {
            beishuChoose.text = [NSString stringWithFormat:@"%ld",[beishuChoose.text integerValue]-1];
            mutArry[but.tag] = [NSString stringWithFormat:@"%ld",[mutArry[but.tag]integerValue]-1];
        }else {
            beishuChoose.text = [NSString stringWithFormat:@"%ld",[beishuChoose.text integerValue]+1];
            mutArry[but.tag] = [NSString stringWithFormat:@"%ld",[mutArry[but.tag]integerValue]+1];
        }
    
    } else{
        if ([state isEqualToString:@"down"]) {
            mutArry[but.tag] = [NSString stringWithFormat:@"%ld",[mutArry[but.tag]integerValue]-1];
        }else {
            mutArry[but.tag] = [NSString stringWithFormat:@"%ld",[mutArry[but.tag]integerValue]+1];
        }
        
    }
    [self updateSummary];
    [listTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (nil != self.navigationController) {
        BOOL numlistfalg = poptype;
        poptype = NO;
        [self.delegate NumListShow:numlistfalg];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)clearSelect {
    [self.transaction removeAllBets];
    self.transaction.beiTouCount = 1;
    self.transaction.qiShuCount  = 1;
    self.transaction.winStopStatus = WINSTOP;
}

- (void) optionRightButtonAction {
    WebViewController *webVC = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    webVC.type = @"html";
    webVC.title = @"规则介绍";
    webVC.htmlName = @"zhuihao";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}

- (void) loadUI {
    [self showLoadingViewWithText: TextLoading];
    CGFloat curY = 0;
    [self loadConentView:curY];
    [self reloadTableView];
    [self hideLoadingView];
}

- (void)loadConentView:(float)curY{
    //停止追号按钮默认选中
    [WinStop setSelected:YES];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 31, KscreenWidth, SEPHEIGHT)];
    lineView.backgroundColor = SEPCOLOR;
    [BottomView addSubview:lineView];
    
    NSString * lotteryIdentify = _lottery.identifier;
    //add this phase information
    //期号: 054   距截止还有 1天5小时
        [self loadphaseInfoView];
        CGRect phaseSectionFrame = CGRectMake(0, 10, KscreenWidth, PhaseInfoHeight * 2);
        //玩法显示
        UILabel *playlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, phaseSectionFrame.origin.y+30, 135, 30)];
        playlabel.font = [UIFont systemFontOfSize:13];
        playlabel.textColor = TEXTGRAYCOLOR;
        BetsList = [self.transaction allBets];
        NSString *lotteryName;
        if ([lotteryIdentify isEqualToString:@"SD115"]) {
            lotteryName = @"山东11选5";
        }else {
            lotteryName = @"陕西11选5";
        }
        playlabel.text = [NSString stringWithFormat:@"玩法：%@(%@)",[BetsList[0] valueForKey:@"betProfile"],lotteryName];
        playlabel.adjustsFontSizeToFitWidth = YES;
        [ContentView addSubview: playlabel];

        //倍数、期号
        UILabel *beishu = [[UILabel alloc]initWithFrame:CGRectMake(10, phaseSectionFrame.origin.y+30+27, 30, 30)];
        beishu.text = @"倍数:";
        beishu.adjustsFontSizeToFitWidth = YES;
        beishu.textColor = TEXTGRAYCOLOR;
        beishu.font = [UIFont systemFontOfSize:13];
        [ContentView addSubview:beishu];
        
        UIView *beishuview = [[UIView alloc]initWithFrame:CGRectMake(10+30+5, phaseSectionFrame.origin.y+30+27, 90, 37)];
        //倍数减小按钮
        UIButton *beishudownBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 3, 25, 25)];
        [beishudownBtn setImage:[UIImage imageNamed:@"touzhubeishujian.png"] forState:UIControlStateNormal];
        [beishudownBtn setImage:[UIImage imageNamed:@"touzhubeishujian.png"] forState:UIControlStateHighlighted];
        [beishudownBtn addTarget: self action: @selector(beishudownBtnClick) forControlEvents: UIControlEventTouchUpInside];
        //中间显示框
        beishuChoose = [[UITextField alloc]initWithFrame:CGRectMake(beishudownBtn.bounds.size.width-1, 3, 25, 25)];
        beishuChoose.font = [UIFont systemFontOfSize:12];
        beishuChoose.text = @"1";
        beishuChoose.textAlignment = NSTextAlignmentCenter;
        
        beishuChoose.layer.borderWidth = SEPHEIGHT;
        beishuChoose.backgroundColor = [UIColor whiteColor];
        beishuChoose.layer.borderColor = SEPCOLOR.CGColor;
        beishuChoose.delegate = self;
        beishuChoose.keyboardType = UIKeyboardTypeNumberPad;
        //倍数增加按钮
        //倍数、期号

        UIButton *beishuUpBtn = [[UIButton alloc]initWithFrame:CGRectMake(beishuview.bounds.size.width-41, 3, 25, 25)];
        [beishuUpBtn setImage:[UIImage imageNamed:@"touzhubeishujia.png"] forState:UIControlStateNormal];
        [beishuUpBtn setImage:[UIImage imageNamed:@"touzhubeishujia.png"] forState:UIControlStateHighlighted];
        [beishuUpBtn addTarget: self action: @selector(beishuUpBtnClick) forControlEvents: UIControlEventTouchUpInside];
        
        [beishuview addSubview:beishudownBtn];
        [beishuview addSubview:beishuUpBtn];
        [beishuview addSubview:beishuChoose];
        [ContentView addSubview:beishuview];
        
        //期号
        UILabel *qishu = [[UILabel alloc]initWithFrame:CGRectMake(140, phaseSectionFrame.origin.y+30+27, 30, 30)];
        qishu.text = @"期数:";
        qishu.adjustsFontSizeToFitWidth = YES;
        qishu.textColor = TEXTGRAYCOLOR;
        qishu.font = [UIFont systemFontOfSize:13];
        [ContentView addSubview:qishu];
        
        UIView *Jiangqiview = [[UIView alloc]initWithFrame:CGRectMake(beishuview.bounds.origin.x+beishuview.bounds.size.width+90, phaseSectionFrame.origin.y+30+27, 90, 37)];
        //奖期减小按钮
        UIButton *JiangqidownBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 3, 25, 25)];
        [JiangqidownBtn setImage:[UIImage imageNamed:@"touzhubeishujian.png"] forState:UIControlStateNormal];
        [JiangqidownBtn setImage:[UIImage imageNamed:@"touzhubeishujian.png"] forState:UIControlStateHighlighted];
        [JiangqidownBtn addTarget: self action: @selector(JiangqidownBtnClick) forControlEvents: UIControlEventTouchUpInside];
        //中间显示框
        JiangqiChoose = [[UITextField alloc]initWithFrame:CGRectMake(beishudownBtn.bounds.size.width-1, 3, 25, 25)];
        NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_issue];
        JiangqiChoose.text = str;
        JiangqiChoose.font = [UIFont systemFontOfSize:12];
        JiangqiChoose.textAlignment = NSTextAlignmentCenter;
        JiangqiChoose.layer.borderWidth = SEPHEIGHT;
        JiangqiChoose.backgroundColor = [UIColor whiteColor];
        JiangqiChoose.layer.borderColor = SEPCOLOR.CGColor;
        
        JiangqiChoose.delegate = self;
        JiangqiChoose.keyboardType = UIKeyboardTypeNumberPad;

        //奖期增加按钮
        UIButton *JiangqiUpBtn = [[UIButton alloc]initWithFrame:CGRectMake(beishuview.bounds.size.width-41, 3, 25+SEPHEIGHT, 25)];
        [JiangqiUpBtn setImage:[UIImage imageNamed:@"touzhubeishujia.png"] forState:UIControlStateNormal];
        [JiangqiUpBtn setImage:[UIImage imageNamed:@"touzhubeishujia.png"] forState:UIControlStateHighlighted];
        [JiangqiUpBtn addTarget: self action: @selector(JiangqiUpBtnClick) forControlEvents: UIControlEventTouchUpInside];
        //奖金优化按钮
        UIButton *JoptimizeBtn = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth-100, phaseSectionFrame.origin.y+30+29, 80, 25)];
        if ([self isIphone5s]) {
            JoptimizeBtn.mj_w = 55;
            JoptimizeBtn.mj_x = KscreenWidth - 65;
        }
        [JoptimizeBtn setTitle:@"优化方案" forState:UIControlStateNormal];
        JoptimizeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [JoptimizeBtn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(252, 148, 18)] forState:UIControlStateNormal];
        JoptimizeBtn .layer.cornerRadius = 3;
        JoptimizeBtn.layer.masksToBounds = YES;
        [JoptimizeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        JoptimizeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [JoptimizeBtn addTarget: self action: @selector(JoptimizeBtnClick) forControlEvents: UIControlEventTouchUpInside];
        
        [Jiangqiview addSubview:JiangqidownBtn];
        [Jiangqiview addSubview:JiangqiUpBtn];
        [Jiangqiview addSubview:JiangqiChoose];
        [ContentView addSubview:JoptimizeBtn];
        [ContentView addSubview:Jiangqiview];
        
        [self loadTitleView];
        [self loadBeishushow];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
        return NO;
    }
    
    if ([string isEqualToString:@""]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger temp;
            if ([textField.text integerValue] == 0) {
                temp = 1;
                
            }else{
                temp =[textField.text integerValue];
            }
            if (textField == self->beishuChoose) {
                self->mutArry[0] = [NSString stringWithFormat:@"%ld",temp];
            }else{
                self->_issue = temp;
            }
            [self->listTableView reloadData];
            [self updateSummary];
        });
        
        return YES;
    }
    NSMutableString*numStr = [[NSMutableString alloc]initWithString:textField.text];
    [numStr appendString:string];
    NSInteger num = [numStr integerValue];
    NSInteger limitNum;
    if (textField == beishuChoose) {
        limitNum = 99;
        if (num > limitNum) {
            [self showPromptText:[NSString stringWithFormat:@"最大可投%ld倍",limitNum] hideAfterDelay:1.8];
            return NO;
        }
        
        mutArry[0] = numStr;
        [listTableView reloadData];
        [self updateSummary];
    }else {
        limitNum =  maxQi - curiss+1;
    
        if (num > limitNum) {
            JiangqiChoose.text = [NSString stringWithFormat:@"%lu", limitNum];
            [self showPromptText:[NSString stringWithFormat:@"今日最大可追%lu期，系统不支持跨日追号", limitNum] hideAfterDelay:1.7];
            _issue = limitNum;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self->listTableView reloadData];
                [self updateSummary];
            });
            return NO;
        }
        _issue = [numStr integerValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->listTableView reloadData];
            [self updateSummary];
        });
       
    }
    
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([textField .text integerValue] ==0){
        textField.text = @"1";
    }
    textField.text = [NSString stringWithFormat:@"%ld",[textField .text integerValue]];
}

-(void) loadTitleView{
    CGFloat width = KscreenWidth;
    UIView *Hline1 = [[UIView alloc] initWithFrame:CGRectMake(0, 103, width, SEPHEIGHT)];
    UIView *Hline2 = [[UIView alloc] initWithFrame:CGRectMake(0, 128, width, SEPHEIGHT)];
    Hline1.backgroundColor = SEPCOLOR;
    [ContentView addSubview:Hline1];
    Hline2.backgroundColor = SEPCOLOR;
    [ContentView addSubview:Hline1];
    [ContentView addSubview:Hline2];
    
    UIView * Vline[VlineCount];
    UILabel* titlelable[VlineCount+1];
    for(NSInteger i=0;i<=VlineCount;i++)
    {
        if(i<3)
        {
            if(i>1)
            {
                Vline[i] = [[UIView alloc] initWithFrame:CGRectMake(35*(i+1)+45, 103,SEPHEIGHT,25)];
                titlelable[i] = [[UILabel alloc]initWithFrame:CGRectMake(35*i+1, 103,80,25)];
                titlelable[i].text = @"倍数";
            }
            else{
                Vline[i] = [[UIView alloc] initWithFrame:CGRectMake(35*(i+1), 103,SEPHEIGHT,25)];
                titlelable[i] = [[UILabel alloc]initWithFrame:CGRectMake(35*i, 103,35,25)];
                if(i == 0){
                    titlelable[i].text = @"序号";
                }
                else{
                    titlelable[i].text = @"期号";
                }
            }
        }
        else{
            CGFloat X = (KscreenWidth-150)/3;
            if(i<VlineCount){
                Vline[i] = [[UIView alloc] initWithFrame:CGRectMake(150+(X*(i-2)), 103,SEPHEIGHT,25)];
                titlelable[i] = [[UILabel alloc]initWithFrame:CGRectMake(150+(X*(i-3)), 103,X,25)];
            }
            else{
                titlelable[i] = [[UILabel alloc]initWithFrame:CGRectMake(150+(X*(i-3)), 103,X,25)];
            }
            switch (i) {
                case 3:
                titlelable[i].text = @"累计投入";
                break;
                case 4:
                titlelable[i].text = @"最大盈利";
                break;
                case 5:
                titlelable[i].text = @"盈利率";
                break;
                default:
                break;
            }
        }
        if(i<VlineCount){
            Vline[i].backgroundColor = SEPCOLOR;
            [ContentView addSubview:Vline[i]];
        }
        titlelable[i].textAlignment = NSTextAlignmentCenter;
        titlelable[i].font = [UIFont systemFontOfSize:13];
        titlelable[i].textColor = TEXTGRAYCOLOR;
        [ContentView addSubview:titlelable[i]];
    }
}

-(void) loadBeishushow{
    if(mutArry.count == 0)
    {
        mutArry=[[NSMutableArray alloc]initWithCapacity:_issue];
        for(NSInteger k=0;k<_issue;k++)
        {
            mutArry[k] = @"1";
        }
    }
    if(mutArry.count < _issue)
    {
        NSMutableArray *tempmutArry = [[NSMutableArray alloc]initWithCapacity:_issue];
        for(int i=0;i<_issue;i++)
        {
            if(i<mutArry.count)
            tempmutArry[i] = mutArry[i];
            else{
                tempmutArry[i] = @"1";
            }
        }
        mutArry=[[NSMutableArray alloc]initWithCapacity:_issue];
        mutArry = tempmutArry;
    }
}


-(void)updateSummary{
    NSMutableAttributedString *betInfoString = [[NSMutableAttributedString alloc] init];
    
    NSMutableDictionary *textAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    textAttrsDictionary[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: @"共追" attributes: textAttrsDictionary]];
    
    NSMutableDictionary *numberAttrsDictionary = [NSMutableDictionary dictionaryWithCapacity: 2];
    numberAttrsDictionary[NSForegroundColorAttributeName] = RGBCOLOR(254, 165, 19);
    
    //bet count string
    NSString *betCountStr = [NSString stringWithFormat: @"%lu", (unsigned long)_issue];
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: betCountStr attributes: numberAttrsDictionary]];
    
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: @"期,共需" attributes: textAttrsDictionary]];
    NSString *yuanStr = [NSString stringWithFormat: @"%.1f", [self getTotal]*2.0*_zhushu];
    [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: yuanStr attributes: numberAttrsDictionary]];
     [betInfoString appendAttributedString: [[NSAttributedString alloc] initWithString: @"元" attributes: textAttrsDictionary]];
     bottomLabel.attributedText = betInfoString;
}

-(NSInteger)getTotal{
    NSInteger total = 0;
    for (int i = 0; i < _issue; i ++) {
        if (i >= mutArry.count) {
            total += 1;
            [mutArry addObject:@"1"];
        }else{
            total += [mutArry[i] integerValue];
        }
        
    }
    return total;
}
//奖期，倍投增减方法
-(void) beishuUpBtnClick
{
    if (_multiple > 98){
        return;
    }
    _multiple +=1;
    NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_multiple];
    beishuChoose.text = str;
    NSString *strmultiple= [NSString stringWithFormat:@"%lu",(unsigned long)_multiple];
    mutArry[0] = strmultiple;
    [listTableView reloadData];
    [self updateSummary];
}
-(void) beishudownBtnClick
{
    if((unsigned int)_multiple == 1)
    {
        return;
    }
    _multiple -=1;
    NSString *str = [NSString stringWithFormat:@"%u",(unsigned int)_multiple];
    beishuChoose.text = str;
    
    NSString *strmultiple= [NSString stringWithFormat:@"%lu",(unsigned long)_multiple];
    mutArry[0] = strmultiple;
    [listTableView reloadData];
    [self updateSummary];
}
-(void) JiangqiUpBtnClick
{
    if(_issue > maxQi - curiss)
    {
        [self showPromptText:[NSString stringWithFormat:@"今日最大可追%lu期，系统不支持跨日追号", _issue] hideAfterDelay:1.7];
        return;
    }
    _issue +=1;
    NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_issue];
    JiangqiChoose.text = str;
    
    [listTableView reloadData];
    [self updateSummary];
    
}

-(void) JiangqidownBtnClick
{
    if((unsigned int)_issue == 1)
    {
        return;
    }
    _issue -=1;
    NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_issue];
    JiangqiChoose.text = str;
    [listTableView reloadData];
    [self updateSummary];
}


//代理传值
-(void) changeValue:(NSInteger)issNum multiple:(NSInteger)multipleNum;
{
    _issue = issNum;
    NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_issue];
    JiangqiChoose.text = str;
    
    NSString *strmultiple= [NSString stringWithFormat:@"%ld",(long)multipleNum];
    mutArry[0] = strmultiple;
    beishuChoose.text = strmultiple;
    _multiple =[strmultiple integerValue];
    [listTableView reloadData];
    [self updateSummary];
}
-(void) schemeValue:(NSInteger)plantype lowprofit:(NSInteger)lowprofitNum;
{
    NSInteger n = _zhushu;
    //最多中奖注数get
    maxwin = [self getx115MaxWinCount];
    _planType = plantype;
    
    if(1 == plantype){
        _lowrate = lowprofitNum;
        float p = (float)lowprofitNum/100;//最低盈利率
        //全程最低盈利率
        //求出满足条件的总期数
        NSInteger sum = 2*n*_multiple;//累计投入
        mutArry = [[NSMutableArray alloc]initWithCapacity:maxQi];//倍数
        mutArry[0] = [NSString stringWithFormat:@"%lu",(unsigned long)_multiple];
        for(NSInteger i=1;i<maxQi;i++)
        {
            NSString *strMul;
            NSInteger muLNum;
            //根据最低盈利率求出每期的倍数，若倍数大于99或小于0，则舍弃
            muLNum = [self getmul:Maxprize n:n maxwin:(maxwin) sum:sum p:p];
            strMul = [NSString stringWithFormat:@"%ld",(long)muLNum];
            if (muLNum>0) {
                mutArry[i] = strMul;
            }
            if(muLNum == 99||muLNum <=0)
            {
                if(_issue > i)
                {
                    _issue = i;
                    //奖期改变，重新赋值
                    NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_issue];
                    JiangqiChoose.text = str;
                    NSString *msg =@"单期倍数超限，超限的期号不再显示";
                    [self showPromptText:msg hideAfterDelay:2.7];
                }
                [listTableView reloadData];
                [self updateSummary];
                return;
            }
            sum = [self getSum:sum mut:muLNum n:n];
        }
        flag = true;
        [listTableView reloadData];
        [self updateSummary];
    }else if(3 == plantype){
        _lowprofit = lowprofitNum;
        //全程最低盈利**元
        double p = (float)lowprofitNum;//最低盈利率
        //全程最低盈利
        //求出满足条件的总期数
        NSInteger mut = _multiple;//起始倍数
        mut = (int) ceilf((float)(p/(Maxprize*maxwin-2*n)));
        if(mut > 99)
        {
            mut = 99;
        }
        else if(mut < 1)
        {
            mut =1;
        }
        mutArry = [[NSMutableArray alloc]initWithCapacity:maxQi];//倍数
        mutArry[0] = [NSString stringWithFormat:@"%ld",(long)mut];
         NSInteger sum = 2*n*mut;//累计投入
        for(NSInteger i=1;i<maxQi;i++)
        {

        NSString *strMul;
        NSInteger muLNum;
        //根据最低盈利率求出每期的倍数，若倍数大于99或小于0，则舍弃
        muLNum = [self getmulplan3:Maxprize n:n maxwin:(maxwin) sum:sum pmoney:p];
        strMul = [NSString stringWithFormat:@"%ld",(long)muLNum];
        if (muLNum>0) {
            mutArry[i] = strMul;
        }
        //_issue = i;
        if(muLNum == 99||muLNum <=0)
        {
            if(_issue > i)
            {
                _issue = i;
                NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_issue];
                JiangqiChoose.text = str;
                NSString *msg =@"单期倍数超限，超限的期号不再显示";
                [self showPromptText:msg hideAfterDelay:2.7];
            }
            [listTableView reloadData];
            [self updateSummary];
            return;
        }
        sum = [self getSum:sum mut:muLNum n:n];
    }
    flag = true;
        [listTableView reloadData];
        [self updateSummary];
    }
    
   
}
-(void) schemeValue:(NSInteger)preissueNum prerateNum:(NSInteger)prerateNum laterateNum:(NSInteger)laterateNum;
{
    //前**期盈利率，之后盈利率
    _planType = 2;
    _preissue = preissueNum;
    _prerate = prerateNum;
    _laterate = laterateNum;
    
    NSInteger n = _zhushu;
    //最多中奖注数get
    maxwin = [self getx115MaxWinCount];
    
    //全程最低盈利率
    //求出满足条件的总期数
    float p;
    NSInteger total = maxQi;//最大期数
    NSInteger sum = 2*n*_multiple;//累计投入
    mutArry = [[NSMutableArray alloc]initWithCapacity:total];//倍数
    mutArry[0] = [NSString stringWithFormat:@"%lu",(unsigned long)_multiple];
    for(NSInteger i=1;i<total-1;i++)
    {
        if(i<preissueNum)
        {
            p = (float)prerateNum/100;//最低盈利率
        }
        else
        {
            p = (float)laterateNum/100;//最低盈利率
        }
        NSString *strMul;
        NSInteger muLNum;
        //根据最低盈利率求出每期的倍数，若倍数大于99或小于0，则舍弃
        muLNum = [self getmul:Maxprize n:n maxwin:(maxwin) sum:sum p:p];
        strMul = [NSString stringWithFormat:@"%ld",(long)muLNum];
        if (muLNum>0) {
             mutArry[i] = strMul;
        }
        if(muLNum == 99||muLNum <=0)
        {
            if(_issue > i)
            {
                _issue = i;
                NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_issue];
                JiangqiChoose.text = str;
                NSString *msg =@"单期倍数超限，超限的期号不再显示";
                [self showPromptText:msg hideAfterDelay:2.7];
            }
            [self loadBeishushow];
            
            [listTableView reloadData];
            [self updateSummary];
            return;
        }
        sum = [self getSum:sum mut:muLNum n:n];
    }
    flag = true;
    [self loadBeishushow];
    [listTableView reloadData];
    [self updateSummary];
    
}
/*
 sum:累计投入
 n:注数
 mut:倍数
 */
-(NSInteger)getSum:(NSInteger)sum mut:(NSInteger)mut n:(NSInteger)n
{
    NSInteger sumnum = sum+2*n*mut;
    return sumnum;
}
/*
 c:单注中奖金额
 n:购买注数
 maxwin:最多中奖注数
 sum:累计投入
 p:最低盈利率
 */
-(NSInteger)getmul:(NSInteger)prize n:(NSInteger)n maxwin:(NSInteger)Maxwin sum:(double)sum p:(float)p
{
    NSInteger result =  (int) ceilf((float)((p+1)*sum)/(prize*Maxwin-2*n*(p+1)));
    if(result > 99)
    {
        //如果超过倍数上限
        return 99;
    }
//    else if(result < 0)
//    {   //如果计算出的倍数为负数
//        return 1;
//    }
    else{
        return result;
    }
}
/*
 c:单注中奖金额
 n:购买注数
 maxwin:最多中奖注数
 sum:累计投入
 pmoney:最低盈利金额
 */
-(NSInteger)getmulplan3:(NSInteger)prize n:(NSInteger)n maxwin:(NSInteger)Maxwin sum:(double)sum pmoney:(double)pmoney
{
    NSInteger result;
    if((prize*maxwin) > (2*n)){
        result =  (int) ceilf((float)((float) (pmoney+sum)/(prize*maxwin-2*n)));
        if((result > 99) ){
            return 99;
        }
//        else if(result < 0){
//            return 1;
//        }
        else{
            return result;
        }
    }else{
        return 1;
    }
}

/*
 获取11选5最大中奖注数，前提：同一种玩法，单式多注
 */
-(NSInteger)getx115MaxWinCount
{
    NSString *playtype = [self getPlayType:0];
    NSArray *betslist = [self.transaction allBets];
    // 复式(或胆拖)或者单注
    if(betslist.count == 1)
    {
        LotteryBet*bet =betslist[0];
                         
        NSString *str =bet.betNumbersDesc.string;
                       
       
        NSArray *Array = [str componentsSeparatedByString:@"#"];
        NSArray *chArray1;
        NSArray *chArray2;
        if([Array count]>1)
        {
            
            chArray1 = [Array[0] componentsSeparatedByString:@","];
            chArray2 = [Array[1] componentsSeparatedByString:@","];
        }
        else{
            chArray2 = [str componentsSeparatedByString:@","];
        }
        
        //任二复式或单式单注
        if([playtype isEqualToString:@"202"]){
            if(chArray2.count < 3)
            {
                return 1;
            }
            else
            {
                if(chArray2.count == 3)
                {
                    return 3;
                }
                else if(chArray2.count == 4)
                {
                    return 6;
                }
                else
                {
                    return 10;
                }
            }
            
        }
        //任三复式或单式单注
        else if([playtype isEqualToString:@"203"]){
            if(chArray2.count < 4)
            {
                return 1;
            }
            else
            {
                if(chArray2.count == 4)
                {
                    return 4;
                }
                else
                {
                    return 10;
                }
            }
            
        }
        //任四复式或单式单注
        else if([playtype isEqualToString:@"204"]){
            if(chArray2.count < 5)
            {
                return 1;
            }
            else
            {
                return 5;
            }
        }
        
        //任五复式或单式单注
        else if([playtype isEqualToString:@"205"])
        {
            return 1;
        }
        //任六复式或单式单注
        else if([playtype isEqualToString:@"206"]){
            return chArray2.count-5;
        }
        //任七复式或单式单注
        else if([playtype isEqualToString:@"207"]){
            if(chArray2.count < 8)
            {
                return 1;
            }
            else
            {
                NSInteger temp = chArray2.count;
                return (temp-6)*(temp-5)/2;
            }
            
        }
        //任八复式或单式单注
        else if([playtype isEqualToString:@"208"]){
            {
                return 1;
            }
        }
        //胆拖
        else if([playtype isEqualToString:@"212"]){
            {
                if(chArray2.count < 5)
                {
                    return chArray2.count;
                }
                else
                {
                    return 4;
                }
            }
        }
        else if([playtype isEqualToString:@"213"]){
            {
              if([chArray1 count]==1&&![chArray1[0] isEqualToString:@""])
                {
                    if(chArray2.count == 2)
                    {
                        return 1;
                    }
                    else if(chArray2.count == 3)
                    {
                        return 3;
                    }
                    else
                    {
                        return 6;
                    }
                    
                }
                else if([chArray1 count]==2)
                {
                    if(chArray2.count < 4)
                    {
                        return chArray2.count;
                    }
                    else
                    {
                        return 3;
                    }
                }
            }
        }
        else if([playtype isEqualToString:@"214"]){
            {
                 if([chArray1 count]==1&&![chArray1[0] isEqualToString:@""])
                {
                    if(chArray2.count == 3)
                    {
                        return 1;
                    }
                    else
                    {
                        return 4;
                    }
                }
                else if(chArray2.count == 2)
                {
                    if(chArray2.count == 2)
                    {
                        return 1;
                    }
                    else
                    {
                        return 3;
                    }
                }
                else if (chArray2.count == 3)
                {
                    if(chArray2.count == 1)
                    {
                        return 1;
                    }
                    else
                    {
                        return 2;
                    }
                }
            }
        }
        else if([playtype isEqualToString:@"215"]){
            {
                return 1;
            }
        }
        else if([playtype isEqualToString:@"216"]){
            {
                return chArray1.count+chArray2.count-5;
            }
        }
        else if([playtype isEqualToString:@"217"]){
            {
                if (chArray2.count == 7-chArray1.count)
                {
                    return 1;
                }
                else
                {
                    NSInteger i = (chArray2.count-4)*(chArray2.count-5)/2;
                    return i;
                }
                
            }
        }
        else if([playtype isEqualToString:@"222"]){
            {
                return 1;
            }
        }
        else if([playtype isEqualToString:@"232"]){
            {
                return 1;
            }
        }
        else
        {
            return 1;
        }
    }
    //直一、直二、直三
    else if([playtype isEqualToString:@"201"]||[playtype isEqualToString:@"220"]||[playtype isEqualToString:@"230"])
    {
        NSMutableArray *numbers = [[NSMutableArray alloc]initWithCapacity:betslist.count];
        for(int i=0;i<betslist.count;i++){
            LotteryBet * bet = betslist[i];
            numbers[i] = bet.betNumbersDesc.string;
//            numbers[i] = [[betslist[i] valueForKey:@"betNumbersDesc"]valueForKey:@"mutableString"];
        }
        int count = [self getmaxmutcount:numbers];
        return count;
        
    }
    //前二组选(直选跟顺序有关，组选跟顺序无关，只要号码相同)
    else if([playtype isEqualToString:@"221"])
    {
        [self getMaxmutcount];
    }
    else if([playtype isEqualToString:@"231"])//前三组选
    {
        [self getMaxmutcount];
    }
    //任二到任八
    else
    {
        NSMutableArray *MutableArray = [[NSMutableArray alloc] init];
        LotteryBet * bet = betslist[0];
        
//        NSString *str = [[betslist[0] valueForKey:@"betNumbersDesc"]valueForKey:@"mutableString"];
//        MutableArray = [str componentsSeparatedByString:@","];
        for(int i=1;i<betslist.count;i++)
        {    LotteryBet * bet = betslist[i];
             NSString * str = bet.betNumbersDesc.string;
//             NSString *str = [[betslist[i] valueForKey:@"betNumbersDesc"]valueForKey:@"mutableString"];
            NSArray * array = [str componentsSeparatedByString:@","];
            for(int i=0;i<array.count;i++)
            {
                int count = 0;
                for(int j=0;j<MutableArray.count;j++)
                {
                    if(![array[i] isEqualToString:MutableArray[j]])
                    {
                        count++;
                    }
                }
                if(count == MutableArray.count)
                {
                    [MutableArray addObject:array[i]];
                }
            }
        }
        if(MutableArray.count <6 )
        {
            return betslist.count;
        }
        else
        {
            [self myCombineAlgorithm:MutableArray num:5];
            NSLog(@"Maxmulcount is %ld",(long)Maxmulcount);
            return Maxmulcount;
        }
    }
    return 1;
}
//任选方式获取最大倍数
-(int)RengetMaxmutcount
{
    return 1;
}
//组合算法 从M个数中取出N个数，无顺序
-(void)myCombineAlgorithm:(NSMutableArray*)src num:(int)getnum
{
    if (src.count == 0)
    {
        return;
    }
    else if(src.count < getnum)
    {
        return;
    }
// int m = src.count;
   int n = getnum;
    
    /*  初始化  */
    objLineIndex = 0;
    objarray = [[NSMutableArray alloc]init];
    NSMutableArray* tmp = [[NSMutableArray alloc]init];
    [self myCombine:src srcIndex:0 i:0 n:n tmp:tmp];
    
//     int i = objarray.count;
}

-(void)myCombine:(NSMutableArray*)src srcIndex:(int)srcIndex i:(int)i n:(int)n tmp:(NSMutableArray*)tmp
{
    NSArray *betslist = [self.transaction allBets];
    int j;
    for (j = srcIndex; j < src.count - (n - 1); j++ ) {
        tmp[i] = src[j];
        if (n == 1) {
//            objarray[objLineIndex] = tmp;
            //随机组合的五个号码，同当前选择的号码比较，
            int maxmul = 0;
            for(int i=0;i<betslist.count;i++)
            {
                
//                NSString *str = [[betslist[i] valueForKey:@"betNumbersDesc"]valueForKey:@"mutableString"];
                LotteryBet*bet =betslist[i];
                
                NSString *str =bet.betNumbersDesc.string;
                NSArray* array = [str componentsSeparatedByString:@","];
                int count =0;
                if(array.count<tmp.count)
                {
                    for(int i=0;i<array.count;i++)
                    {
                        for(int j=0;j<tmp.count;j++)
                        {
                            if([array[i] isEqualToString:tmp[j]])
                            {
                                count++;
                            }
                            
                        }
                    }
                    if(count == array.count)
                    {
                        maxmul++;
                    }
                }
                else
                {
                    for(int i=0;i<tmp.count;i++)
                    {
                        for(int j=0;j<array.count;j++)
                        {
                            if([array[j] isEqualToString:tmp[i]])
                            {
                                count++;
                            }
                            
                        }
                    }
                    if(count == tmp.count)
                    {
                        maxmul++;
                    }

                }
            }
            if(maxmul > Maxmulcount)
            {
                Maxmulcount = maxmul;
            }
//            objLineIndex ++;
        } else {
            n--;
            i++;
            [self myCombine:src srcIndex:j+1 i:i n:n tmp:tmp];
            n++;
            i--;
        }
    }
    
}

//public String[][] getResutl() {
//    return obj;
//}

//取得最大获奖倍数(组选复式)
-(int) getMaxmutcount
{
    NSArray *betslist = [self.transaction allBets];
    int Maxcount = 1;
    for (int i=0; i<betslist.count; i++) {
        int tempcount = 1;
        for(int j=i+1;j<betslist.count;j++)
        {
            LotteryBet*bet =betslist[i];
            
            NSString *str =bet.betNumbersDesc.string;
            
            LotteryBet*bet1 =betslist[j];
            
            NSString *str1 =bet1.betNumbersDesc.string;
            
//            NSString *str = [[betslist[i] valueForKey:@"betNumbersDesc"]valueForKey:@"mutableString"];
//            NSString *str1 = [[betslist[j] valueForKey:@"betNumbersDesc"]valueForKey:@"mutableString"];
            NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:str, nil];
            NSMutableSet *set1 = [[NSMutableSet alloc] initWithObjects:str1, nil];
            [set intersectSet:set1];

            if([set count]==1)
            {
                tempcount++;
            }
        }
        if(tempcount>Maxcount)
        {
            Maxcount = tempcount;
        }
    }
    return Maxcount;
}
//取得最大获奖倍数
-(int) getmaxmutcount:(NSMutableArray*) array
{
    int tempcount = 1;
    for(int i=0;i<array.count;i++)
    {
        int maxcount = 1;
        NSString *tempstr = array[i];
        for(int j= i+1;j<array.count;j++)
        {
            if([tempstr isEqualToString:array[j]])
            {
                maxcount++;
            }
        }
        if(maxcount > tempcount){
            tempcount = maxcount;
        }
        
    }
    return tempcount;
}
//获得总注数
-(int) getunits
{
    int units = 0;
    NSString *Strunits ;
    NSArray *betslist = [self.transaction allBets];
    for(NSInteger i=0;i<betslist.count;i++)
    {
        //注数计算
        Strunits = [betslist[i] valueForKey:@"betCount"];
        int intstrunits = [Strunits intValue];
        units += intstrunits;
    }
    return units;
}


- (IBAction)winStopClick:(id)sender {
    WinStop.selected = !WinStop.selected;
}
- (void)JoptimizeBtnClick {
    
    Optimizeview = [[optimizeView alloc]init];
    Optimizeview.issueNum = _issue;
    Optimizeview.multipleNum = _multiple;
    Optimizeview.lottery = _lottery;
    Optimizeview.lowrateNum = _lowrate;
    Optimizeview.preissueNum = _preissue;
    Optimizeview.prerateNum = _prerate;
    Optimizeview.laterateNum = _laterate;
    Optimizeview.lowprofitNum = _lowprofit;
    Optimizeview.planTypeNum = _planType;
    
    Optimizeview.delegate = self;
//    Optimizeview.hidden = NO;
//    [[UIApplication sharedApplication].keyWindow addSubview:Optimizeview];
    [Optimizeview show];
}

- (IBAction)actionToSubmit:(id)sender {
    if ([JiangqiChoose.text integerValue] <= 1) {
        [self showPromptText:@"追号期数至少2期" hideAfterDelay:1.7];
        return;
    }
    if(![self.lottery.currentRound.issueNumber isEqualToString:strcurRound]){
        [self showPromptText:@"起始追号期已截止" hideAfterDelay:1.7];
        return ;
    }
    for (int i = 0; i < _issue; i++) {
        if ([mutArry[i] integerValue] * _zhushu * 2 >20000) {
            [self showPromptText:@"单期投注金额不能超过2万" hideAfterDelay:1.7];
            return;
        }
    }
    if (self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    [self  updateMemberClinet];
}

-(void)updateMemberClinet{
    
    NSDictionary *MemberInfo;
    NSString *cardCode =self.curUser.cardCode;
    if (cardCode == nil) {
        return;
    }
    MemberInfo = @{@"cardCode":cardCode
                   };
    [self.memberMan getMemberByCardCodeSms:(NSDictionary *)MemberInfo];
}
-(void)getMemberByCardCodeSms:(NSDictionary *)memberInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    NSLog(@"memberInfo%@",memberInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        User *user = [[User alloc]initWith:memberInfo];
        self.curUser.notCash = user.notCash;
        self.curUser.balance = user.balance;
        self.curUser.sendBalance = user.sendBalance;
        [self payJudge];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}


- (void)instance:(GlobalInstance *)instance RefreshedUserInfo:(User *)user{
    [self payJudge];
    
}
- (void)payJudge{

    //    NSString *strbalance = curUser.balance_caijin;
    //    float balance = [strbalance floatValue];
    CGFloat balance =[[self.curUser totalBanlece] doubleValue];
    CGFloat needMoney = [self getTotal]*2.0*_zhushu;
//    if (balance < needMoney) {
//        [self showPromptText:[NSString stringWithFormat:@"账户余额:%.2f元,余额不足",balance] hideAfterDelay:2];
//        return;
//    }
    NSString *msg = [NSString stringWithFormat:@"共追%lu期，共需%.1f元,是否确定追号？",(unsigned long)_issue,needMoney];
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"追号确认"
//                                                   message:msg
//                                                  delegate:self
//                                         cancelButtonTitle:@"取消"
//                                         otherButtonTitles:@"确定",nil];
//    alert.tag = ZHSURETAG;
//    [alert show];
    
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"追号确认" message:msg];
    [alert addBtnTitle:TitleNotDo action:^{
        
        [self hideLoadingView];
    }];
    [alert addBtnTitle:TitleDo action:^{
        [self actionTouZhu];
    }];
    [alert showAlertWithSender:self];
}

- (BOOL)isExceedLimitAmount{
    
    int costTotal = 0;
    for (LotteryBet * bet in [_transaction allBets]) {
        costTotal += [bet getBetCost];
    }
    if (costTotal > 300000) {
        return YES;
    }
    return NO;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 1000){
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self actionTouZhu];
        }
    }
}


-(void)actionTouZhu
{
    [self setZNZHDic];
    
    if ([self isExceedLimitAmount]) {
        [self showPromptText:TextTouzhuExceedLimit hideAfterDelay:1.7];
        return;
    }
    if (self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    [self nopayword];
}


//11.07
- (void)nopayword
{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //用户名
    
    
    NSString *username = self.curUser.cardCode;
    [myDelegate.ZHDic setObject:username forKey:@"cardCode"];
    self.transaction.qiShuCount = (int)[self getZhuiHaoInfo].count;
    if (WinStop.selected == YES) {
        self.transaction.winStopStatus = WINSTOP;
    }else{
        self.transaction.winStopStatus = NOTSTOP;
    }
    PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
    payVC.basetransction = self.transaction;
    payVC.subscribed = [self getTotal]*2.0*_zhushu;
    payVC.schemetype = SchemeTypeZhuihao;
    payVC.zhuiArray = [self getZhuiHaoInfo];
    payVC.lotteryName = @"陕西11选5";
    payVC.delegate = self;
    [self.navigationController pushViewController:payVC animated:YES];
}



//10.30
- (void)showPayPopView{
    if (nil == passInput) {

        passInput = [[WBInputPopView alloc]init];
        passInput.delegate = self;
        passInput.labTitle.text = @"请输入支付密码";
    }

    [self.view addSubview:passInput];
    [passInput createBlock:^(NSString *text) {
        
        if (nil == text) {
            [self showPromptText:TextNoPwdAlert hideAfterDelay:1.7];
            return;
        }
        NSDictionary * paraInfo = @{@"cardCode":self.curUser.cardCode == nil?@"":self.curUser.cardCode,
                                    @"payPassword":text};
        [self showPromptText:TextSubmitForVerify hideAfterDelay:1.7];
        NSDictionary *cardInfo= @{@"cardCode":self.curUser.cardCode,
                                  @"payPwd":[AESUtility encryptStr:text]};
        [self.memberMan validatePaypwdSms:cardInfo];
    }];

}


-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [passInput removeFromSuperview];
    if (success == YES) {
        [self nopayword];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

- (void)submitCatcherror:(NSString *)errorMsg
{
    
    [self showPromptText:errorMsg hideAfterDelay:3];
}

-(void) settags
{
    /*
     遍历彩种，判断推送发送条件，设置标签
     */
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *array = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    PushData = @[array[0],array[1],array[2]];
    
    NSMutableSet *tags = [[NSMutableSet alloc]init];
    
    NSString *username = self.curUser;
    for(int i=0;i<[PushData count];i++)
    {
        NSString* str1 = @"groupId";
        NSString* str2 = [NSString stringWithFormat: @"%d",i];
        NSString *string = [str1 stringByAppendingString:str2];
        NSString * CurSel = [myDelegate.Dic objectForKey:string];
        NSString* strawardrst_ = @"awardrst_";
        NSString* straward = @"";
        //获得彩种
        switch (i) {
            case 0: straward = @"SX115";
                break;
            
            case 3:
                break;
            case 4:
                break;
            case 5:
                break;
            case 6:
                break;
            case 7: straward = @"JCZQ";
                break;
            default:
                break;
        }
        NSString* str_ = @"_";
        NSString* strawardperiod = [straward stringByAppendingString:@"_period"];
        NSMutableArray* Arraygamename = [myDelegate.Dic objectForKey:strawardperiod];
        if([CurSel isEqualToString:@"radio_buy"])
        {
            for (NSString* strgamename in Arraygamename)
            {
                NSString *stringtemp1 = [strawardrst_ stringByAppendingString:straward];
                NSString *stringtemp2 = [stringtemp1 stringByAppendingString:str_];
                NSString *stringtag = [stringtemp2 stringByAppendingString:strgamename];
                [tags addObject: stringtag];
            }
        }
        else if([CurSel isEqualToString:@"radio_always"])
        {
            NSString *stringtag = [strawardrst_  stringByAppendingString:straward];
            [tags addObject: stringtag];
        }
        if(Arraygamename.count)
        {
            [myDelegate.Dic setObject:Arraygamename forKey:strawardperiod];
        }
    }
     NSString *UserCard = [NSString stringWithFormat:@"%@",username];
    [JPUSHService setTags:tags
                 alias:UserCard
      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                object:self];
    
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


-(void) setZNZHDic{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //用户名
    //    User * curuser;
    //    curuser = [GlobalInstance instance].curUser;
    //    NSString *username = curuser.username;
    //    if([username isEqual:[NSNull class]]){
    //        [myDelegate.ZHDic setObject:username forKey:@"userName"];
    //    }
    //起始期号
    NSString * beginIssue = [_lottery.currentRound valueForKey:@"issueNumber"];
    [myDelegate.ZHDic setObject:beginIssue forKey:@"beginIssue"];
    //选择号码内容
    NSArray *betslist = [self.transaction allBets];
    NSString *Strunits ;
    NSString *catchcontent = @"";
    NSString *playtype;
    int units = 0;
    for(int i=0;i<betslist.count;i++)
    {
        //注数计算
        Strunits = [betslist[i] valueForKey:@"betCount"];
        int intstrunits = [Strunits intValue];
        units += intstrunits;
        LotteryBet*bet =betslist[i];
        
        NSString *str =bet.betNumbersDesc.string;
//        NSString *str = [[betslist[i] valueForKey:@"betNumbersDesc"]valueForKey:@"mutableString"];
        playtype = [self getPlayType:i];
//        if([playtype isEqualToString:@"230"]||[playtype isEqualToString:@"220"])
//        {
//            str =[str stringByReplacingOccurrencesOfString:@"#" withString:@","];
//        }
        if([catchcontent isEqualToString:@""])
        {
            catchcontent = str;
        }
        else{
            catchcontent = [catchcontent stringByAppendingString:@";"];
            catchcontent = [catchcontent stringByAppendingString:str];
        }
        
    }
    
    [myDelegate.ZHDic setObject:catchcontent forKey:@"catchContent"];
    [myDelegate.ZHDic setObject:beginIssue forKey:@"beginIssue"];
    //betType
    NSDictionary *bettypedic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"BetType" ofType: @"plist"]];
    
    NSInteger intplayType = [playtype intValue];
    if(intplayType == 212 || intplayType == 213 || intplayType == 214 || intplayType == 215 || intplayType == 216 || intplayType == 217 || intplayType == 222 || intplayType == 232)
    {
        NSNumber *num = [bettypedic objectForKey:@"Towed"];
        [myDelegate.ZHDic setObject:num forKey:@"betType" ];
    }
    else if(intplayType == 229 || intplayType == 239)
    {
        NSNumber *num = [bettypedic objectForKey:@"Direct"];
        [myDelegate.ZHDic setObject:num forKey:@"betType" ];
    }
    //前一 201 和 任八 208 没有 复式
    else if([Strunits intValue] > 1 && intplayType != 208 && intplayType != 201)
    {
        NSNumber *num = [bettypedic objectForKey:@"Double"];
        [myDelegate.ZHDic setObject:num forKey:@"betType" ];
    }
    else
    {
        NSNumber *num = [bettypedic objectForKey:@"Single"];
        [myDelegate.ZHDic setObject:num forKey:@"betType" ];
    }

    //playType
    NSNumber * playType;
    switch ([playtype intValue]) {
        case 212:
            playType = [NSNumber numberWithInt:202];
            break;
        case 213:
            playType = [NSNumber numberWithInt:203];
            break;
        case 214:
            playType = [NSNumber numberWithInt:204];
            break;
        case 215:
            playType = [NSNumber numberWithInt:205];
            break;
        case 216:
            playType = [NSNumber numberWithInt:206];
            break;
        case 217:
            playType = [NSNumber numberWithInt:207];
            break;
        case 222:
            playType = [NSNumber numberWithInt:221];
            break;
        case 232:
            playType = [NSNumber numberWithInt:231];
            break;
        case 229:
            playType = [NSNumber numberWithInt:220];
            break;
        case 239:
            playType = [NSNumber numberWithInt:230];
            break;
        default:
            playType = [NSNumber numberWithInt:[playtype intValue]];;
            break;
    }
    [myDelegate.ZHDic setObject:playType forKey:@"playType"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger count = [JiangqiChoose.text intValue];
    for(NSInteger i=0;i<count;i++)
    {
        NSString *Roundnum = [_lottery.currentRound valueForKey:@"issueNumber"];
        int intString = [Roundnum intValue];
        NSString* curRoundnum = [NSString stringWithFormat:@"%zi", intString+i];
        //以期号初始化字典
        NSMutableDictionary *issdic =[NSMutableDictionary dictionaryWithObjectsAndKeys:curRoundnum, @"issueNumber",nil];
        //追号状态(追号中,停追,取消)
        [issdic setObject:@"0" forKey:@"catchStatus"];
        [issdic setObject:@"0.0" forKey:@"bonus"];
        [issdic setObject:mutArry[i] forKey:@"mutiple"];
        [issdic setObject:@"0" forKey:@"payStatus"];
        NSString *str_units = [NSString stringWithFormat:@"%d",units];
        [issdic setObject:str_units forKey:@"units"];
        [issdic setObject:@"0" forKey:@"winningStatus"];
        [array addObject:issdic];
    }
    [myDelegate.ZHDic setObject:array forKey: @"catchList"]
    ;
    //中奖后是否停追
    if(WinStop.selected)
    {
        [myDelegate.ZHDic setObject:@"WINSTOP"forKey:@"winStopStatus"];
    }else{
        [myDelegate.ZHDic setObject:@"NOTSTOP"forKey:@"winStopStatus"];
    }
    
  
   
    [myDelegate.ZHDic setObject:@"0"forKey:@"winStatus"];
    //来源ios
    [myDelegate.ZHDic setObject:@"2"forKey:@"betSource"];
    [myDelegate.ZHDic setObject:JiangqiChoose.text forKey:@"totalCatch"];
    [myDelegate.ZHDic setObject:@"0.0"forKey:@"orderbonus"];
    [myDelegate.ZHDic setObject:@"0.0"forKey:@"bonus"];
    //剩余追期数
    [myDelegate.ZHDic setObject:JiangqiChoose.text forKey:@"catchIndex"];
    //追号状态
    [myDelegate.ZHDic setObject:@"0" forKey:@"catchStatus"];
    //是否机选
//    if(_RadomgetNumBtn.selected){
////        [myDelegate.ZHDic setObject:@"1" forKey:@"catchType"];
//    }
//    else{
//        [myDelegate.ZHDic setObject:@"0" forKey:@"catchType"];
//    }
    //修改时间
    NSDate * timeDate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * morelocationString=[dateformatter stringFromDate:timeDate];
    [myDelegate.ZHDic setObject:morelocationString forKey:@"modifyTime"];
    [myDelegate.ZHDic setObject:morelocationString forKey:@"createTime"];
}

-(NSString *)getPlayType:(int)i
{
    NSArray *betslist = [self.transaction allBets];
    NSString *betType;
    if(betslist.count > i)
    {
        betType = [betslist[i] valueForKey:@"betTypeDesc"];
    }
    NSString *playType;
    if([betType isEqualToString:@"任选五"])
    {
        playType = @"205";
        Maxprize = 540;
    }
    else if([betType isEqualToString:@"任选二"])
    {
        playType = @"202";
        Maxprize = 6;
    }
    
    else if([betType isEqualToString:@"任选三"])
    {
        playType = @"203";
        Maxprize = 19;
    }
    else if([betType isEqualToString:@"任选四"])
    {
        playType = @"204";
        Maxprize = 78;
    }
    else if([betType isEqualToString:@"任选六"])
    {
        playType = @"206";
        Maxprize = 90;
    }
    else if([betType isEqualToString:@"任选七"])
    {
        playType = @"207";
        Maxprize = 26;
    }
    else if([betType isEqualToString:@"任选八"])
    {
        playType = @"208";
        Maxprize = 9;
    }
    else if([betType isEqualToString:@"前一"])
    {
        playType = @"201";
        Maxprize = 13;
    }
    else if([betType isEqualToString:@"前二直选"])
    {
        playType = @"220";
        Maxprize = 130;
    }
    else if([betType isEqualToString:@"前二直选复式"])
    {
        playType = @"229";
        Maxprize = 130;
    }
    else if([betType isEqualToString:@"前三直选"])
    {
        playType = @"230";
        Maxprize = 1170;
    }
    else if([betType isEqualToString:@"前三直选复式"])
    {
        playType = @"239";
        Maxprize = 1170;
    }
    
    else if([betType isEqualToString:@"前二组选"])
    {
        playType = @"221";
        Maxprize = 65;
    }
    else if([betType isEqualToString:@"组二胆拖"])
    {
        playType = @"222";
        Maxprize = 65;
    }
    
    else if([betType isEqualToString:@"前三组选"])
    {
        playType = @"231";
        Maxprize = 195;
    }
    else if([betType isEqualToString:@"组三胆拖"])
    {
        playType = @"232";
        Maxprize = 195;
    }
    
    else if([betType isEqualToString:@"任选二胆拖"])
    {
        playType = @"212";
        Maxprize = 6;
    }
    else if([betType isEqualToString:@"任选三胆拖"])
    {
        playType = @"213";
        Maxprize = 19;
    }
    else if([betType isEqualToString:@"任选四胆拖"])
    {
        playType = @"214";
        Maxprize = 78;
    }
    else if([betType isEqualToString:@"任选五胆拖"])
    {
        playType = @"215";
        Maxprize = 540;
    }
    else if([betType isEqualToString:@"任选六胆拖"])
    {
        playType = @"216";
        Maxprize = 90;
    }
    else if([betType isEqualToString:@"任选七胆拖"])
    {
        playType = @"217";
        Maxprize = 26;
    }
    return playType;
}

-(void)loadphaseInfoView
{
    CGRect phaseSectionFrame = CGRectMake(0, 0, KscreenWidth, PhaseInfoHeight * 2);
    if(phaseInfoView == nil){
        phaseInfoView = [[LotteryPhaseInfoView alloc] initWithFrame: phaseSectionFrame];
        phaseInfoView.delegate = self;
    }
    [phaseInfoView drawWithLotteryNoButton: self.lottery];
    [ContentView addSubview: phaseInfoView];
    [self beginTimerForCurRound];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginTimerForCurRound) name:@"RoundTimeDownFinish" object:nil];
}

-(void)beginTimerForCurRound{
    [self getCurrentRound];
//    @try {
//        [timerForcurRound invalidate];//强制定时器失效
//        timerForcurRound = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(getCurrentRound) userInfo:nil repeats:YES];
//        [timerForcurRound fire];
//    } @catch (NSException *exception) {
//
//    }
}



- (void) getCurrentRound{
    NSLog(@"开始请求奖期。");
    [self.lotteryMan getSellIssueList:@{@"lotteryCode":self.transaction.lottery.identifier}];
}
#pragma mark - LotteryManagerDelegate methods
-(void)gotLotteryCurRoundTimeout {
    [self hideLoadingView];
    [self showPromptText:requestTimeOut hideAfterDelay:3.0];
    
}

-(void)gotLotteryCurRound:(LotteryRound *)round{
    if (round) {
        [timerForcurRound invalidate];

        _lottery.currentRound = round;
//        NSString * str = [_lottery.currentRound valueForKey:@"number"];
         NSString * str = [_lottery.currentRound valueForKey:@"issueNumber"];
        [phaseInfoView showCurRoundInfo];
        if(![str isEqualToString:strcurRound])
        {
            NSString *msg =@"奖期已经更新";
            [self showPromptText:msg hideAfterDelay:2.7];
            [self loadBeishushow];
        }
      
    }
}

-(NSArray*)getZhuiHaoInfo
{
  
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *issueMultiple = [NSMutableArray arrayWithCapacity:0];
    NSArray *catchList = myDelegate.ZHDic[@"catchList"];
    
    for (NSDictionary *dic in catchList) {
        NSInteger cost  = [dic[@"mutiple"] doubleValue]*  [dic[@"units"] doubleValue] * 2;
        NSDictionary * temp = @{@"issueNumber":dic[@"issueNumber"],
                                @"multiple":dic[@"mutiple"],
                                @"units":dic[@"units"],
                                @"cost":@(cost)
                                };
        
        [issueMultiple addObject:temp];
    }
    
    return issueMultiple;
    
}


-(void)betedChaseScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (schemeNO == nil) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    ZhuiHaoInfoViewController * betInfoViewCtr = [[ZhuiHaoInfoViewController alloc] initWithNibName:@"ZhuiHaoInfoViewController" bundle:nil];
    
    //    betInfoViewCtr.ZHflag = YES;
    betInfoViewCtr.from = YES;
    [self.navigationController pushViewController:betInfoViewCtr animated:YES];
}


@end

