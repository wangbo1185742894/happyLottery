//
//  RedPackageView.m
//  happyLottery
//
//  Created by LYJ on 2018/9/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "RedPackageView.h"

#define LeftTextFrame     CGRectMake(0, 0, 90, 50)

#define RightTextFrame    CGRectMake(0, 0, 25, 50)

@interface RedPackageView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *alertView;

@property (weak, nonatomic) IBOutlet UILabel *redLab;

@property (weak, nonatomic) IBOutlet UISwitch *switchView;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UITextField *yuanTextField;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UILabel *countMoneyLab;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyNoticeLab;
@property (weak, nonatomic) IBOutlet UILabel *countNoticeLab;

@end

@implementation RedPackageView{
    NSInteger count;  //红包个数
    NSInteger yuan; //单个价格
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"RedPackageView" owner:nil
                                           options:nil] lastObject];
    }
    self.frame = frame;
    self.backgroundColor = RGBACOLOR(37, 38, 38, 0.5);
    [self initUI];
    return self;
}

//关闭红包设置
- (void)initUI {
    self.closeBtn.hidden = YES;
    self.switchView.on = NO;
    self.alertView.layer.masksToBounds = YES;
    self.alertView.layer.cornerRadius = 12;
    self.redLab.text = @"我要塞红包";
    self.detailLab.text = @"将红包塞入发单方案，吸引更多人跟单~";
    self.detailLab.textColor = RGBCOLOR(254, 165, 19);
    [self.okBtn setTitle:@"不了，谢谢" forState:UIControlStateNormal];
    [self.okBtn setTitleColor:RGBCOLOR(113, 215, 179) forState:UIControlStateNormal];
    [self.okBtn setBackgroundColor:[UIColor clearColor]];
    self.inputViewHeight.constant = 0;
    self.inputView.hidden = YES;
}

//打开红包设置
- (void)setOpenViewUI {
    self.closeBtn.hidden = NO;
    self.redLab.text = @"塞入红包";
    self.detailLab.text = [NSString stringWithFormat:@"余额：%@元",self.totalBanlece];
    self.detailLab.textColor = SystemLightGray;
    [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okBtn setBackgroundColor:RGBCOLOR(18, 199, 146)];
    self.inputViewHeight.constant = 195;
    self.inputView.hidden = NO;
    self.yuanTextField.text = @"1";
    self.countTextField.text = @"5";
    self.yuanTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.countTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.yuanTextField.delegate = self;
    self.countTextField.delegate = self;

    UILabel *label = [self createLabWithText:@"单个红包" andFrame:LeftTextFrame andTextAlignment:NSTextAlignmentCenter];
    self.yuanTextField.leftViewMode = UITextFieldViewModeAlways;
    self.yuanTextField.leftView = label;
   
    UILabel *labelRight = [self createLabWithText:@"元" andFrame:RightTextFrame andTextAlignment:NSTextAlignmentLeft];
    self.yuanTextField.rightViewMode = UITextFieldViewModeAlways;
    self.yuanTextField.rightView = labelRight;
    
    UILabel *labelCount = [self createLabWithText:@"红包个数" andFrame:LeftTextFrame andTextAlignment:NSTextAlignmentCenter];
    self.countTextField.leftViewMode = UITextFieldViewModeAlways;
    self.countTextField.leftView = labelCount;
    
    UILabel *labelCountRight = [self createLabWithText:@"个" andFrame:RightTextFrame andTextAlignment:NSTextAlignmentLeft];
    self.countTextField.rightViewMode = UITextFieldViewModeAlways;
    self.countTextField.rightView = labelCountRight;
    [self upDateCountMoney];
    
    self.moneyNoticeLab.hidden = YES;
    self.countNoticeLab.hidden = YES;
}

//键盘关闭更新数据
- (void)upDateCountMoney{
    count = [self.countTextField.text integerValue];
    yuan = [self.yuanTextField.text integerValue];
    self.countMoneyLab.text = [NSString stringWithFormat:@"￥ %ld",count * yuan];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger strLength = textField.text.length - range.length + string.length;
    if (strLength > 4) {
        return NO;
    }
    if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text integerValue]<1 && textField == self.yuanTextField) {
        textField.text = @"1";
        self.moneyNoticeLab.hidden = NO;
    } else {
        self.moneyNoticeLab.hidden = YES;
    }
    if ([textField.text integerValue]<5 && textField == self.countTextField) {
        textField.text = @"5";
        self.countNoticeLab.text = @"红包个数至少5个";
        self.countNoticeLab.hidden = NO;
    } else{
        self.countNoticeLab.hidden = YES;
    }
    [self upDateCountMoney];
}

- (UILabel *)createLabWithText:(NSString *)text andFrame:(CGRect)frame andTextAlignment:(NSTextAlignment) alignment{
    UILabel *lab = [[UILabel alloc]initWithFrame:frame];
    lab.text = text;
    lab.textAlignment = alignment;
    lab.textColor = SystemLightGray;
    return lab;
}

- (IBAction)actionToClose:(id)sender {
    [self closeView];
}

- (void)closeView {
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
}

- (IBAction)actionSwitch:(UISwitch *)sender {
    if (sender.on) {
        [self setOpenViewUI];
    } else {
        [self initUI];
    }
}

- (IBAction)actionOkBtn:(id)sender {
    if (self.switchView.on) { //支付红包金额 并发单
        //验证金额
        if ([self.totalBanlece integerValue] < count * yuan) {
            self.countNoticeLab.text = @"余额不足，请重新设置";
            self.countNoticeLab.hidden = NO;
            self.countTextField.text = @"5";
            self.yuanTextField.text = @"1";
            [self upDateCountMoney];
            return;
        }
        self.countNoticeLab.hidden = YES;
        self.moneyNoticeLab.hidden = YES;
        [self closeView];
        [self.delegate payForRedPackage:[NSString stringWithFormat:@"%ld",count] andMoney:[NSString stringWithFormat:@"%ld",yuan]];
    }else { //发单
        [self closeView];
        [self.delegate initiateFollowScheme];
    }
}

@end
