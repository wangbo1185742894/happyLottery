//
//  WBYCMatchDetailViewController.m
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "WBYCMatchDetailViewController.h"
#import "PayOrderViewController.h"
#import "SchemeCashPayment.h"
#import "SelectView.h"
#import "MGLabel.h"
#import "OptimizeItemModel.h"
#import "BonusOptimize.h"
@interface WBYCMatchDetailViewController ()<LotteryManagerDelegate,SelectViewDelegate>
{
    NSInteger beiCount;
    
    float keyboardheight;
    
    BOOL keyboard;
    
    NSInteger beiNum;
}
@property (weak, nonatomic) IBOutlet UILabel *defaultDes;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImg;
@property (weak, nonatomic) IBOutlet UIView *viewMatchPeiDefault;
@property (weak, nonatomic) IBOutlet UILabel *defaultPipei;
@property (weak, nonatomic) IBOutlet UIButton *btnOptimiz;



@property (weak, nonatomic) IBOutlet UILabel *labMatchTime;
@property (weak, nonatomic) IBOutlet UILabel *labMatchHomeName;
@property (weak, nonatomic) IBOutlet UILabel *labMatchGuest;
@property (weak, nonatomic) IBOutlet UIView *viewSelectItem;
@property (weak, nonatomic) IBOutlet UILabel *labPeiMatchTime;
@property (weak, nonatomic) IBOutlet UILabel *labPeiMatchHomeName;
@property (weak, nonatomic) IBOutlet UILabel *labPeiMatchGuestName;
@property (weak, nonatomic) IBOutlet UIView *viewPeiMatchItem;
@property (weak, nonatomic) IBOutlet UILabel *labPossbleBouns;
@property (weak, nonatomic) IBOutlet UILabel *labZhuBeiInfo;
@property (weak, nonatomic) IBOutlet SelectView *viewSelectBei;
@property (weak, nonatomic) IBOutlet UIView *viewContentPeiMatch;


@property (strong,nonatomic)JCYCTransaction * transaction;
@property(nonatomic,strong)UIToolbar *toolBar;

@property(nonatomic,copy)NSMutableArray <OptimizeItemModel *>*bounsOptimizeList;
@end

@implementation WBYCMatchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bounsOptimizeList = [NSMutableArray arrayWithCapacity:0];
    self.title = @"对战详情";
    self.curUser = [GlobalInstance instance].curUser;
    self.lotteryMan.delegate = self;
    self.labPossbleBouns.adjustsFontSizeToFitWidth = YES;
        self.transaction = [[JCYCTransaction alloc]init];
    self.transaction.beiTou = 5;
    
    [self showMatchDetailInfo];
    [self showPeiMatchInfo];
    if (self.isFromYC == NO) {
        [self.viewSelectBei setRightTitle:@"购" andLeftTitle:@"份"];
        self.viewSelectBei.beiShuLimit = 999;
    }else{
        self.viewSelectBei.beiShuLimit = 9999;
    }
    
    self.viewSelectBei.delegate = self;
    
    self.viewSelectBei.labContent.text =[NSString stringWithFormat: @"%ld", (long)self.transaction.beiTou];
    [self ToolView:self.viewSelectBei.labContent];
    [self.viewSelectBei setTarget:self rightAction:@selector(actionAdd) leftAction:@selector(actionSub)];
    
    [self loadDanGuanPeiMatch];
   
    [self showTouzhuInfo];
}


-(void)actionSub{
    
    beiCount =[self.viewSelectBei.labContent.text integerValue];
    if ( beiCount>1) {
        beiCount --;
    }
    
    self.viewSelectBei.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    [self update];
}

-(void)actionAdd{
    beiCount =[self.viewSelectBei.labContent.text integerValue];
    if ( beiCount < self.viewSelectBei.beiShuLimit) {
        beiCount ++;
    }
    self.viewSelectBei.labContent.text = [NSString stringWithFormat:@"%zd",beiCount];
    [self update];
    
}

