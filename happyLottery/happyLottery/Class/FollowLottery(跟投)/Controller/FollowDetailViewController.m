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
#import "PayOrderViewController.h"

@interface FollowDetailViewController ()<SelectViewDelegate,LotteryManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnGuanzhu;
@property (weak, nonatomic) IBOutlet UIImageView *labPersonIcon;
@property (weak, nonatomic) IBOutlet UILabel *labPersonName;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnBeiSelect;
@property (weak, nonatomic) IBOutlet UILabel *labQitou;
@property (weak, nonatomic) IBOutlet UILabel *labGentou;
@property (weak, nonatomic) IBOutlet UILabel *labZigou;
@property (weak, nonatomic) IBOutlet UILabel *labYujihuibao;
@property (weak, nonatomic) IBOutlet UILabel *labLotteryName;
@property (weak, nonatomic) IBOutlet UILabel *labBetContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgLotteryIcon;
@property (weak, nonatomic) IBOutlet SelectView *wbSelectView;
@property (weak, nonatomic) IBOutlet UILabel *btnBetInfo;
@property(assign,nonatomic)NSInteger beiCount;

@end

@implementation FollowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIButton *btn in _btnBeiSelect) {
        if (btn.tag == 10) {
            btn.selected = YES;
        }
        [self setBtnBoard:btn];
    }
    
    self.lotteryMan.delegate = self;
    self.wbSelectView.beiShuLimit = 9999;
    self.wbSelectView.labContent.textColor = [UIColor whiteColor];
    self.beiCount = 10;
    [self updataTouzhuInfo];
    self.wbSelectView.delegate = self;
    [self.wbSelectView setTarget:self rightAction:@selector(actionAdd) leftAction:@selector(actionSub)];
    [self loadData];
}

-(void)loadData{
    [self.imgLotteryIcon setImage: [UIImage imageNamed:[_model lotteryIcon]]];
    self.labLotteryName.text = [BaseModel getLotteryByName:_model.lottery];
    self.labPersonIcon.layer.cornerRadius = self.labPersonIcon.mj_h/2;
    self.labPersonIcon.layer.masksToBounds = YES;
    self.labBetContent.text = [_model getContent];
    [self.labPersonIcon sd_setImageWithURL:[NSURL URLWithString:_model.headUrl]];
    self.labPersonName .text =  _model.nickName;
    self.labYujihuibao.text =  [NSString stringWithFormat:@"%.2f倍",[_model.pledge doubleValue]];
    self.labZigou.text =[NSString stringWithFormat:@"%@元",_model.betCost];
    self.labGentou.text =[NSString stringWithFormat:@"%@元",_model.totalFollowCost];
    self.labQitou.text =[NSString stringWithFormat:@"%@元",_model.minFollowCost];
    self.btnGuanzhu.layer.borderColor = TEXTGRAYOrange.CGColor;
    self.btnGuanzhu.layer.borderWidth = 1;
    
    
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
    if (self .curUser .isLogin == NO) {
        [self needLogin];
        return;
    }
    if (_beiCount == 0) {
        [self showPromptText:@"至少购买一倍" hideAfterDelay:1.9];
        return;
    }
    NSDictionary *paraDic= @{@"schemeNo":_model.schemeNo , @"cardCode":self.curUser.cardCode,@"multiple":@(_beiCount)};
    [self.lotteryMan followScheme:paraDic];
}
-(void)followScheme:(NSString *)result errorMsg:(NSString *)msg{
    if (result == nil) {
        [self showPromptText:msg hideAfterDelay:1.7];
        return;
    }
    PayOrderViewController *payVC = [[PayOrderViewController alloc]init];
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
    payVC.cashPayMemt = schemeCashModel;
    [self.navigationController pushViewController:payVC animated:YES];
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
    [self updataTouzhuInfo];
    _beiCount = sender.tag;
    _wbSelectView.labContent.text = [NSString stringWithFormat:@"%ld",_beiCount];
}

- (IBAction)actionGuanzhu:(id)sender {
}


@end
