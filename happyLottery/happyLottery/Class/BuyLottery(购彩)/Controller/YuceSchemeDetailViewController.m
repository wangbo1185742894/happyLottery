//
//  YuceSchemeDetailViewController.m
//  Lottery
//
//  Created by onlymac on 2017/10/12.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "YuceSchemeDetailViewController.h"
#import "YuCeSchemeDetailCell.h"
#import "SelectView.h"
#import "LoginViewController.h"
#import "MGLabel.h"
#import "JCFATransaction.h"
#import "SchemeCashPayment.h"
#import "PayOrderLegViewController.h"
@interface YuceSchemeDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SelectViewDelegate,LotteryManagerDelegate>
{
    BOOL isAgreePayDelegateRuler;
    NSInteger beiCount;
    NSInteger selectnum ;
    float keyboardheight;
    
    BOOL keyboard;
}





@property(nonatomic,strong)UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet MGLabel *mingzhonglvLabel;
@property (weak, nonatomic) IBOutlet MGLabel *beilvLabel;

@property (strong,nonatomic)JCFATransaction * transaction;

@property (weak, nonatomic) IBOutlet UIButton *yuyueBtn;
@property (weak, nonatomic) IBOutlet UILabel *fanganLabel;
@property (weak, nonatomic) IBOutlet UILabel *touzhufangshiLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewDisBottom;

@property (weak, nonatomic) IBOutlet SelectView *beiSelectView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *kezhongLabel;
@property (weak, nonatomic) IBOutlet UILabel *touzhuLabel;
- (IBAction)actionTouZhu:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *huanyigeBtn;
- (IBAction)huanyigeBtn:(UIButton *)sender;
@end

@implementation YuceSchemeDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isIphoneX]) {
        self.viewDisTop.constant = 88;
        self.viewDisBottom.constant = 34;
    }else{
        self.viewDisTop.constant = 64;
        self.viewDisBottom.constant = 0;
    }
//    if ([self.curUser.whitelist boolValue] == NO) {
//        self.yuyueBtn.hidden = YES;
//    }
    self.navigationItem.title = @"足球方案详情";
    self.transaction = [[JCFATransaction alloc]init];
     [self.myTableView registerNib:[UINib nibWithNibName:@"YuCeSchemeDetailCell" bundle:nil] forCellReuseIdentifier:@"YuCeSchemeDetailCell"];
    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    isAgreePayDelegateRuler = YES;
    [self setLotteryManager];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self setUpUI];
    
//    [self enableKeyboarderListener];
   
    [self ToolView:self.beiSelectView.labContent];
    self.yuyueBtn.layer.cornerRadius = 5;
}


