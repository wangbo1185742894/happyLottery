
//
//  JCLQTouZhuController.m
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQTouZhuController.h"
#import "SchemeCashPayment.h"
#import "PayOrderViewController.h"
#import "WBButton.h"
#import "SelectView.h"

#import "WBSelectView.h"
#import "UIView+MJExtension.h"
#import "TouZhuViewCell.h"
#import "LotteryManager.h"
#import "TZSelectMatchCell.h"

#define KTZSelectMatchCell @"TZSelectMatchCell"


@interface JCLQTouZhuController ()<WBSelectViewDelegate,UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,SelectViewDelegate,JingCaiChaunFaSelectViewDelegate>


{
    float keyboardheight;
    float keyboardheight2;
    NSInteger beiCount;
    NSInteger totalUnit;
    BOOL keyboard;
    __weak IBOutlet UIButton *btnZigou;
    __weak IBOutlet UIButton *btnMoniTouzhu;
    __weak IBOutlet UIButton *btnZhenShiTouzhu;
    
    UIButton *chuanfaBt;
    SelectView *peiSelectView;
    LotteryManager *lotteryMan;
    AppDelegate *appDelegate;
    __weak IBOutlet UIButton *btnTuijian;

    __weak IBOutlet UIButton *btnHemai;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableSelectMatch;
@property (weak, nonatomic) IBOutlet UIView *selectPeiChuanView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTuiJianWidth;

@property(strong,nonatomic) WBSelectView *selectView;

@property (assign,nonatomic)JCLQGuanType lastPlayType;


@property (weak, nonatomic) IBOutlet UIButton *btnTuijian;

- (IBAction)actionTuijian:(UIButton *)sender;


@end

@implementation JCLQTouZhuController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.labNumBetCount.adjustsFontSizeToFitWidth = YES;
    self.labMaxJiangjie.adjustsFontSizeToFitWidth = YES;
    [self.view layoutIfNeeded];
    [self setChuanfa];
    self.title = @"确认预约";
    if (nil == appDelegate) {
        appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    }
    self.curUser = [[GlobalInstance instance] curUser];

    
    self.lotteryMan.delegate = self;
    
    CGRect changCiFram = CGRectMake(20, 55, 110, 25);
    
    chuanfaBt = [self myButton:changCiFram title:@"" select:@selector(changCiChoose) imgage:@"" selectedImgName:@"" ];
    chuanfaBt.backgroundColor = [UIColor whiteColor];
    [chuanfaBt setTitleColor:TEXTGRAYOrange forState:0];
    chuanfaBt.titleLabel.font = [UIFont systemFontOfSize:14];
    chuanfaBt.titleLabel.textAlignment = NSTextAlignmentCenter;
    chuanfaBt .layer.borderColor = COLORGRAYBUTTON.CGColor;
    chuanfaBt.layer.borderWidth = SEPHEIGHT;
    [chuanfaBt setTitle:self.transaction.chuanFa forState:0];
    peiSelectView= [[SelectView alloc]initWithFrame:CGRectMake(self.view.mj_w -175, 55, 160, 25) andRightTitle:@"投" andLeftTitle:@"倍"];
    peiSelectView.beiShuLimit = 9999;
    if ([self.transaction.beitou isEqualToString:@""] || self.transaction.beitou == nil) {
        peiSelectView.labContent.text = @"5";
        self.transaction.beitou = @"5";
    }else{
        peiSelectView.labContent.text = self.transaction.beitou;
    }
    
    
    [peiSelectView setTarget:self rightAction:@selector(actionAdd) leftAction:@selector(actionSub)];
    
    [self.selectPeiChuanView addSubview:peiSelectView];
    
    peiSelectView.delegate = self;
//    lala
    self.tableSelectMatch.dataSource =self;
    self.tableSelectMatch.delegate = self;
    [self.tableSelectMatch registerClass:[TZSelectMatchCell class] forCellReuseIdentifier:KTZSelectMatchCell];

