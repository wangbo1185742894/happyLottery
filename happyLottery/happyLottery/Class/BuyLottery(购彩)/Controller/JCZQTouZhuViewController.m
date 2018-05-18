//
//  JCZQTouZhuViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "JCZQTouZhuViewController.h"
#import "JingCaiChaunFaSelectView.h"
#import "TZSelectMatchCell.h"
#import "SelectView.h"
#import "PayOrderViewController.h"

#define KTZSelectMatchCell @"TZSelectMatchCell"


@interface JCZQTouZhuViewController ()<UITableViewDelegate,UITableViewDataSource,JingCaiChaunFaSelectViewDelegate,LotteryManagerDelegate,SelectViewDelegate>
{
    SelectView * peiSelectView;
    NSInteger beiCount;
    NSInteger totalUnit;
    JingCaiChaunFaSelectView *jingcaiSelect;
    __weak IBOutlet UIButton *btnMoniTouzhu;
    __weak IBOutlet UIButton *fadanBtn;
    __weak IBOutlet UIButton *btnZhenShiTouzhu;
    __weak IBOutlet UIButton *chuanfaBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tabSelectedMatch;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UILabel *labZhuInfo;
@property (weak, nonatomic) IBOutlet UILabel *labPrizeInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisBottom;
@property (weak, nonatomic) IBOutlet UIButton *touzhuBtn;

@end

@implementation JCZQTouZhuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isIphoneX]) {
        self.viewDisTop.constant = 88;
        self.viewDisBottom .constant = 34;
    }else{
        self.viewDisTop.constant = 64;
        self.viewDisBottom.constant = 0;
    }
    self.title = @"确认预约";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanMatch:) name:KSELECTMATCHCLEAN object:nil];
    self.lotteryMan.delegate = self;
    [self.transction.selectItems removeAllObjects];
    [self setTableView];
    [self setWBSelectView];
    [self setChuanfa];
    [self updataTouzhuInfo];
    self.touzhuBtn.layer.cornerRadius = 5;
}

-(void)cleanMatch:(NSNotification*)notification{
        if (self.transction.playType == JCZQPlayTypeGuoGuan) {
            BOOL isDanGuan = YES;
            for (JCZQMatchModel *model in self.transction.selectMatchArray) {
                if (model.isDanGuan ==NO) {
                    isDanGuan = NO;
                    break;
                }
            }
            if (isDanGuan == YES) {
                if (self.transction.selectMatchArray.count <= 1) {
                    
                      [self showPromptText:@"单关模式下至少保留一场比赛" hideAfterDelay:1.7];
                    return;
                }
            }else{
                if (self.transction.selectMatchArray.count <= 2) {
                    
                    [self showPromptText:@"过关模式下至少保留两场比赛" hideAfterDelay:1.7];
                    return;
                }
            }
        }else{
            if (self.transction.selectMatchArray.count <= 1) {
                [self showPromptText:@"单关模式下至少保留一场比赛" hideAfterDelay:1.7];
                return;
            }
        }
    JCZQMatchModel *model = (JCZQMatchModel*)notification.object;
    [self.transction.selectItems removeAllObjects];
    totalUnit = 0;
    [self.transction.selectMatchArray removeObject:model];
    [self setChuanfa];
    [model cleanAll];
    [self updataTouzhuInfo];
    [self.tabSelectedMatch reloadData];
}

