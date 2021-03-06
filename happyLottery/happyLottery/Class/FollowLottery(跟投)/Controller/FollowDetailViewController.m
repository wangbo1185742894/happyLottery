//
//  FollowDetailViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FollowDetailViewController.h"
#import "SelectView.h"
#import "SchemeCashPayment.h"
#import "PayOrderLegViewController.h"
#import "MGLabel.h"

@interface FollowDetailViewController ()<SelectViewDelegate,LotteryManagerDelegate>
@property (weak, nonatomic) IBOutlet MGLabel *labDeadLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UIButton *btnGuanzhu;
@property (weak, nonatomic) IBOutlet UIImageView *labPersonIcon;
@property (weak, nonatomic) IBOutlet UILabel *labPersonName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDis;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnBeiSelect;
@property (weak, nonatomic) IBOutlet UILabel *labQitou;
@property (weak, nonatomic) IBOutlet UILabel *labGentou;
@property (weak, nonatomic) IBOutlet UILabel *labZigou;
@property (weak, nonatomic) IBOutlet UILabel *labYujihuibao;
@property (weak, nonatomic) IBOutlet UILabel *labLotteryName;
@property (weak, nonatomic) IBOutlet UILabel *labBetContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgLotteryIcon;
@property (weak, nonatomic) IBOutlet SelectView *wbSelectView;
@property (weak, nonatomic) IBOutlet MGLabel *btnBetInfo;
@property(assign,nonatomic)NSInteger beiCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgFlag2;
@property (weak, nonatomic) IBOutlet UIImageView *imgFlag3;
@property (weak, nonatomic) IBOutlet UIButton *btnTouzhu;

@property (weak, nonatomic) IBOutlet UIImageView *imgFlag1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;
@property (weak, nonatomic) IBOutlet UIImageView *youHuaTag;
@end

@implementation FollowDetailViewController{
    
    BOOL isAttend;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIButton *btn in _btnBeiSelect) {
        if (btn.tag == 10) {
            btn.selected = YES;
        }
        [self setBtnBoard:btn];
    }
    if ([self isIphoneX]) {
        _topDis.constant = 88;
        _bottomDis.constant = 38;
    }else{
        _topDis.constant = 64;
        _bottomDis.constant = 0;
    }
    if ([self isIphone5s]) {
        self.rightCons.constant = 2;
        self.widthCons.constant = 65;
    }else {
        self.rightCons.constant = 20;
        self.widthCons.constant = 85;

    }
    self.title = @"跟单详情";
//    if ([self.curUser.whitelist boolValue] == NO) {
//        self.btnTouzhu.hidden = YES;
//    }

    self.wbSelectView.beiShuLimit = 9999;
    self.wbSelectView.labContent.textColor = RGBCOLOR(254, 168, 19);
    self.wbSelectView.delegate = self;
    [self.wbSelectView setTarget:self rightAction:@selector(actionAdd) leftAction:@selector(actionSub)];
    self.lotteryMan.delegate = self;
    if (self.schemeNo != nil) {
        [self showLoadingText:@"正在加载"];
        [self.lotteryMan getFollowSchemeBySchemeNo:@{@"schemeNo":self.schemeNo}];
    }else{
        [self loadData];
        [self updataTouzhuInfo];
    }
    
    self.beiCount = 10;
    
   
}