    [self.tableSelectMatch reloadData];
    
//    self.tableSelectMatch.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableSelectMatch registerClass:[TouZhuViewCell class] forCellReuseIdentifier:@"TouZhuViewCell"];
    self.lastPlayType = self.transaction.guanType;
  

    
    [self.transaction getBetCount];
    
    self.labNumBetCount.text = [NSString stringWithFormat:@"%@ %zd注 %@倍 共%zd元"  ,self.transaction.chuanFa,self.transaction.betCount,self.transaction.beitou,self.transaction.betCost];

    
    self.labMaxJiangjie.text = [NSString stringWithFormat:@"最大可中奖%.2f元(以实际中奖为准)",self.transaction.maxCount*[self.transaction.beitou floatValue]];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(acitonDeleteMatch:) name:@"NSNotificationDeleteMatchForTouzhu" object:nil];
    
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

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationDeleteMatch" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KTZSelectMatchCell object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationDeleteMatchForTouzhu" object:nil];
}
-(void)acitonDeleteMatch:(NSNotification *) notification{
    
    if (self.transaction.guanType == JCLQGuanTypeGuoGuan) {
        if (self.transaction.matchSelectArray.count <=2) {
            
            if (self.transaction.matchSelectArray.count == 1) {
                [self showPromptText:@"至少保留一场比赛" hideAfterDelay:1.7];
                return;
                
            }else{
            
                [self showPromptText:@"过关模式下至少保留两场比赛" hideAfterDelay:1.7];
                return;
            }
           
        }
    }
    
    if (self.transaction.guanType == JCLQGuanTypeDanGuan) {
        if (self.transaction.matchSelectArray.count <=1) {
            [self showPromptText:@"单关模式下至少保留一场比赛" hideAfterDelay:1.7];
            return;
        }
    }
    
    JCLQMatchModel *match = [notification object];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationDeleteMatchForPlay" object:match];
    if ([self.transaction.matchSelectArray containsObject: match]) {
        [self.transaction.matchSelectArray removeObject:match];
    }
    
    [self.tableSelectMatch reloadData];
    
    
    [self.transaction.selectItems removeAllObjects];
    [self setChuanfa];
    [chuanfaBt setTitle:self.transaction.chuanFa forState:0];
    if (![self.transaction.selectItems containsObject:self.transaction.chuanFa]) {
        
        [self.transaction .selectItems addObject:self.transaction.chuanFa];
    }
    
    [self.transaction getBetCount];
    
    [self update];

    
}
//tableview代理方法
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TZSelectMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:KTZSelectMatchCell];
    JCLQMatchModel *model = self.transaction.matchSelectArray[indexPath.row];
    [cell loadDataJCLQ:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    TZSelectMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:KTZSelectMatchCell];
    if (self.transaction.matchSelectArray.count >0) {
        JCLQMatchModel *model = self.transaction.matchSelectArray[0];
        [cell loadDataJCLQ:model];
    }
    
    return self.transaction.matchSelectArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.transaction.matchSelectArray [indexPath.row] getHeight] + 53;
}

- (UIButton *)myButton:(CGRect)fram title:(NSString *)title select:(SEL)select imgage:(NSString *)imgName selectedImgName:(NSString *)selectImgName {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = fram;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    button.imageView.hidden = NO;
    [button addTarget:self action:select forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:selectImgName] forState:UIControlStateSelected];
    [button setTitleColor:TEXTGRAYCOLOR forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [self.selectPeiChuanView addSubview:button];
    return button;
}