-(void)setChuanfa{
    
    if (self.transction.playType == JCZQPlayTypeGuoGuan) {
      
            int chuanfakey;
            if ([self.transction.curProfile.Desc isEqualToString:@"BQC"] || [self.transction.curProfile.Desc isEqualToString:@"BF"]) {
                if (self.transction.selectMatchArray.count == 1) {
                    self.transction.chuanFa = @"单场";
                }else{
                    self.transction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transction.selectMatchArray.count>4?4:self.transction.selectMatchArray.count];
                }
                chuanfakey = 4;
            }else if ([self.transction.curProfile.Desc isEqualToString:@"JQS"]) {
                if (self.transction.selectMatchArray.count == 1) {
                    self.transction.chuanFa = @"单场";
                }else{
                    
                self.transction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transction.selectMatchArray.count>6?6:self.transction.selectMatchArray.count];
                }
                chuanfakey = 6;
            }else if([self.transction.curProfile.Desc isEqualToString:@"HHGG"]){
                
                NSInteger num4 = 0;
                NSInteger num6 = 0;
                for (JCZQMatchModel * model in self.transction.selectMatchArray) {
                    
                    num4 = [model getSinglePlayTypeNum:model.BF_SelectMatch];
                    
                    if (num4!= 0 ) {
                        chuanfakey = 4;
                        break;
                    }
                    num4 = [model getSinglePlayTypeNum:model.BQC_SelectMatch];
                    
                    if (num4!= 0 ) {
                        chuanfakey = 4;
                        break;
                    }
                    num6 = [model getSinglePlayTypeNum:model.JQS_SelectMatch];
                    
                    if (num6!= 0 ) {
                        chuanfakey = 6;
                        break;
                    }
                }
                
                
                if (num6 != 0) {
                      self.transction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transction.selectMatchArray.count>6?6 :self.transction.selectMatchArray.count];
              
                    
                }else if(num4 != 0){
                     self.transction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transction.selectMatchArray.count>4?4:self.transction.selectMatchArray.count];
                }else{
                    self.transction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transction.selectMatchArray.count>8?8:self.transction.selectMatchArray.count];
                    chuanfakey = 8;
                }
                
                
                
            }else{
                
                self.transction.chuanFa = [NSString stringWithFormat:@"%ld串1",self.transction.selectMatchArray.count>8?8:self.transction.selectMatchArray.count];
                chuanfakey = 8;
            }
            self.transction.maxChuanNumber =chuanfakey;
        
        
        if (self.transction.selectItems ==nil) {
            self.transction.selectItems = [NSMutableArray arrayWithCapacity:0];
          
        }
        if (![self.transction.selectItems containsObject:self.transction.chuanFa]) {
            [self.transction.selectItems addObject:self.transction.chuanFa];
        }
        
        if (self.transction.selectItems.count ==1) {
            [chuanfaBtn setTitle:self.transction.chuanFa forState:UIControlStateNormal];
        }else if(self.transction.selectItems.count >1){
            [chuanfaBtn setTitle:[NSString stringWithFormat:@"已选%ld项",self.transction.selectItems.count] forState:0];
        }else if(self.transction.selectItems.count == 0){
            [chuanfaBtn setTitle:@"暂无选项" forState:0];
        }
    }else{
        [chuanfaBtn setTitle:@"单场" forState:UIControlStateNormal];
        self.transction.chuanFa = @"单场";
        if (_transction.selectItems ==nil) {
            _transction.selectItems = [NSMutableArray arrayWithCapacity:0];
            
        }else{
            [_transction.selectItems removeAllObjects];
        }
        [_transction.selectItems addObject:_transction.chuanFa];
    }
}

-(void)setWBSelectView{
    if (peiSelectView  == nil) {
         peiSelectView= [[SelectView alloc]initWithFrame:CGRectMake(KscreenWidth -180, 56, 162, 32) andRightTitle:@"投" andLeftTitle:@"倍"];
    }
    _viewBottom.mj_w = KscreenWidth;
    peiSelectView.delegate = self;
    [_viewBottom addSubview:peiSelectView];
    peiSelectView.beiShuLimit = 9999;
    if ([self.transction.beitou isEqualToString:@""] || self.transction.beitou == nil) {
        peiSelectView.labContent.text = @"5";
        self.transction.beitou = @"5";
    }else{
        peiSelectView.labContent.text = self.transction.beitou;
    }
    [peiSelectView setTarget:self rightAction:@selector(actionAdd) leftAction:@selector(actionSub)];
    
}