-(void)showPeiMatchInfo{

    if (self.model.jcPairingMatchDto == nil) {
        self.viewMatchPeiDefault.hidden = NO;
        return;
    }else{
        self.viewMatchPeiDefault.hidden = YES;
    }
    for (UIView *subView in self.viewPeiMatchItem.subviews) {
        [subView removeFromSuperview];
    }
    self.labPeiMatchTime.text = self.model.jcPairingMatchDto.lineId;
   
    self.labPeiMatchHomeName.attributedText = [self getAttStrFromStr:[NSString stringWithFormat:@"%@(主)",self.model.jcPairingMatchDto.homeName]];
    
    self.labPeiMatchGuestName.text = self.model.jcPairingMatchDto.guestName;
    
    NSInteger selectNum = self.model.jcPairingMatchDto.options.count;
    
    for (int i = 0 ; i < self.model.jcPairingMatchDto.options.count ; i ++ ) {
        JcPairingOptions *op = self.model.jcPairingMatchDto.options[i];
        
        NSString *strPlay = @"";
        if ([op.playType integerValue ] == 5) {
            strPlay=  @"让球";
        }
            CGFloat height = self.viewPeiMatchItem.mj_h;
            CGFloat width = (self.viewPeiMatchItem.mj_w - ((selectNum - 1) * 20) -20) / selectNum;
            CGFloat curX = (width + 20) * i + 10;
            MGLabel *labitem = [[MGLabel alloc]initWithFrame:CGRectMake(curX, 0, width, height)];
            labitem.textAlignment = NSTextAlignmentCenter;
            labitem.backgroundColor =  self.viewPeiMatchItem.backgroundColor;
            labitem.font = [UIFont systemFontOfSize:13];
            labitem.backgroundColor = RGBCOLOR(250, 250,250);
            labitem.layer.cornerRadius = 4;
            labitem.layer.borderColor = TFBorderColor.CGColor;
            labitem.layer.borderWidth = 1;
        labitem.keyWordColor  = TEXTGRAYOrange;
            labitem.textColor = SystemGray;
            switch ([op.options integerValue]) {
                case 0:
                    labitem.text = [NSString stringWithFormat:@"%@胜 %.2f",strPlay,[op.sp doubleValue]];
                    labitem.keyWord = [NSString stringWithFormat:@"%@胜",strPlay];
                    break;
                case 1:
                    labitem.text = [NSString stringWithFormat:@"%@平 %.2f",strPlay,[op.sp doubleValue]];
                    labitem.keyWord = [NSString stringWithFormat:@"%@平",strPlay];
                    break;
                case 2:
                    labitem.text = [NSString stringWithFormat:@"%@负 %.2f",strPlay,[op.sp doubleValue]];
                    labitem.keyWord = [NSString stringWithFormat:@"%@负",strPlay];
                    break;
                    
                default:
                    break;
            }
            [self.viewPeiMatchItem addSubview:labitem];
    }
    
    [self showTouzhuInfo];
    
}
-(NSAttributedString *)getAttStrFromStr:(NSString *)strHomeName{
    
     NSMutableAttributedString *aStrHomeName = [[NSMutableAttributedString alloc]initWithString:strHomeName];
    [aStrHomeName setAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(153, 153, 153),NSFontAttributeName:[UIFont systemFontOfSize:9]} range:NSMakeRange(strHomeName.length - 3,3 )];
     [aStrHomeName setAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(51, 51, 51),NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, strHomeName.length - 3)];
    
    return aStrHomeName;
    
}

-(NSInteger)getZhuCount{
    NSInteger selectnum = 0;
    
    
    for (JcForecastOptions *fop in self.model.forecastOptions) {
        if ([fop.forecast boolValue] == NO) {
            continue;
        }else{
            selectnum ++ ;
        }
    }
    
        if (self.model.jcPairingMatchDto!= nil) {
            
            self.transaction.betCount = selectnum   *  self.model.jcPairingMatchDto.options.count;
            
        }else{
            self.transaction.betCount = selectnum;
        }

    if (!self.isFromYC) {
        if ( self.transaction.betCount  == 1) {
            beiNum = 10 ;
        }else if ( self.transaction.betCount  == 2){
            beiNum = 5;
        }else if ( self.transaction.betCount  == 4){
            beiNum = 5;
        }
    }else{
        beiNum = 1;
    }
    
    
    return  self.transaction.betCount ;
}