- (void)updateTZfangshi {
    NSString * temp  = [self.scheme.passTypes stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    
    NSString *chuanfa = [temp stringByReplacingOccurrencesOfString:@"_" withString:@"串"];
    
    
    selectnum = 0;
    NSInteger i = 0;
    NSInteger a = 0;
    NSInteger b = 0;
    for (jcBetContent *model in self.scheme.jcBetContent) {
        
        for (YCbetPlayTypes *model1 in model.betPlayTypes) {
            i++;
            if (i == 1) {
                a =  model1.options.count ;
            }else if(i == 2){
                b = model1.options.count;
            }
            selectnum = a * b;
        }
        
    }
    self.touzhufangshiLabel.text = [NSString stringWithFormat:@"%@,%ld注,%@",chuanfa,(long)selectnum,self.money];
    NSString *maxPrizeStr =  [self.money substringToIndex:(self.money.length -1)];
    NSInteger maxPrize = [maxPrizeStr integerValue];
    NSInteger betCount = maxPrize / 2;
    self.touzhuLabel.text = [NSString stringWithFormat:@"%ld注,%ld倍,%ld份,%@",(long)selectnum,(long)betCount,beiCount,self.money];
    NSMutableAttributedString  *attStr = [[NSMutableAttributedString alloc] initWithString:self.touzhuLabel.text];
        NSString *temp1 = @"";
        for (NSInteger i =0; i<[self.touzhuLabel.text length]; i++) {
            temp1 = [self.touzhuLabel.text substringWithRange:NSMakeRange(i, 1)];
            if ([self isInt:temp1]) {
//                [attStr setAttributes:@{NSForegroundColorAttributeName:TextCharColor} range:NSMakeRange(i, 1)];
            }
        }
        self.touzhuLabel.attributedText = attStr;
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",([self.scheme.earnings doubleValue] * [maxPrizeStr doubleValue])];
    
    self.kezhongLabel.text = [NSString stringWithFormat:@"%@元",moneyStr];
}
-(void)setLotteryManager{
   
    self.lotteryMan.delegate = self;
}
- (void)setUpUI{
    
   
    
    self.beilvLabel.keyWordFont = [UIFont systemFontOfSize:10];
    self.beilvLabel.text = [NSString stringWithFormat:@"%.2f倍",[self.scheme.earnings doubleValue]];
    self.beilvLabel.keyWord = @"倍";

    self.mingzhonglvLabel.keyWordFont = [UIFont systemFontOfSize:10];
    self.mingzhonglvLabel.text = [NSString stringWithFormat:@"%@%%",self.scheme.predictIndex];
    self.mingzhonglvLabel.keyWord = @"%";
    
    self.fanganLabel.text = self.scheme.recSchemeNo;
    self.fanganLabel.adjustsFontSizeToFitWidth = YES;
    
    if ([self.xuQiuBtnTag integerValue] == 300) {
        self.beilvLabel.textColor = TEXTGRAYOrange;
        self.mingzhonglvLabel.textColor = TEXTGRAYCOLOR;
    }else if ([self.xuQiuBtnTag integerValue] == 301){
        self.beilvLabel.textColor = TEXTGRAYCOLOR;
        self.mingzhonglvLabel.textColor =  TEXTGRAYOrange;
    }
    
    self.timeLabel.text = [self.scheme.dealLine substringWithRange:NSMakeRange(5, 11)];
    beiCount = 1;
    [self updateTZfangshi];
    
    [self.myTableView reloadData];

    self.beiSelectView.delegate = self;
    self.beiSelectView.beiShuLimit = 999;
    
    self.beiSelectView.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    
    [self.beiSelectView setTarget:self rightAction:@selector(actionAddBei) leftAction:@selector(actionSubBei)];
}

-(void)actionSubBei{
    
    beiCount =[self.beiSelectView.labContent.text integerValue];
    if (beiCount>1) {
        beiCount --;
    }
    self.beiSelectView.labContent.text = [NSString stringWithFormat:@"%ld",(long)beiCount];
    [self refreshTouzhuVCSummary];
}

-(void)actionAddBei{
    beiCount =[self.beiSelectView.labContent.text integerValue];
    if ( beiCount < 999) {
        beiCount ++;
    }
    self.beiSelectView.labContent.text = [NSString stringWithFormat:@"%zd",beiCount];
    
    [self refreshTouzhuVCSummary];
}

-(void)refreshTouzhuVCSummary{
    [self update];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YuCeSchemeDetailCell *cell = [YuCeSchemeDetailCell cellWithTableView:tableView];
 
    
    [cell refreshData:self.scheme.jcBetContent[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.scheme.jcBetContent.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)agereeForUsDelegateRuler:(id)sender {
    UIButton * checkBt = (UIButton *)sender;
    checkBt.selected = !checkBt.selected;
    isAgreePayDelegateRuler = checkBt.selected;
}


- (IBAction)showDelegateRuler:(id)sender {
    

}

- (void)update{
    beiCount = [self.beiSelectView.labContent.text integerValue];
    if (beiCount == 0) {
        beiCount = 1;
    }
    NSString *maxPrizeStr =  [self.money substringToIndex:(self.money.length -1)];
    NSInteger maxPrize = [maxPrizeStr integerValue];
    NSInteger betCount = maxPrize / 2;
    self.touzhuLabel.text = [NSString stringWithFormat:@"%ld注,%ld倍,%ld份,%ld元",(long)selectnum,(long)betCount,beiCount,(maxPrize * beiCount)];
    NSMutableAttributedString  *attStr = [[NSMutableAttributedString alloc] initWithString:self.touzhuLabel.text];
    NSString *temp1 = @"";
    for (NSInteger i =0; i<[self.touzhuLabel.text length]; i++) {
        temp1 = [self.touzhuLabel.text substringWithRange:NSMakeRange(i, 1)];
        if ([self isInt:temp1]) {
//            [attStr setAttributes:@{NSForegroundColorAttributeName:TextCharColor} range:NSMakeRange(i, 1)];
        }
    }
    self.touzhuLabel.attributedText = attStr;
    NSString *money =  [NSString stringWithFormat:@"%ld",(maxPrize * beiCount)];
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",([self.scheme.earnings doubleValue] * [money doubleValue])];
    
    self.kezhongLabel.text = [NSString stringWithFormat:@"%@元",moneyStr];
}

- (IBAction)actionTouZhu:(UIButton *)sender {
    if (self.curUser.isLogin) {
         [self showTouzhuInfo];
        self.transaction.betCount = selectnum;
        
        self.transaction.schemeSource = SchemeSourceFORECAST_SCHEME;
        self.transaction.betSource = @"2";
        self.transaction.yuceScheme = self.scheme;
        
        
        
        
        self.transaction.maxPrize = 1.00;
        self.transaction.schemeType = SchemeTypeZigou;
        
        
        self.transaction.costType = CostTypeCASH;
        
        self.transaction.secretType = SecretTypeFullOpen;
        
        NSString *maxPrizeStr =  [self.money substringToIndex:(self.money.length -1)];
        NSInteger maxPrize = [maxPrizeStr integerValue];
        NSInteger betCount = maxPrize / 2;
        self.transaction.beiTou = beiCount * betCount;
        
        beiCount = [self.beiSelectView.labContent.text integerValue];
        if (beiCount == 0) {
            beiCount = 1;
        }

        
        self.transaction.betCost = maxPrize * beiCount;
        self.transaction.units = self.transaction.betCount;
//        [self.lotteryMan betLotteryScheme:self.transaction];
        PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
        payVC.basetransction = self.transaction;
        payVC.lotteryName = @"竞彩足球";
        payVC.subscribed = self.transaction.betCost;
        payVC.schemetype = self.transaction.schemeType;
        [self.navigationController pushViewController:payVC animated:YES];
        [self showLoadingViewWithText:@"正在加载"];
        if (self.scheme.recSchemeNo != nil) {
            [self.lotteryMan updateRecSchemeRecCount:@{@"recSchemeNo":self.scheme.recSchemeNo}];
        }
    }else{
        [self needLogin];
        return;
    }
    
}



- (void) betedLotteryScheme:(NSString *)schemeNO errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (schemeNO == nil || schemeNO.length == 0) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;
    schemeCashModel.schemeNo = schemeNO;
    schemeCashModel.subCopies = 1;
    schemeCashModel.lotteryName = @"竞彩足球";
    schemeCashModel.costType = CostTypeCASH;
    
    schemeCashModel.subscribed = self.transaction.betCost;
    schemeCashModel.realSubscribed = self.transaction.betCost;
//    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
}
- (void) actionAfterLogin {
    //jump to this tab
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameUserLogin object:nil];
    
}



-(void)showTouzhuInfo{
    
    
}

- (IBAction)huanyigeBtn:(UIButton *)sender {
    self.index ++;
//    int x = arc4random() % (self.dataArray.count);
    if (self.dataArray.count - 1 < self.index) {
        self.index = 0;
    }
    self.scheme =   self.dataArray[self.index];
    [self setUpUI];
    
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
    
    if ([self.beiSelectView.labContent.text integerValue]<1) {
        self.beiSelectView.labContent.text = @"1";
    }
}

-(void)actionWancheng:(UITextView*)tv{
    
    [self.beiSelectView.labContent resignFirstResponder];
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

- (BOOL)isInt:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (string.length > 0) {
        return NO;
    }
    return YES;
    
}

@end