-(void)changCiChoose{
    
    
    JingCaiChaunFaSelectView *jingcaiSelect = [[JingCaiChaunFaSelectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    if (_transaction.selectItems ==nil) {
        _transaction.selectItems = [NSMutableArray arrayWithCapacity:0];
        [_transaction.selectItems addObject:_transaction.chuanFa];
    }
    
    jingcaiSelect.selectedItems = _transaction.selectItems;
    jingcaiSelect.jclqtransation = _transaction;
    jingcaiSelect.delegate = self;
    [jingcaiSelect showFromSuperViewJCLQ:self.navigationController.view];
   
}

-(void)selectChuanFa:(NSArray *)chuanFaArray{
    if (_transaction.selectItems .count >1) {
        [chuanfaBt setTitle:[NSString stringWithFormat:@"已选%lu项",(unsigned long)_transaction.selectItems.count] forState:UIControlStateNormal];
    }else  if(_transaction.selectItems .count == 1){
        [chuanfaBt setTitle:[_transaction.selectItems firstObject] forState:UIControlStateNormal];
    }else if(_transaction.selectItems .count == 0 ){
        [chuanfaBt setTitle:@"暂无选项" forState:UIControlStateNormal];
    }
    [self updataBetCount:nil];
}

//selectView代理方法
-(void)didSelect:(NSIndexPath*)indexPath{
   

    
//     NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JingCaiChuanTypeDic" ofType:@"plist"]];
//    NSInteger index = [[[selectTitle componentsSeparatedByString:@"串"]firstObject] integerValue];
//    if (index == 0) {
//        index = 1;
//    }
//    NSDictionary *selectDic = array[index-1];
//    NSDictionary *baseDic = selectDic[selectTitle];
//    NSString *baseNum = baseDic[@"baseNum"];
//
//    self.transaction.chuanFa = selectTitle;
//    [self.transaction getBetCount];
//    
//    [self updataBetCount:selectTitle];
    
}

-(void)updataBetCount:(NSString *)type{

    float betCount = 0;
    float betCost = 0;
    float maxCount = 0;
    for (NSString *chuanfa in _transaction.selectItems) {
        _transaction.chuanFa = chuanfa;
        [self.transaction getBetCount];
        betCount +=_transaction.betCount;
        betCost +=_transaction.betCost;
        maxCount +=_transaction.maxCount;
        _transaction.betCount = 0;
        _transaction.betCost = 0;
        _transaction.maxCount = 0;
    }
    _transaction.betCount = betCount;
    _transaction.betCost = betCost;
    _transaction.maxCount = maxCount;
    
    if (btnMoniTouzhu.selected == YES) {
        self.labNumBetCount.text = [NSString stringWithFormat:@"%zd注 %@倍 共%zd积分",self.transaction.betCount,self.transaction.beitou,self.transaction.betCost * 100];
        
        self.labMaxJiangjie.text = [NSString stringWithFormat:@"最大可中奖%.0f积分(以实际中奖为准)",self.transaction.maxCount*[self.transaction.beitou floatValue] * 100];
    }else{
        self.labNumBetCount.text = [NSString stringWithFormat:@"%zd注 %@倍 共%zd元",self.transaction.betCount,self.transaction.beitou,self.transaction.betCost];
        
        self.labMaxJiangjie.text = [NSString stringWithFormat:@"最大可中奖%.2f元(以实际中奖为准)",self.transaction.maxCount*[self.transaction.beitou floatValue]];
    }
    

}

-(void)actionSub{
    
    beiCount =[peiSelectView.labContent.text integerValue];
    if ( beiCount>1) {
        beiCount --;
    }
    
    peiSelectView.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    self.transaction.beitou = [NSString stringWithFormat:@"%ld",(long)beiCount];
    [self updataBetCount:chuanfaBt.currentTitle];
}

-(void)actionAdd{
    beiCount =[peiSelectView.labContent.text integerValue];
    if ( beiCount < peiSelectView.beiShuLimit) {
        beiCount ++;
    }
    peiSelectView.labContent.text = [NSString stringWithFormat:@"%zd",beiCount];
    self.transaction.beitou = [NSString stringWithFormat:@"%zd",beiCount];
    [self updataBetCount:chuanfaBt.currentTitle];
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
    
//    if ([self.peiSelectView.labContent.text integerValue]<1) {
//        self.peiSelectView.labContent.text = @"1";
//        self.cTransation.beitou = [NSString stringWithFormat:@"%zd",beiCount];
//        [self refreshTouzhuVCSummary];
//    }
}


-(void)update{
    
    beiCount =[peiSelectView.labContent.text integerValue]==0?1:[peiSelectView.labContent.text integerValue];
    
    self.transaction.beitou = [NSString stringWithFormat:@"%zd",beiCount];
    [self updataBetCount:self.transaction.chuanFa];
    
}
- (IBAction)actionCleanAllSelect:(UIButton *)sender {
    
    [self.transaction.matchSelectArray removeAllObjects];
    self.transaction.selectItems = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationDeleteAll" object:nil];
    
    [self.tableSelectMatch reloadData];
    [self performSelector:@selector(navigationBack) withObject:nil afterDelay:0.3];
    
}

-(void)navigationBack{
[self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)actionTouzhu:(UIButton *)sender {
    
    
    
    if (self.curUser == nil || self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    
    if (self.transaction.selectItems .count == 0) {
        [self showPromptText:@"请选择过关方式" hideAfterDelay:1.7];
        return;
    }
    
    NSString *errorMsg = [self couldTouzhu];
    if (errorMsg) {
        [self showPromptText:errorMsg hideAfterDelay:2.0];
        return;
    }
    
    if (btnMoniTouzhu.selected == YES) {
    }else{
        if (self.transaction.betCost  > 300000) {
            [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
            return;
        }
    }
    
    [self showLoadingText:@"正在提交订单"];
    
    self.transaction.maxPrize = 1.00;
    self.transaction.schemeType = SchemeTypeZigou;
    self.transaction.units = self.transaction.betCount;
    if (btnZhenShiTouzhu.selected == YES) {
        self.transaction.costType = CostTypeCASH;
    }else{
        self.transaction.costType = CostTypeSCORE;
    }
    
    self.transaction.secretType = SecretTypeFullOpen;
    self.transaction.betCost = self.transaction.betCount * 2 * [self.transaction.beitou integerValue];
    
    [self.lotteryMan betLotteryScheme:self.transaction];
}
- (void) betedLotteryScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (schemeNO == nil || schemeNO.length == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    PayOrderViewController *payVC = [[PayOrderViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.lotteryName = @"竞彩篮球";
    schemeCashModel.schemeNo = schemeNO;
    schemeCashModel.subCopies = 1;
    if (btnMoniTouzhu.selected == YES) {
        schemeCashModel.costType = CostTypeSCORE;
        if (self.transaction.betCost  > 30000000) {
            [self showPromptText:@"单笔总积分不能超过3千万积分" hideAfterDelay:1.7];
            return;
        }
    }else{
        schemeCashModel.costType = CostTypeCASH;
        if (self.transaction.betCost  > 300000) {
            [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
            return;
        }
    }
    
    [self hideLoadingView];
    
    schemeCashModel.subscribed = self.transaction.betCost;
    schemeCashModel.realSubscribed = self.transaction.betCost;
    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
}

-(NSString *)couldTouzhu{
    if (self.transaction.guanType == JCLQGuanTypeDanGuan) {
        if (self.transaction.matchSelectArray.count < 1) {
            return  @"单关模式下，至少保留一场比赛";
        }
    }
    if (self.transaction.guanType == JCLQGuanTypeGuoGuan) {
        if (self.transaction.matchSelectArray.count < 2 ) {
            if(self.transaction.matchSelectArray.count ==1){
                JCZQMatchModel *model = [self.transaction.matchSelectArray firstObject];
                if (model.isDanGuan == YES) {
                    self.transaction.chuanFa = @"单场";
                    return nil;
                }
                return  @"过关模式下，至少保留两场比赛";
                
            }else{
                return  @"过关模式下，至少保留两场比赛";
                
            }
            
        }
    }
    return nil;
}
- (IBAction)actionGoOnSelect:(UIButton *)sender {
    [self .navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
}
- (BOOL)isExceedLimitAmount{
    if(_transaction.betCost > 300000){
        return YES;
    }else{
        return NO;
    }
    
}
- (NSString *)couldTouZhu{
    return nil;
}


- (void) actionAfterLogin {
    //jump to this tab
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameUserLogin object:nil];
    [self actionTouzhu:nil];
}
- (void) timeEnough
{
    NSLog(@"ok了");
    UIButton *btn=(UIButton*)[self.view viewWithTag:33];
    btn.selected=NO;
}

- (void)navigationBackToLastPage{
    [GlobalInstance instance].isFromTogeVCToThis = NO;
    [peiSelectView.labContent resignFirstResponder];
    if (_transaction.matchSelectArray.count > 0) {
        
        ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:TitleHint message:@"返回将清空所有选择，您确定返回么?"];
        [alert addBtnTitle:TitleNotDo action:^{
        }];
        
        [alert addBtnTitle:TitleDo action:^{
            [self.transaction.matchSelectArray removeAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationDeleteAll" object:nil];
            [super navigationBackToLastPage];
        }];
        [alert showAlertWithSender:self];
    }else{
        [super navigationBackToLastPage];
    }
     
}

-(NSInteger)sumSelectPlayType:(NSArray*)array{
    NSInteger num = 0;
    for (NSString *str  in array) {
        num = num+ [str integerValue];
    }
    return num;
}

- (IBAction)actionMoniTouzhu:(UIButton *)sender {
    
    [self setBtnState:sender];
}
- (IBAction)actionZhenshiTouzhu:(UIButton *)sender {
    [self setBtnState:sender];
}

-(void)setBtnState:(UIButton *)sender{
    btnMoniTouzhu.selected = NO;
    btnZhenShiTouzhu.selected = NO;
    sender.selected = YES;
    [self update];
}
-(void)setChuanfa{
    
    if (self.transaction.guanType == JCLQGuanTypeGuoGuan) {
        
        int chuanfakey;
        if ([self.transaction.curProfile.Desc isEqualToString:@"JCLQSFC"]) {
            if (self.transaction.matchSelectArray.count == 1) {
                self.transaction.chuanFa = @"单场";
            }else{
                self.transaction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transaction.matchSelectArray.count>4?4:self.transaction.matchSelectArray.count];
            }
            chuanfakey = 4;
        }else if([self.transaction.curProfile.Desc isEqualToString:@"JCLQHHGG"]){
            
            NSInteger num4 = 0;
            for (JCLQMatchModel * model in self.transaction.matchSelectArray) {
                
                num4 = [model sumSelectPlayType:model.SFCSelectMatch];
                
                if (num4!= 0 ) {
                    chuanfakey = 4;
                    break;
                }
            
            }
            
            if(num4 != 0){
                self.transaction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transaction.matchSelectArray.count>4?4:self.transaction.matchSelectArray.count];
            }else{
                self.transaction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transaction.matchSelectArray.count>8?8:self.transaction.matchSelectArray.count];
                chuanfakey = 8;
            }
            
            
            
        }else{
            
            self.transaction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transaction.matchSelectArray.count>8?8:self.transaction.matchSelectArray.count];
            chuanfakey = 8;
        }
        self.transaction.maxChuanNumber =chuanfakey;
        
        
        if (self.transaction.selectItems ==nil) {
            self.transaction.selectItems = [NSMutableArray arrayWithCapacity:0];
            
        }else{
            [self.transaction.selectItems removeAllObjects];
        }
        
        if (![self.transaction.selectItems containsObject:self.transaction.chuanFa]) {
            [self.transaction.selectItems addObject:self.transaction.chuanFa];
        }
        
        if (self.transaction.selectItems.count ==1) {
            [chuanfaBt setTitle:self.transaction.chuanFa forState:UIControlStateNormal];
        }else if(self.transaction.selectItems.count >1){
            [chuanfaBt setTitle:[NSString stringWithFormat:@"已选%ld项",self.transaction.selectItems.count] forState:0];
        }else if(self.transaction.selectItems.count == 0){
            [chuanfaBt setTitle:@"暂无选项" forState:0];
        }
    }else{
        [chuanfaBt setTitle:@"单场" forState:UIControlStateNormal];
        self.transaction.chuanFa = @"单场";
        if (self.transaction.selectItems ==nil) {
            self.transaction.selectItems = [NSMutableArray arrayWithCapacity:0];
            
        }else{
            [self.transaction.selectItems removeAllObjects];
        }
        [self.transaction.selectItems addObject:_transaction.chuanFa];
    }
}

@end