-(void)showTouzhuInfo{
    CGFloat max = 0;
    CGFloat min = 10000000000;
    NSInteger selectnum = 0;
    
    [self getZhuCount];
    
    for (JcForecastOptions *fop in self.model.forecastOptions) {
        if ([fop.forecast boolValue] == NO) {
            continue;
        }else{
            selectnum ++ ;
        }
        if (self.model.jcPairingMatchDto.options == nil || [self.model.spfSingle boolValue] == YES) {

            if (max < [fop.sp doubleValue]) {
                max = [fop.sp doubleValue];
            }
            
            if (min > [fop.sp doubleValue]) {
                min = [fop.sp doubleValue];
            }
        }else{
        
            for (JcPairingOptions *pop in self.model.jcPairingMatchDto.options) {
                CGFloat bounds=[fop.sp doubleValue] * [pop.sp doubleValue];
                if (max < bounds) {
                    max = bounds;
                }
                
                if (min > bounds) {
                    min = bounds;
                }
            }
        }
    }
    
    if (min == 10000000000) {
        self.labPossbleBouns.text = [NSString stringWithFormat:@"预计可中--元~--元"];
    }else{
        if (max == min) {
            self.labPossbleBouns.text = [NSString stringWithFormat:@"预计可中%.2f元",min *self.transaction.beiTou  * 2 * beiNum];

        }else{
            
            self.labPossbleBouns.text = [NSString stringWithFormat:@"预计可中%.2f元~%.2f元",min *self.transaction.beiTou  * 2 * beiNum  ,max * self.transaction.beiTou  * 2 * beiNum];
        
            
        }
    }
    
    if (self.model.jcPairingMatchDto == nil) {
        
        if (self.isFromYC == NO) {
          
            self.labZhuBeiInfo.text = [NSString  stringWithFormat:@"%lu注%ld倍%ld份%lu元",[self getZhuCount],(long)beiNum,self.transaction.beiTou,self.transaction.beiTou* selectnum  * 2 * beiNum];
            
        }else{
            self.labZhuBeiInfo.text = [NSString  stringWithFormat:@"%lu注%ld倍%lu元",selectnum,self.transaction.beiTou,self.transaction.beiTou* selectnum  * 2];
        }
    }else{
    
        if (self.isFromYC == NO) {
            
            self.labZhuBeiInfo.text = [NSString  stringWithFormat:@"%lu注%ld倍%ld份%lu元",[self getZhuCount],beiNum,self.transaction.beiTou,[self getZhuCount] * 2* self.transaction.beiTou * beiNum];
        }else{
        
            self.labZhuBeiInfo.text = [NSString  stringWithFormat:@"%lu注%ld倍%lu元",selectnum * self.model.jcPairingMatchDto.options.count,self.transaction.beiTou,[self getZhuCount]* 2* self.transaction.beiTou];
        }
    }
    
   
    [self setNumberColor:self.labZhuBeiInfo];
    self.transaction.maxPrize = max * self.transaction.beiTou;
    self.transaction.betCost = self.transaction.betCount * 2 * self.transaction.beiTou * beiNum;
}

-(void)showMatchDetailInfo{

    self.labMatchTime.text = self.model.lineId;
    self.labMatchHomeName.attributedText = [self getAttStrFromStr:[NSString stringWithFormat:@"%@(主)",self.model.homeName]] ;
    self.labMatchGuest.text =self.model.guestName ;
    NSInteger selectNum = 0;
    for (JcForecastOptions * op in self.model.forecastOptions) {
        if ([op.forecast boolValue] == YES) {
            selectNum ++ ;
        }
    }
    
    int i = 0;
    
    for (int j = 0 ; j < self.model.forecastOptions.count ; j ++ ) {

        JcForecastOptions *op = self.model.forecastOptions[j];
        if ([op.forecast boolValue] == YES) {
          
            CGFloat height = self.viewSelectItem.mj_h;
       
            CGFloat width = (self.viewSelectItem.mj_w - ((selectNum - 1) * 20) -20) / selectNum;
            CGFloat curX = (width + 20) * i + 10;
            MGLabel *labitem = [[MGLabel alloc]initWithFrame:CGRectMake(curX, 0, width, height)];
            labitem.textAlignment = NSTextAlignmentCenter;
            labitem.backgroundColor = RGBCOLOR(250, 250,250);
            labitem.layer.cornerRadius = 4;
            labitem.layer.borderColor = TFBorderColor.CGColor;
            labitem.layer.borderWidth = 1;
            labitem.font = [UIFont systemFontOfSize:13];
            labitem.keyWordColor = TEXTGRAYOrange;
            labitem.textColor = SystemGray;
            if ([self.curPlayType isEqualToString:@"jclq"]) {
                switch ([op.options integerValue]) {
                    case 0:
                        labitem.text = [NSString stringWithFormat:@"客胜 %.2f",[op.sp doubleValue]];
                        break;
                    case 1:
                        labitem.text = [NSString stringWithFormat:@"主胜 %.2f",[op.sp doubleValue]];
                        break;
                        
                    default:
                        break;
                }

            }else if ([self.curPlayType isEqualToString:@"jczq"]){
                
                
                switch ([op.options integerValue]) {
                    case 0:
                        labitem.text = [NSString stringWithFormat:@"主胜 %.2f",[op.sp doubleValue]];
                        labitem.keyWord = @"主胜";
                        break;
                    case 1:
                        labitem.text = [NSString stringWithFormat:@"平 %.2f",[op.sp doubleValue]];
                        labitem.keyWord = @"平";
                        break;
                    case 2:
                        labitem.text = [NSString stringWithFormat:@"主负 %.2f",[op.sp doubleValue]];
                        labitem.keyWord = @"主负";
                        break;
                        
                    default:
                        break;
                }
            }
              i ++;
            [self.viewSelectItem addSubview:labitem];
        }
    }
    
}

