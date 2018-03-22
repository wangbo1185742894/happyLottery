//
//  CTZQTouZhuViewController.m
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQTouZhuViewController.h"
#import "PayOrderViewController.h"
#import "LotteryTimeCountdownView.h"
#import "CTZQTouzhuRenjiuCell.h"
#import "CTZQTouzhuShisiCell.h"
#import "CTZQOpenLotteryViewController.h"
#import "SelectView.h"
#import "CTZQBet.h"
#import "CalcuCount.h"
#import "SchemeCashPayment.h"

#import "LotteryManager.h"
#import "ZLAlertView.h"
#define BACKTAG 12322
@interface CTZQTouZhuViewController ()<UITableViewDataSource,UITableViewDelegate,CTZQTouzhuRenjiuCellRefreshDelegate,SelectViewDelegate,LotteryManagerDelegate,UIAlertViewDelegate,LotteryTimeCountdownViewDelegate>
{
    __weak IBOutlet UIButton *btnMoniTouzhu;
    __weak IBOutlet UIButton *btnZhenShiTouzhu;
    float keyboardheight;
    float keyboardheight2;
    NSInteger beiCount;
    BOOL keyboard;
    __weak IBOutlet UIButton *btnHemai;
    LotteryTimeCountdownView *timeCountDownView0;
    
    __weak IBOutlet UIButton *btnZigou;
}

@property(nonatomic,strong)SelectView*peiSelectView;
@end

@implementation CTZQTouZhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_cTransation.ctzqPlayType == CTZQPlayTypeRenjiu) {
        self.title = @"任选9投注";
    }else if (_cTransation.ctzqPlayType == CTZQPlayTypeShiSi){
        self.title = @"胜负14场投注";
    }

    self.lotteryMan.delegate  = self;
    
    UIImage*image = [UIImage imageNamed:@"buttonBG_orange"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
    [_matchInfoBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    UIImage*imageHeight = [UIImage imageNamed:@"buttonBG_orange_selected"];
    imageHeight = [imageHeight resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) resizingMode:UIImageResizingModeStretch];
    [_matchInfoBtn setBackgroundImage:imageHeight forState:UIControlStateHighlighted];
    
    self.peiSelectView = [[SelectView alloc]initWithFrame:CGRectMake(KscreenWidth - 200, 40, 190, 25) andRightTitle:@"投" andLeftTitle:@"倍"];
    self.peiSelectView.beiShuLimit = 9999;
    self.peiSelectView.delegate = self;
    self.peiSelectView.labContent.text = _cTransation.beitou;;

    [self.peiSelectView setTarget:self rightAction:@selector(actionAdd) leftAction:@selector(actionSub)];
    [self.viewBottom addSubview:self.peiSelectView];
    
    self.tabContentList.dataSource = self;
    self.tabContentList.delegate = self;
    [self.tabContentList reloadData];
    self.tabContentList.rowHeight = 90;
   self.peiSelectView.labContent.text= _cTransation.beitou;
    beiCount = [self.peiSelectView.labContent.text integerValue];
    [self refreshTouzhuVCSummary];
    
    [self checkIfNeedDan];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(issueTimeCountDown:) name:@"IssueTimeCountDown" object:nil];
    
    
    if (timeCountDownView0 == nil) {
        timeCountDownView0 = [[LotteryTimeCountdownView alloc] initWithFrame:self.labTimeTitle.frame];
        timeCountDownView0.timeCutType = TimeCutTypePlayPage;
        timeCountDownView0.delegate = self;
        //        [timeCountDownView startTimeCountdown:self.lottery.currentRound];
    }
    [timeCountDownView0 startTimeCountdown:self.lottery.currentRound];
    
}
#pragma mark-
- (void)checkIfNeedDan{
    if (self.cTransation.cBetArray.count < 10||_cTransation.ctzqPlayType == CTZQPlayTypeShiSi) {
        for (CTZQBet *bet in self.cTransation.cBetArray) {
            bet.cMatch.danTuo = @"0";
            NSLog(@"33029 [%@]",bet.cMatch.matchNum);
        }
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timeCountDownView0.updataTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameUserLogin object:nil];
}

-(void)issueTimeCountDown:(NSNotification *)notification{
    NSString *timeStr = notification.object;
    [_labTimeTitle setText:[NSString stringWithFormat:@"第%@期 剩余%@",_lottery.currentRound.issueNumber,timeStr]];
}