-(void)actionSub{
    
    beiCount =[peiSelectView.labContent.text integerValue];
    if ( beiCount>1) {
        beiCount --;
    }
    
    peiSelectView.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    
    self.transction.beitou = [NSString stringWithFormat:@"%ld",(long)beiCount<=0?1:beiCount];
    [self updataTouzhuInfo];
}

-(void)actionAdd{
    beiCount =[peiSelectView.labContent.text integerValue];
    if ( beiCount < peiSelectView.beiShuLimit) {
        beiCount ++;
    }
    peiSelectView.labContent.text = [NSString stringWithFormat:@"%zd",beiCount];
    self.transction.beitou = [NSString stringWithFormat:@"%zd",beiCount];
    [self updataTouzhuInfo];
}

-(void)setTableView{
    self.tabSelectedMatch.delegate = self;
    self.tabSelectedMatch.dataSource = self;
    [self.tabSelectedMatch registerClass:[TZSelectMatchCell class] forCellReuseIdentifier:KTZSelectMatchCell];
    [self.tabSelectedMatch reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.transction.selectMatchArray[indexPath.row] getHeight] + 53;
}

- (IBAction)actionGoonSelect:(UIButton *)sender {
    [super navigationBackToLastPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    [self updataTouzhuInfo];
}



- (IBAction)actionSelectChuanFa:(UIButton *)sender {
    
        
    jingcaiSelect = [[JingCaiChaunFaSelectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self.transction.selectItems ==nil) {
        self.transction.selectItems = [NSMutableArray arrayWithCapacity:0];
        
    }
//    [self.transction.selectItems addObject:_transction.chuanFa];
    jingcaiSelect.selectedItems = self.transction.selectItems;
    jingcaiSelect.transation = self.transction;
    jingcaiSelect.delegate = self;
    [jingcaiSelect showFromSuperView:self.navigationController.view];
}

-(void)selectChuanFa:(NSArray *)chuanFaArray{
    totalUnit = 0;
    
    if (self.transction.selectItems .count >1) {
        [chuanfaBtn setTitle:[NSString stringWithFormat:@"已选%lu项",(unsigned long)_transction.selectItems.count] forState:UIControlStateNormal];
    }else if(self.transction.selectItems .count == 1){
        [chuanfaBtn setTitle:[_transction.selectItems firstObject] forState:UIControlStateNormal];
    }else if(_transction.selectItems .count == 0 ){
        [chuanfaBtn setTitle:@"暂无选项" forState:UIControlStateNormal];
    }
    if (_transction.selectItems .count ==0) {
        return;
    }

    [self updataTouzhuInfo];
}

-(void)updataTouzhuInfo{
    
    totalUnit = 0;
    double maxPrize = 0.00;
    for (NSString *chuanfa in _transction.selectItems) {
        self.transction.betCount = 0;
        self.transction.chuanFa = chuanfa;
        [self.transction updataBetCount];
        totalUnit += self.transction.betCount;
        maxPrize +=[self.transction.mostBounds doubleValue];
        
    }
    self.transction.betCount = totalUnit;
    self.transction.betCost  =self.transction.betCount * [self.transction.beitou integerValue] * 2;
    if (btnMoniTouzhu.selected == YES) {
            self.labZhuInfo.text = [NSString stringWithFormat:@"%ld注,%@倍,共%ld积分",self.transction.betCount,self.transction.beitou,self.transction.betCost *100];
        self.labPrizeInfo.text = [NSString stringWithFormat:@"可中%.0f积分",maxPrize * 100];
    }else{
        self.labZhuInfo.text = [NSString stringWithFormat:@"%ld注,%@倍,共%ld元",self.transction.betCount,self.transction.beitou,self.transction.betCost];
        self.labPrizeInfo.text = [NSString stringWithFormat:@"最大可中%.2f元",maxPrize];
    }
}

- (IBAction)actionTouzhu:(UIButton *)sender {
    
  
    
    if (self.curUser == nil || self.curUser.isLogin == NO) {
        [self needLogin];
        return;
    }
    
    if (self.transction.selectItems .count == 0) {
        [self showPromptText:@"请选择过关方式" hideAfterDelay:1.7];
        return;
    }
    
    NSString *errorMsg = [self couldTouzhu];
    if (errorMsg) {
        [self showPromptText:errorMsg hideAfterDelay:2.0];
        return;
    }
    
    if (self.transction.selectMatchArray .count >15) {
        [self showPromptText:@"最多只能选择15场比赛" hideAfterDelay:1.8];
        return;
    }
    if (btnMoniTouzhu.selected == YES) {
    }else{
        if (self.transction.betCost  > 300000) {
            [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
            return;
        }
    }
    
    
    [self showLoadingText:@"正在提交订单"];
    
    self.transction.maxPrize = 1.00;
    if (sender.tag == 4) {
        self.transction.schemeType = SchemeTypeFaqiGenDan;
    }else{
        self.transction.schemeType = SchemeTypeZigou;
    }
    self.transction.units = self.transction.betCount;
    if (btnZhenShiTouzhu.selected == YES) {
        self.transction.costType = CostTypeCASH;
    }else{
        self.transction.costType = CostTypeSCORE;
    }
    
    self.transction.secretType = SecretTypeFullOpen;
    self.transction.betCost = self.transction.betCount * 2 * [self.transction.beitou integerValue];
    
    [self.lotteryMan betLotteryScheme:self.transction];
}

-(NSString *)couldTouzhu{
    if (self.transction.playType == JCZQPlayTypeDanGuan) {
        if (self.transction.selectMatchArray.count < 1) {
            return  @"单关模式下，至少保留一场比赛";
            
        }
    }
    if (self.transction.playType == JCZQPlayTypeGuoGuan) {
        if (self.transction.selectMatchArray.count < 2 ) {
            if(self.transction.selectMatchArray.count ==1){
                JCZQMatchModel *model = [self.transction.selectMatchArray firstObject];
                if (model.isDanGuan == YES) {
                    self.transction.chuanFa = @"单场";
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

- (void) betedLotteryScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    if (schemeNO == nil || schemeNO.length == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    PayOrderViewController *payVC = [[PayOrderViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.lotteryName = @"竞彩足球";
    schemeCashModel.schemeNo = schemeNO;

    schemeCashModel.subCopies = 1;
    if (btnMoniTouzhu.selected == YES) {
        schemeCashModel.costType = CostTypeSCORE;
        if (self.transction.betCost  > 30000000) {
            [self showPromptText:@"单笔总积分不能超过3千万积分" hideAfterDelay:1.7];
            return;
        }
    }else{
        schemeCashModel.costType = CostTypeCASH;
        if (self.transction.betCost  > 300000) {
            [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
            return;
        }
    }
    
    [self hideLoadingView];
    payVC.schemetype = self.transction.schemeType;
    schemeCashModel.subscribed = self.transction.betCost;
    schemeCashModel.realSubscribed = self.transction.betCost;
    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void) changCiChoose{
    JingCaiChaunFaSelectView *jingcaiSelect = [[JingCaiChaunFaSelectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [jingcaiSelect showFromSuperView:self.navigationController.view];
}

#pragma UITableViewDelegate,UITableViewDataSource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TZSelectMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:KTZSelectMatchCell];
    [cell loadData:self.transction.selectMatchArray[indexPath.row]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.transction.selectMatchArray.count;
}

-(void)navigationBackToLastPage{
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"提示" message:@"返回将清空所选赛事，确认清空吗？"];
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    [alert addBtnTitle:@"确定" action:^{
         [[NSNotificationCenter defaultCenter]postNotificationName:KSELECTMATCHCLEAN object:nil];
         [super navigationBackToLastPage];
        
    }];
    [alert showAlertWithSender:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:KSELECTMATCHCLEAN object:nil];
}

-(void)update{
    
    beiCount =[peiSelectView.labContent.text integerValue]==0?1:[peiSelectView.labContent.text integerValue];
    self.transction.beitou = [NSString stringWithFormat:@"%zd",beiCount];
    [self updataTouzhuInfo];
    
}


@end