-(void)loadDanGuanPeiMatch{
    
    if ([self.model.spfSingle boolValue] == YES) {
        self.viewMatchPeiDefault.hidden = NO;
        self.defaultImg.hidden = YES;
        self.defaultDes.hidden = YES;
        self.defaultPipei.hidden = YES;
        return;
    }
    
    if (self.model.matchKey == nil ) {
        self.viewMatchPeiDefault.hidden = NO;
        self.defaultImg.hidden = NO;
        self.defaultDes.hidden = NO;
        self.defaultPipei.hidden = NO;
        return;
    }
    
    [self showLoadingViewWithText:@"正在加载"];
    [self.lotteryMan getJczqPairingMatch:@{@"matchKey":self.model.matchKey, @"isDefault":@false}];
}

-(void)gotJczqPairingMatch:(NSDictionary *)infoDic errorMsg:(NSString *)msg{
    [self hideLoadingView];
    
    if (infoDic == nil) {
        self.viewMatchPeiDefault.hidden = NO;
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    self.viewMatchPeiDefault.hidden = YES;
    JcPairingMatchModel * model = [[JcPairingMatchModel alloc]initWith:infoDic];
    self.model.jcPairingMatchDto = model;
    [self showPeiMatchInfo];
}

- (IBAction)actionChangMatch:(UIButton *)sender {
    self.btnOptimiz.selected = NO;
    [self loadDanGuanPeiMatch];
}


- (IBAction)actionTouzhu:(id)sender {
    
    
    for (JcPairingOptions *ops in self.model.jcPairingMatchDto.options) {
        if ([ops.sp doubleValue] == 0) {
            [self showPromptText:@"该赛事暂不支持胜平负玩法" hideAfterDelay:1.7];
            return;
        }
    }
    
    for (JcForecastOptions *ops in self.model.forecastOptions) {
        if ([ops.sp doubleValue] == 0) {
            [self showPromptText:@"该赛事暂不支持胜平负玩法" hideAfterDelay:1.7];
            return;
        }
    }
    
    
    if (self.curUser .isLogin == NO) {
        [self needLogin];
        return;
    }
    
    self.transaction.betSource = @"2";
    self.transaction.shortCutModel = self.model;
    if ([self.curPlayType isEqualToString:@"jclq"]) {

        self.transaction.identifier = @"JCLQ";
    }else{
        self.transaction.identifier = @"JCZQ";
    }
    [self showTouzhuInfo];
    if ([self.viewSelectBei.labContent .text integerValue] < 1) {
        self.transaction.beiTou = 1 * beiNum;
    }else{
        self.transaction.beiTou = [self.viewSelectBei.labContent .text integerValue] * beiNum;
    }
    
    
    if ([self.model.spfSingle boolValue] == NO && self.model.jcPairingMatchDto == nil) {
        [self showPromptText:@"该场比赛不支持单关投注" hideAfterDelay:1.7];
        return;
    }
    [self showLoadingViewWithText:@"正在加载"];
    
    self.transaction.schemeSource = SchemeSourceFORECAST;
    self.transaction.costType = CostTypeCASH;
    if (self.btnOptimiz.selected == YES) {
        
        NSMutableArray *betContent = [NSMutableArray arrayWithCapacity:0];
        @try {
            for (OptimizeItemModel * oModel in _bounsOptimizeList) {
                NSMutableArray *betMatches = [NSMutableArray arrayWithCapacity:0];
                for (BounsOptimizeSingleModel *model in oModel.bonusOptimizeSingleList) {
                    NSDictionary * itemDic = @{@"betPlayTypes":@[@{@"options":@[model.option],@"playType":model.playType}],@"clash":model.clash,@"dan":@"0",@"matchId":model.matchId,@"matchKey":model.matchKey};
                    ;
                    [betMatches addObject:itemDic];
                }
                
                [betContent addObject:@{@"betMatches":betMatches,@"passTypes":@[oModel.passType],@"multiple":@(oModel.multiple)}];
            }
        } @catch (NSException *exception) {
            [self showPromptText:@"奖金优化失败" hideAfterDelay:1.9];
            return;
        }
        
        [self.lotteryMan betLotterySchemeOpti:self.transaction schemeList:betContent];
    }else{
        [self.lotteryMan betLotteryScheme:self.transaction];
    }
    

}

- (void) finishTouZhu: (NSString *) orderNum errorCode:(NSString *)errorCode{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}

-(void)keyboardWillShow:(NSNotification *)notify{
    NSDictionary *userInfo = [notify userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardheight = keyboardRect.size.height;
    //    if(keyboard == NO){
    CGRect fram = [UIScreen mainScreen].bounds;
    fram.size.height -= 240;
    
    self.view.frame = fram;
    keyboard = YES;
    //    }
}

-(void)keyboardWillHide:(NSNotification *)notify{
    
    if(keyboard == YES){
        CGRect fram = self.view.frame;
        
        fram.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = fram;
        keyboard = NO;
    }
    
    if ([self.viewSelectBei.labContent.text integerValue]<1) {
        self.viewSelectBei.labContent.text = @"1";
        self.transaction.beiTou = [self.viewSelectBei.labContent.text integerValue];
        
    }
}

-(void)actionWancheng:(UITextView*)tv{
    
    [self.viewSelectBei.labContent resignFirstResponder];
}

-(void)ToolView:(UITextField *)textField{
    
    [textField resignFirstResponder];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIButton *submitClean = [UIButton buttonWithType:UIButtonTypeCustom];
    submitClean.mj_h = 15;
    submitClean.mj_w = 25;
    [submitClean setBackgroundImage:[UIImage imageNamed:@"keyboarddown"] forState:UIControlStateNormal];
    [submitClean setTitleColor:RGBCOLOR(72, 72, 72) forState:UIControlStateNormal];
    submitClean.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitClean addTarget:self action:@selector(actionWancheng:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *itemsubmit = [[UIBarButtonItem alloc]initWithCustomView:submitClean];
    
    topView.backgroundColor = RGBCOLOR(230, 230, 230);
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithCustomView:[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 30)]];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:space,itemsubmit,nil];
    
    topView.opaque = YES;
    [topView setItems:buttonsArray];
    self.toolBar = topView;
    [textField setInputAccessoryView:self.toolBar];
}