-(void)actionSub{
    
    beiCount =[self.peiSelectView.labContent.text integerValue];
    if ( beiCount>1) {
        beiCount --;
    }
    
    self.peiSelectView.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    self.cTransation.beitou = [NSString stringWithFormat:@"%ld",(long)beiCount];
    [self refreshTouzhuVCSummary];
}

-(void)actionAdd{
    beiCount =[self.peiSelectView.labContent.text integerValue];
    if ( beiCount < self.peiSelectView.beiShuLimit) {
        beiCount ++;
    }
    self.peiSelectView.labContent.text = [NSString stringWithFormat:@"%zd",beiCount];
    self.cTransation.beitou = [NSString stringWithFormat:@"%zd",beiCount];
    [self refreshTouzhuVCSummary];
}

-(void)update{
    beiCount =[self.peiSelectView.labContent.text integerValue]==0?1:[self.peiSelectView.labContent.text integerValue];

    self.cTransation.beitou = [NSString stringWithFormat:@"%zd",beiCount];
    [self refreshTouzhuVCSummary];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow:(NSNotification *)notify{
    NSDictionary *userInfo = [notify userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardheight = keyboardRect.size.height;
//    if(keyboard == NO){
        CGRect fram = [UIScreen mainScreen].bounds;
        fram.size.height -= keyboardheight;
        keyboardheight2 = keyboardheight;
        self.view.frame = fram;
        keyboard = YES;
//    }
}

-(void)keyboardWillHide:(NSNotification *)notify{

    if(keyboard == YES){
        CGRect fram = self.view.frame;
        
        //        fram.size.height += keyboardheight2;
        fram.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = fram;
        keyboard = NO;
    }
    
    if ([self.peiSelectView.labContent.text integerValue]<1) {
        self.peiSelectView.labContent.text = @"1";
        self.cTransation.beitou = [NSString stringWithFormat:@"%zd",beiCount];
        [self refreshTouzhuVCSummary];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)navigationBackToLastPage{
    [self.peiSelectView.labContent resignFirstResponder];
    if (_cTransation.cBetArray.count > 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"返回将清空所有选择，您确定返回么?"delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.tag = BACKTAG;
//        [alert show];
        
        ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:TitleHint message:@"返回将清空所有选择，您确定返回么?"];
        [alert addBtnTitle:TitleNotDo action:^{
            
        }];
        [alert addBtnTitle:TitleDo action:^{
            [self removeAllSelection];
            [super navigationBackToLastPage];
        }];
        [alert showAlertWithSender:self];
    }else{
        [super navigationBackToLastPage];
    }
}

- (IBAction)actionEdit:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionTouZhu:(UIButton *)sender {
    self.cTransation.schemeSource = SchemeSourceBet;

    if ([_lottery.currentRound isExpire]||_lottery.currentRound == nil) {
        [self showPromptText:TextLotteryRoundExpire hideAfterDelay:1.7];
        return;
    }
    if (self.cTransation.costType == CostTypeCASH) {
        if (_cTransation.betCost > 300000) {
            [self showPromptText:@"单次投注金额不得高于30万" hideAfterDelay:2.7];
            return;
        }
    }
    
    if (self.cTransation.betCount >10000) {
        [self showPromptText:@"单次投注注数不能超过1万注" hideAfterDelay:1.7];
        return;
    }
    
    if (self.curUser.isLogin) {
     
    } else {
        [self needLogin];
        return;
    }
    [self touZhu];

    
}


- (void) actionAfterLogin {
    //jump to this tab
//    [self jumpToTab: self.curTabType];
    [self actionTouZhu: nil];
}

- (void)touZhu{
    //奖期过期判断。
    
    [self showLoadingViewWithText:@"正在提交订单"];
    //当前用户登录判断
  
    [self.lotteryMan betLotteryScheme:self.cTransation];
}

-(void)betedLotteryScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    if (schemeNO == nil) {
        [self showPromptText:msg hideAfterDelay:1.9];
        return;
    }
    
    PayOrderViewController *payVC = [[PayOrderViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.lotteryName = self.lottery.activeProfile.title;
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.schemeNo = schemeNO;
    schemeCashModel.subCopies = 1;
    if (btnMoniTouzhu.selected == YES) {
        schemeCashModel.costType = CostTypeSCORE;
        if (self.cTransation.betCost  > 30000000) {
            [self showPromptText:@"单笔总积分不能超过3千万积分" hideAfterDelay:1.7];
            return;
        }
    }else{
        schemeCashModel.costType = CostTypeCASH;
        if (self.cTransation.betCost  > 300000) {
            [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
            return;
        }
    }
    
    [self hideLoadingView];
    
    schemeCashModel.subscribed = self.cTransation.betCost;
    schemeCashModel.realSubscribed = self.cTransation.betCost;
    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
}


- (NSString *)getTZNum{
    NSMutableArray *tzNumArr = [NSMutableArray arrayWithCapacity:14];
    
    for (CTZQMatch *match in _CTZQMatchArr) {
        NSUInteger index = [_CTZQMatchArr indexOfObject:match];
        NSMutableString *matchTouzhuStr = [[NSMutableString alloc] init];
        if ([_CTZQMatchSelectedArr containsObject: match]) {
            
            if ([match.danTuo isEqualToString:@"1"]) {
                [matchTouzhuStr appendString:@"#"];
            }
            if ([match.selectedS isEqualToString:@"1"]) {
                [matchTouzhuStr appendString:@"3"];
                
            }
            if ([match.selectedP isEqualToString:@"1"]) {
                [matchTouzhuStr appendString:@"1"];
                
            }
            if ([match.selectedF isEqualToString:@"1"]) {
                [matchTouzhuStr appendString:@"0"];
            }
            
            tzNumArr[index] = matchTouzhuStr;
        }else{
            tzNumArr[index] = @"*";
        }
        
    }
    
    NSMutableString *TZStr = [[NSMutableString alloc] init];
    for (NSString *str in tzNumArr) {
        if (!str||[str isEqualToString:@""]) {
            [TZStr appendFormat:@"*,"];
        }else{
            [TZStr appendFormat:@"%@,",str];
        }
        
    }
    TZStr = [NSMutableString stringWithFormat:@"%@",[TZStr substringToIndex:TZStr.length - 1]];
    return TZStr;
}


#pragma mark tableView 代理方法


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _cTransation.cBetArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cellTemp;
    
    if (_cTransation.ctzqPlayType == CTZQPlayTypeRenjiu) {
        CTZQTouzhuRenjiuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTZQTouzhuRenjiuCell"];
        if (cell== nil) {
            cell = [[CTZQTouzhuRenjiuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CTZQTouzhuRenjiuCell"];
        }
        cell.frame = CGRectMake(0, 0, KscreenWidth, 90);
        CTZQBet *bet = _cTransation .cBetArray[indexPath.row];
        cell.cBet = bet;
        [cell reloadData];
        cell.delegate = self;
        if (_cTransation.cBetArray.count==9) {
            cell.btnDan.selected = NO;
            cell.btnDan.enabled = NO;
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cellTemp = cell;
//        return cell;
    }else if (_cTransation.ctzqPlayType == CTZQPlayTypeShiSi){
        CTZQTouzhuShisiCell*cell = [tableView dequeueReusableCellWithIdentifier:@"CTZQTouzhuShisiCell"];
        if (cell== nil) {
            cell = [[CTZQTouzhuShisiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CTZQTouzhuShisiCell"];
        }
        cell.frame = CGRectMake(0, 0, KscreenWidth, 90);
        CTZQBet *bet = _cTransation .cBetArray[indexPath.row];
        cell.cBet = bet;
        [cell reloadData];
        cell.delegate = self;
        cellTemp = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
    }
    
    {
        UIView *selectedView = [[UIView alloc] initWithFrame:cellTemp.bounds];
        selectedView.backgroundColor = SEPCOLOR;
        
        CGRect frame = cellTemp.bounds;
        frame.origin.y = 0;
        frame.size.height -= 0;
        if (indexPath.row == 0) {
            frame.origin.y = SEPHEIGHT;
            frame.size.height -= SEPHEIGHT;
        }
        UIView *selectedViewGray = [[UIView alloc] initWithFrame:frame];
        selectedViewGray.backgroundColor = CellSelectedColor;
        [selectedView addSubview:selectedViewGray];
        
        
        cellTemp.selectedBackgroundView = selectedView;
        //        cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view;
        
        if ([cellTemp subviews].count>1) {
            view = [cellTemp subviews][1];
        }
        
        CGRect downLineFrame = view.frame;
        [view removeFromSuperview];
        
        for (UIView *view in [cellTemp subviews]) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
        
        if ([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            downLineFrame.origin.y = [self tableView:tableView heightForRowAtIndexPath:indexPath] - SEPHEIGHT;
        }else{
            downLineFrame.origin.y = 90 - SEPHEIGHT;
        }
        
        downLineFrame.origin.x = SEPLEADING;
        downLineFrame.size.width = tableView.frame.size.width - 2*SEPLEADING;
        downLineFrame.size.height = SEPHEIGHT;
        UILabel *downLine = [[UILabel alloc] init];
        downLine.backgroundColor = SEPCOLOR;
        NSInteger lineCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == lineCount - 1) {
            downLineFrame.origin.x = 0;
            downLineFrame.size.width = tableView.frame.size.width;
            //            downLineFrame.origin.y -= 1;
            //            downLine.frame =
        }//else{
        //downLine.frame = downLineFrame;
        //        }
        downLine.frame = downLineFrame;
        [cellTemp addSubview:downLine];
        
        if (indexPath.row == 0) {
            UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, SEPHEIGHT)];
            upLine.backgroundColor = SEPCOLOR;
            [cellTemp addSubview:upLine];
            
        }
        
        
    }
    return cellTemp;

}

#pragma mark renjiucell 代理刷新方法
/**
 *  刷新底部lable
 */
-(void)refreshTouzhuVCSummary{

    NSMutableArray *seleceMacthArray = [[NSMutableArray alloc]init];
    NSMutableArray *selectDanArray = [[NSMutableArray alloc]init];
    
    for (CTZQBet*itemBet  in self.cTransation.cBetArray) {
        
        NSMutableArray *betSelectArray = [[NSMutableArray alloc]init];
        if ([itemBet.cMatch.selectedS isEqualToString:@"1"]) {
            [betSelectArray addObject:@"1"];
        }
        if ([itemBet.cMatch.selectedP isEqualToString:@"1"]) {
            [betSelectArray addObject:@"1"];
        }
        if ([itemBet .cMatch.selectedF isEqualToString:@"1"]) {
            [betSelectArray addObject:@"1"];
        }
        
        if (betSelectArray.count !=0) {
            [seleceMacthArray addObject:betSelectArray];
        }
            if ([itemBet .cMatch.danTuo isEqualToString:@"1"]) {
                [selectDanArray addObject:betSelectArray];
            }
        
    }
    NSInteger zhuCount = [CalcuCount calculateCount:seleceMacthArray playType:self.cTransation.ctzqPlayType andDanNumber:selectDanArray];
    NSString*summaryStr;
    if (btnMoniTouzhu.selected == YES) {
    
         _cTransation.betCost = zhuCount*2*beiCount;
        _cTransation.betCount = zhuCount;
        summaryStr = [NSString stringWithFormat:@"已投%zd注 %zd倍 \n共%zd积分",zhuCount,beiCount,_cTransation.betCost * 100];
    }else{
       _cTransation.betCost = zhuCount*2*beiCount;
        _cTransation.betCount = zhuCount;
        summaryStr = [NSString stringWithFormat:@"已投%zd注 %zd倍 \n共%zd元",zhuCount,beiCount,_cTransation.betCost];
    }
    
 
    
    NSRange rang1 = [summaryStr rangeOfString:@"注"];
    NSRange rang2 = [summaryStr rangeOfString:@"倍"];
    NSRange rang3 = [summaryStr rangeOfString:@"共"];
    NSMutableAttributedString*summaryAttStr = [[NSMutableAttributedString alloc]initWithString:summaryStr];
    
    [summaryAttStr addAttributes:@{NSForegroundColorAttributeName:SystemGreen} range:NSMakeRange(2, rang1.location-2)];
    [summaryAttStr addAttributes:@{NSForegroundColorAttributeName:SystemGreen} range:NSMakeRange(rang1.location+1, rang2.location-rang1.location-1)];
    [summaryAttStr addAttributes:@{NSForegroundColorAttributeName:SystemGreen} range:NSMakeRange(rang3.location+1, summaryStr.length- rang3.location-2)];
    self.labSummary.attributedText = summaryAttStr;
    if (_cTransation.betCost > 300000) {
        [self showPromptText:@"单次投注金额不得高于30万" hideAfterDelay:2.7];
    }
}

-(NSInteger)getDanCount{
     NSMutableArray *selectDanArray = [[NSMutableArray alloc]init];
    for (CTZQBet*itemBet  in self.cTransation.cBetArray) {
        if ([itemBet .cMatch.danTuo isEqualToString:@"1"]) {
                [selectDanArray addObject:@"1"];
        }
        
    }
    return selectDanArray.count;

}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == BACKTAG) {
        if (buttonIndex == 1) {
            [self removeAllSelection];
            [super navigationBackToLastPage];
        }
    }
    
    if (alertView.tag == 1100) {
        if (buttonIndex == 1) {
            //登录成功后跳回
            if (self.curUser.isLogin) {
                [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(actionAfterLogin) name: NotificationNameUserLogin object: nil];
            }
            
        }
    }
}

-(void)removeAllSelection{
    self.cTransation.beitou = @"1";
    self.cTransation.isBackClean = @"1";
    [self.cTransation.cBetArray removeAllObjects];

}

-(void)showInfo{

    [self showPromptText:@"设胆场数不能超过8场" hideAfterDelay:1.7];

}

-(void)initediateScheme:(NSString *)schemeNO{

    [self hideLoadingView];
    
}

- (IBAction)actionHemai:(UIButton *)sender {
    [GlobalInstance instance].isFromTogeVCToThis = NO;
    if (self.cTransation.betCost <10) {
        [self showPromptText:@"发起合买最低10元" hideAfterDelay:1.7];
        return;
    }
    if (self.cTransation.betCost >300000) {
        [self showPromptText:@"发起合买最高不超过30万元" hideAfterDelay:1.7];
        return;
    }
    
    if (self.cTransation.betCount >10000) {
        [self showPromptText:@"发起合买注数不能超过1万注" hideAfterDelay:1.7];
        return;
    }

}

- (void)timeCountDownView:(LotteryTimeCountdownView *)timeView didFinishTimeStr:(NSString *)timeStr{
    //    NSLog(@"%@",timeStr);
    //    NSLog(@"%@",@([_lottery.currentRound isExpire]);
    if ([timeStr isEqualToString:@"该期已停止销售"]) {
        if (timeView == timeCountDownView0) {
            [self setIssueBtnsWithInfo:timeStr :0];
        }
    }else{
        
        
        NSMutableString *curTime = [[NSMutableString alloc]initWithString:timeStr];
        
        [curTime replaceCharactersInRange:[curTime rangeOfString:@"时"] withString:@":"];
        [curTime replaceCharactersInRange:[curTime rangeOfString:@"分"] withString:@":"];
        
        [curTime replaceCharactersInRange:[curTime rangeOfString:@"秒"] withString:@""];
        
        if (timeView == timeCountDownView0) {
            [self setIssueBtnsWithInfo:curTime :0];
            
        }
        if (timeView == timeCountDownView0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IssueTimeCountDown" object:timeStr];
            
        }
    }
    
}


- (void)setIssueBtnsWithInfo:(id)info :(NSInteger)index{
    
    //    NSInteger curentIssue = [_lottery.currentRound.issueNumber integerValue];
    NSString *curentTimeStr = @"预售";
  
    LotteryRound *roundTemp =  self.lottery.currentRound;
    if (roundTemp.abortDay == 0 && roundTemp.abortHour == 0 && roundTemp.abortMinute == 0 && roundTemp.abortSecond == 0){
        curentTimeStr = (NSString *)info;
    }else if ([roundTemp.sellStatus integerValue]  == 1) {
        curentTimeStr = [NSString stringWithFormat:@"剩余%@",info];
    }
}

- (IBAction)actionZhenshiTouzhu:(UIButton *)sender {
    [self setBtnState:sender];
}

-(void)setBtnState:(UIButton *)sender{
    btnMoniTouzhu.selected = NO;
    btnZhenShiTouzhu.selected = NO;
    sender.selected = YES;
    if (btnMoniTouzhu.selected == YES) {
        self.cTransation.costType = CostTypeSCORE;
    }else{
        self.cTransation.costType = CostTypeCASH;
    }
    [self refreshTouzhuVCSummary];
}

@end