-(void)gotFollowSchemeBySchemeNo:(NSDictionary *)resultDic errorInfo:(NSString *)msg{
    [self hideLoadingView];
    if (resultDic == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    
    self .model = [[HotSchemeModel alloc]initWith:resultDic];
    [self loadData];
    [self updataTouzhuInfo];
}

-(void)loadData{
    [self.imgLotteryIcon setImage: [UIImage imageNamed:[_model lotteryIcon]]];
    self.labLotteryName.text = [BaseModel getLotteryByName:_model.lottery];
    NSArray *laburls = [self.model.label_urls componentsSeparatedByString:@";"];
    for (int i = 0; i < laburls.count; i ++) {
        if (i == 0) {
            self.imgFlag1.hidden = NO;
            
            [self.imgFlag1 sd_setImageWithURL:[NSURL URLWithString:laburls[i]]];
        }else if(i == 1){
            [self.imgFlag2 sd_setImageWithURL:[NSURL URLWithString:laburls[i]]];
            self.imgFlag2.hidden = NO;
            
        }else if (i == 2){
            [self.imgFlag3 sd_setImageWithURL:[NSURL URLWithString:laburls[i]]];
            self.imgFlag3.hidden = NO;
        }
    }
    self.labPersonIcon.layer.cornerRadius = self.labPersonIcon.mj_h/2;
    self.labPersonIcon.layer.masksToBounds = YES;
    self.labBetContent.text = [_model getDetailContent];
    if (_model.headUrl.length == 0) {
        [self.labPersonIcon setImage: [UIImage imageNamed:@"usermine"]];
    }else{
        
        [self.labPersonIcon sd_setImageWithURL:[NSURL URLWithString:_model.headUrl]];
    }
    self.labDeadLine.text = [NSString stringWithFormat:@"截止时间:%@",_model.deadLine];
    
    self.labPersonName .text =  _model.nickName;
    
    self.labYujihuibao.text =  [NSString stringWithFormat:@"%.2f倍",[_model.pledge doubleValue]];
    self.labZigou.text =[NSString stringWithFormat:@"%d元",[_model.betCost intValue]];
    //虚拟账号跟单金额造假（10000370-10000380）(末尾数+20)*起投金额*2+真实跟单金额
    NSString *carcode = [_model.cardCode substringWithRange:NSMakeRange(0, 7)];
    if ([carcode isEqualToString:@"1000037"]||[_model.cardCode isEqualToString:@"10000380"]) {
        self.labGentou.text = [NSString stringWithFormat:@"%d元",([[_model.cardCode substringFromIndex:_model.cardCode.length-1] intValue]+20)*[_model.minFollowCost intValue]*2+[_model.totalFollowCost intValue]];
    } else{
        self.labGentou.text =[NSString stringWithFormat:@"%d元",[_model.totalFollowCost intValue]];
    }
    self.labQitou.text =[NSString stringWithFormat:@"%d元",[_model.minFollowCost intValue]];
    self.btnGuanzhu.layer.borderColor = TEXTGRAYOrange.CGColor;
    self.btnGuanzhu.layer.borderWidth = 1;
    if (self.curUser == nil || self.curUser.isLogin == NO) {
        isAttend = NO;
        [self.btnGuanzhu setTitle:@"+关注" forState:UIControlStateNormal];
    } else {
        NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":_model.cardCode,@"attentType":@"FOLLOW"};
        [self.lotteryMan isAttent:dic];
    }
    self.youHuaTag.hidden = YES;
//    if ([_model.schemeSource isEqualToString:@"BONUS_OPTIMIZE"]) {
//        self.youHuaTag.hidden = NO;
//    }else {
//        self.youHuaTag.hidden = YES;
//    }
}

- (void) gotisAttent:(NSString *)diction  errorMsg:(NSString *)msg{
    if ([diction boolValue]) {
        isAttend = YES;
        [self.btnGuanzhu setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        isAttend = NO;
        [self.btnGuanzhu setTitle:@"+关注" forState:UIControlStateNormal];
    }
}

-(void)setBtnBoard:(UIButton *)item{
    [item setTitleColor:SystemGray forState:0];
    [item setTitleColor:SystemGreen forState:UIControlStateSelected];
    if (item.selected == YES) {
        item.layer.borderWidth = 1;
        item.layer.borderColor = SystemGreen.CGColor;
        item.layer.cornerRadius = 3;
        item.layer.masksToBounds  = YES;
    }else{
        item.layer.borderWidth = 1;
        item.layer.borderColor = TFBorderColor.CGColor;
        item.layer.cornerRadius = 3;
        item.layer.masksToBounds  = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionGenDan:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if (self .curUser .isLogin == NO) {
        [self needLogin];
        return;
    }
    if (_beiCount == 0) {
        [self showPromptText:@"至少购买一倍" hideAfterDelay:1.9];
        return;
    }
    NSDictionary *paraDic= @{@"schemeNo":_model.schemeNo , @"cardCode":self.curUser.cardCode,@"multiple":@(_beiCount)};
//    [self showLoadingText:@"正在提交"];
    PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
    payVC.schemetype = SchemeTypeGenDan;
    payVC.diction = paraDic;
    if ([_model.lottery isEqualToString:@"JCZQ"]) {
        payVC.lotteryName = @"竞彩足球";
    } else {
        payVC.lotteryName = @"竞彩篮球";
    }
    payVC.subscribed = [self.model.minFollowCost doubleValue] * _beiCount;
    [self.navigationController pushViewController:payVC animated:YES];

//    [self.lotteryMan followScheme:paraDic];
}

-(void)followScheme:(NSString *)result errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if (result == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    PayOrderLegViewController *payVC = [[PayOrderLegViewController alloc]init];
    payVC.schemetype = SchemeTypeGenDan;
    SchemeCashPayment *schemeCashModel = [[SchemeCashPayment alloc]init];
    schemeCashModel.cardCode = self.curUser.cardCode;

    schemeCashModel.lotteryName =[BaseModel getLotteryByName: _model.lottery];

    schemeCashModel.schemeNo = result;
    schemeCashModel.subCopies = 1;
    schemeCashModel.costType = CostTypeCASH;
    if ([self getBetCost]  > 300000) {
        [self showPromptText:@"单笔总金额不能超过30万元" hideAfterDelay:1.7];
        return;
    }
    [self hideLoadingView];
    schemeCashModel.subscribed =[self getBetCost];
    schemeCashModel.realSubscribed = [self getBetCost];
//    payVC.cashPayMemt = schemeCashModel;
}

-(void)actionSub{
    
    _beiCount =[self.wbSelectView.labContent.text integerValue];
    if ( _beiCount>1) {
        _beiCount --;
    }
    self.wbSelectView.labContent.text = [NSString stringWithFormat:@"%ld",(long)_beiCount];
    [self updataTouzhuInfo];
}

-(void)actionAdd{
    _beiCount =[self.wbSelectView.labContent.text integerValue];
    if ( _beiCount < self.wbSelectView.beiShuLimit) {
        _beiCount ++;
    }
    self.wbSelectView.labContent.text = [NSString stringWithFormat:@"%zd",_beiCount];
    [self updataTouzhuInfo];
}

-(void)updataTouzhuInfo{
    _beiCount = [self.wbSelectView.labContent.text integerValue];
    _wbSelectView.labContent.text = [NSString stringWithFormat:@"%ld",_beiCount];
    _btnBetInfo.text = [NSString stringWithFormat:@"共%.2f元",[self.model.minFollowCost doubleValue] * _beiCount] ;
    _btnBetInfo.keyWord = [NSString stringWithFormat:@"%.2f",[self.model.minFollowCost doubleValue] * _beiCount];
    _btnBetInfo.keyWordColor = RGBCOLOR(254, 168, 19);

}

-(void)update{
    for (UIButton *btn in _btnBeiSelect) {
        btn.selected = NO;
    }
    [self updataTouzhuInfo];
}

-(CGFloat)getBetCost{
    return [self.model.minFollowCost doubleValue] * _beiCount;
}

- (IBAction)actionBeiSelect:(UIButton *)sender {
    for (UIButton *btn in _btnBeiSelect) {
        btn.selected = NO;
    }
    sender.selected = YES;
    for (UIButton *btn in _btnBeiSelect) {
        [self setBtnBoard:btn];
    }
    _beiCount = sender.tag;
    _wbSelectView.labContent.text = [NSString stringWithFormat:@"%ld",_beiCount];
    [self updataTouzhuInfo];

}

- (IBAction)actionGuanzhu:(id)sender {
    if (self.curUser == nil || self.curUser.isLogin==NO) {
        [self needLogin];
        return;
    }
    self.btnGuanzhu.userInteractionEnabled = NO;
    [self addOrReliefAttend];
}

- (void)addOrReliefAttend {
    if (isAttend) {
        //取消关注
        NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":_model.cardCode,@"attentType":@"FOLLOW"};
        [self.lotteryMan reliefAttent:dic];
    }
    else {
        //添加关注
        NSDictionary *dic = @{@"cardCode":self.curUser.cardCode,@"attentCardCode":_model.cardCode,@"attentType":@"FOLLOW"};
        [self.lotteryMan attentMember:dic];
    }
}


- (void) gotAttentMember:(NSString *)diction  errorMsg:(NSString *)msg{
    if (diction) {
        isAttend = YES;
        [self.btnGuanzhu setTitle:@"已关注" forState:UIControlStateNormal];
        self.btnGuanzhu.userInteractionEnabled = YES;
        [self showPromptText:@"添加关注成功" hideAfterDelay:1.0];
    }
}

- (void) gotReliefAttent:(NSString *)diction  errorMsg:(NSString *)msg{
    if (diction) {
        isAttend = NO;
        [self.btnGuanzhu setTitle:@"+关注" forState:UIControlStateNormal];
        self.btnGuanzhu.userInteractionEnabled = YES;
        [self showPromptText:@"取消关注成功" hideAfterDelay:1.0];
    }
}

@end