-(void)update{

    NSInteger beiShu = [self.viewSelectBei.labContent.text integerValue] < 1 ?1:[self.viewSelectBei.labContent.text integerValue];
    self.transaction.beiTou = beiShu;
    self.btnOptimiz.selected = NO;
    [self showTouzhuInfo];
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameUserLogin object:nil];
}


- (void)setNumberColor:(UILabel *)contentLabel{
    NSMutableAttributedString  *attStr = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSString *temp = @"";
    for (NSInteger i =0; i<[contentLabel.text length]; i++) {
        temp = [contentLabel.text substringWithRange:NSMakeRange(i, 1)];
        if ([self isInt:temp]) {
            [attStr setAttributes:@{NSForegroundColorAttributeName:SystemGreen} range:NSMakeRange(i, 1)];
        }
    }
    contentLabel.attributedText = attStr;
}

- (BOOL)isInt:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (string.length > 0) {
        return NO;
    }
    return YES;
    
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
    schemeCashModel.schemeNo = schemeNO;
    schemeCashModel.subCopies = 1;
    
    schemeCashModel.costType = CostTypeCASH;
    
    schemeCashModel.subscribed = self.transaction.betCost;
    schemeCashModel.realSubscribed = self.transaction.betCost;
    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
}
- (IBAction)actionBounsOptimize:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected == NO) {
        [self showTouzhuInfo];
        return;
    }
    
    if (self.curUser .isLogin == NO) {
        [self needLogin];
        return;
    }
    
    self.transaction.betSource = @"2";
    self.transaction.shortCutModel = self.model;
    if ([self.curPlayType isEqualToString:@"jclq"]) {
        
        self.transaction.identifier = @"JCLQ";
    }else{
        self.transaction.identifier = @"JCZQ";
    }
    [self showTouzhuInfo];
    if ([self.viewSelectBei.labContent .text integerValue] < 1) {
        self.transaction.beiTou = 1 * beiNum;
    }else{
        self.transaction.beiTou = [self.viewSelectBei.labContent .text integerValue] * beiNum;
    }
    
    
    if ([self.model.spfSingle boolValue] == NO && self.model.jcPairingMatchDto == nil) {
        [self showPromptText:@"该场比赛不支持单关投注" hideAfterDelay:1.7];
        return;
    }
    [self showLoadingViewWithText:@"正在优化..."];
    
    self.transaction.schemeSource = SchemeSourceFORECAST;
    self.transaction.costType = CostTypeCASH;
    
    [self.lotteryMan getbonusOptimize:self.transaction];
}

