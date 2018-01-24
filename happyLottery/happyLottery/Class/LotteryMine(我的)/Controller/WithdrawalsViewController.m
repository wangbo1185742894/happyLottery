//
//  WithdrawalsViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "WithdrawalsViewController.h"
#import "AESUtility.h"
#import "WBInputPopView.h"
#import "BankCard.h"
#import "FirstBankCardSetViewController.h"

@interface WithdrawalsViewController ()<MemberManagerDelegate,WBInputPopViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
      NSString *pwd;
     WBInputPopView *passInput;
     NSMutableArray *listBankArray;
     BankCard *bankCard;
    long long balance;
}
@property (weak, nonatomic) IBOutlet UILabel *retainLab;
@property (weak, nonatomic) IBOutlet UILabel *topUpsLab;
@property (weak, nonatomic) IBOutlet UITextField *withdrawTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewBottom;

@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
         self.backViewBottom.constant = 34;
    }
    self.withdrawTextField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    passInput.delegate = self;
    listBankArray = [[NSMutableArray alloc]init];
    self.memberMan.delegate = self;
    balance = [self.curUser.balance longLongValue];
    long long notCash = [self.curUser.notCash longLongValue];
    long long sendBalance = [self.curUser.sendBalance longLongValue];
    long long total = balance+notCash+sendBalance;
    NSString *totalStr = [NSString stringWithFormat:@"%lld元", total];
    self.retainLab.text = totalStr;
    NSString *balanceStr = [NSString stringWithFormat:@"%lld元", balance];
    self.topUpsLab.text = balanceStr;
    self.nameLab.text = self.curUser.name;
}

-(void)withdrawSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText: @"会员提现成功" hideAfterDelay: 1.7];
          [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getBankListSms:(NSDictionary *)bankInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
     
        NSLog(@"%@",bankInfo);
        [listBankArray removeAllObjects];
       // [self showPromptText: @" 获取支持的银行卡成功" hideAfterDelay: 1.7];
        for (id object in bankInfo) {
            NSLog(@"listBankArray=%@", object);
            BankCard *bankCards = [[BankCard alloc]initWith:object];
            [listBankArray addObject:bankCards];
        }
        if (listBankArray.count>0) {
            self.tableView.hidden=NO;
            self.backView.hidden = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.tvHeight.constant = listBankArray.count*40;
            });
            [self.tableView reloadData];
            self.commitBtn.enabled = YES;
        }else{
            self.tvHeight.constant = 0;
            self.tableView.hidden=YES;
            self.backView.hidden = YES;
            //self.bankBtn.titleLabel.text=@"请前往银行卡页面添加银行卡";
            [self.bankBtn setTitle:@"请前往银行卡页面添加银行卡" forState:UIControlStateNormal];
            FirstBankCardSetViewController * pcVC = [[FirstBankCardSetViewController alloc]init];
            [self.navigationController pushViewController:pcVC animated:YES];
        }
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
        //[self showPromptText:@"支付密码验证成功" hideAfterDelay:1.7];
        [self commitClient];
        [passInput removeFromSuperview];
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

-(void)getBankListClient{
    
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        
        Info = @{@"cardCode":cardCode
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan getBankListSms:Info];
    }
    
}

- (IBAction)bankBtnClick:(id)sender {
    [self getBankListClient];
  
}
- (IBAction)commitBtnClick:(id)sender {
    [self showPayPopView];
}


- (void)showPayPopView{
    if ([self.withdrawTextField.text isEqualToString:@"" ]) {
        [self showPromptText: @"请输入取现金额" hideAfterDelay: 2.7];
        return;
    }
    long long text =[self.withdrawTextField.text longLongValue];
    if (text>balance) {
        [self showPromptText: @"取现金额不能大于可用余额！" hideAfterDelay: 3.7];
        self.withdrawTextField.text=@"";
        return;
    }
    NSString *bankname=self.bankBtn.titleLabel.text;
    if ([bankname isEqualToString:@"请选择银行卡号"]) {
        [self showPromptText: @"请选择银行卡号" hideAfterDelay: 1.7];
        return;
    }
    if (nil == passInput) {
        //        popInputView = [[PopInputView alloc] initWithFrame:self.navigationController.view.bounds];
        //        popInputView.delegate = self;
        //        popInputView.popViewResource = @"zhifu";
        
        passInput = [[WBInputPopView alloc]init];
        passInput.delegate = self;
        passInput.labTitle.text = @"请输入支付密码";
    }
    //    [popInputView showInView:self.navigationController.view withTitle:TextComfirmPayPwdForPay tfPlaceHolder:TextPasswrodRule];
    [self.view addSubview:passInput];
    passInput.delegate = self;
    [passInput.txtInput becomeFirstResponder];
    [passInput createBlock:^(NSString *text) {
        
        if (nil == passInput) {
            [self showPromptText:@"请输入支付密码" hideAfterDelay:2.7];
            return;
        }
        pwd =text;
        NSDictionary *cardInfo= @{@"cardCode":self.curUser.cardCode,
                                  @"payPwd":[AESUtility encryptStr:pwd]};
        [self.memberMan validatePaypwdSms:cardInfo];
    }];
    
}



-(void)commitClient{
  
    NSDictionary *withdrawInfo;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *paypwd = self.withdrawTextField.text;
        
        withdrawInfo = @{@"cardCode":cardCode,
                         @"payPwd": [AESUtility encryptStr: pwd],
                         @"bankId":bankCard._id,
                         @"amounts":self.withdrawTextField.text,
                         };
        
    } @catch (NSException *exception) {
        withdrawInfo = nil;
    } @finally {
        [self.memberMan withdrawSms:withdrawInfo];
    }
}

#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (listBankArray.count > 0) {
        return listBankArray.count;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
        
    }
    BankCard* bankCards = listBankArray[indexPath.row];
    cell.textLabel.text =bankCards.bankNumber;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}


#pragma UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0;
    //    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    bankCard= listBankArray[indexPath.row];
    //self.bankBtn.titleLabel.text = bankCard.bankNumber;
    self.tableView.hidden=YES;
    self.backView.hidden = YES;
    [self.bankBtn setTitle:bankCard.bankNumber forState:UIControlStateNormal];
}


#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text=@"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  
    [self.view resignFirstResponder];
}

#pragma mark Regex
//姓名一般只允许包含中文或英文字母
- (BOOL)isValidateName:(NSString *)name
{
    //NSString *nameRegex = @"^[\u4E00-\u9FA5A-Za-z]{2,16}";
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",REG_NICKNAME_STR];
    
    return [namePredicate evaluateWithObject:name];
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    NSString * regex;
    if (textField == self.withdrawTextField ){
        regex = @"^[0-9]";
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (textField == self.withdrawTextField ) {
        if (str.length >15) {
            [self showPromptText: @"金额不能超过15位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
    
    
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:string];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