-(void)gotbonusOptimize:(NSArray *)infoList errorMsg:(NSString *)msg{
    
    if (infoList == nil) {
        [self hideLoadingView];
        return;
    }
    [_bounsOptimizeList removeAllObjects];
    for (NSDictionary *itemDic in infoList) {
        OptimizeItemModel *model = [[OptimizeItemModel alloc]initWith:itemDic];
        [_bounsOptimizeList addObject:model];
    }
    [self bonusOptimize];
}

-(void)bonusOptimize{
    CGFloat avgSp =[BonusOptimize getMincCommonDivisor:[self getAllSp]];
    CGFloat subOptimize = 0;
    for (OptimizeItemModel * model in _bounsOptimizeList) {
        subOptimize += avgSp / [model.forecastBonus doubleValue];
    }
    NSInteger totalBei =[self getZhuCount] * self.transaction.beiTou;
    for (OptimizeItemModel * model in _bounsOptimizeList) {
         model.multiple = (avgSp / [model.forecastBonus doubleValue]) / subOptimize * [self getZhuCount] * self.transaction.beiTou;
        totalBei -= model.multiple;
    }
    for (NSInteger i = totalBei; i > 0; i--) {
        OptimizeItemModel *minBounsModel = [_bounsOptimizeList firstObject];
        for (OptimizeItemModel * model in _bounsOptimizeList) {
            if ([model.forecastBonus doubleValue] * model.multiple < [minBounsModel.forecastBonus doubleValue] * minBounsModel.multiple) {
                minBounsModel = model;
            }
        }
        minBounsModel .multiple ++;
    }
    float min = CGFLOAT_MAX;
    float max = CGFLOAT_MIN;
    
    for (OptimizeItemModel * model in _bounsOptimizeList) {
        if (min > model.multiple * [model.forecastBonus doubleValue]) {
            min =model.multiple * [model.forecastBonus doubleValue];
        }
        if (max < model.multiple * [model.forecastBonus doubleValue]) {
            max =model.multiple * [model.forecastBonus doubleValue];
        }
    }
    if (min == CGFLOAT_MAX) {
        self.labPossbleBouns.text = [NSString stringWithFormat:@"预计可中--元~--元"];
    }else{
        if (max == min) {
            self.labPossbleBouns.text = [NSString stringWithFormat:@"预计可中%.2f元",min];
            
        }else{
            
            self.labPossbleBouns.text = [NSString stringWithFormat:@"预计可中%.2f元~%.2f元",min,max];
            
            
        }
    }
    [self hideLoadingView];
}

-(NSArray *)getAllSp{
    NSMutableArray *spList = [NSMutableArray arrayWithCapacity:0];
    for (OptimizeItemModel *model in _bounsOptimizeList) {
        [spList addObject:model.forecastBonus];
    }
    return spList;
}

@end
