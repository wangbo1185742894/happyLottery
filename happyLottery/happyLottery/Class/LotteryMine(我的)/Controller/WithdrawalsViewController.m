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
#import "SetPayPWDViewController.h"
@interface WithdrawalsViewController ()<MemberManagerDelegate,WBInputPopViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
      NSString *pwd;
     WBInputPopView *passInput;
     NSMutableArray *listBankArray;
     BankCard *bankCard;
    
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
@property (weak, nonatomic) IBOutlet UIButton *cancelBUtton;
@property (weak, nonatomic) IBOutlet UIButton *addBankCard;

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
    self.retainLab.text =[NSString stringWithFormat:@"%.2f元", [self.curUser.totalBanlece doubleValue]] ;
    NSString *balanceStr = [NSString stringWithFormat:@"%.2f元", [self.curUser.balance doubleValue]];
    self.topUpsLab.text = balanceStr;
    self.nameLab.text = self.curUser.name;
    
}

-(void)withdrawSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self hideLoadingView];
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText: @"会员提现成功" hideAfterDelay: 1.7];
          [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getBankListClient];
}

- (IBAction)cancelButtonClick:(id)sender {
    self.backView.hidden=YES;
}

- (IBAction)addBankCardClick:(id)sender {

    FirstBankCardSetViewController * pcVC = [[FirstBankCardSetViewController alloc]init];
    [self.navigationController pushViewController:pcVC animated:YES];
}


- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getBankListSms:(NSDictionary *)bankInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    bankCard = nil;
    if ([msg isEqualToString:@"执行成功"]) {
     
        NSLog(@"%@",bankInfo);
        [listBankArray removeAllObjects];
       // [self showPromptText: @" 获取支持的银行卡成功" hideAfterDelay: 1.7];
        for (id object in bankInfo) {
            NSLog(@"listBankArray=%@", object);
            BankCard *bankCards = [[BankCard alloc]initWith:object];
            if ([bankCards.useDefault boolValue] == YES) {
                bankCard = bankCards;
                NSString *num =bankCard.bankNumber;
                NSString *num4 = [num substringFromIndex:num.length- 4 ];
                NSString *bank =  [NSString stringWithFormat:@"%@ (尾号%@)--%@",bankCard.bankName,num4,self.curUser.name];
                [self.bankBtn setTitle:bank forState:UIControlStateNormal];
            }
            
            [listBankArray addObject:bankCards];
        
        }
        
     
        
        if (listBankArray.count>0) {
            if (bankCard == nil) {
                
                bankCard = [listBankArray lastObject];
                bankCard.useDefault = @"1";
                NSString *num =bankCard.bankNumber;
                NSString *num4 = [num substringFromIndex:num.length- 4 ];
                NSString *bank =  [NSString stringWithFormat:@"%@ (尾号%@)--%@",bankCard.bankName,num4,self.curUser.name];
                [self.bankBtn setTitle:bank forState:UIControlStateNormal];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                  if (listBankArray.count==1) {
                      self.tvHeight.constant = 60;
                      self.tableView.scrollEnabled=NO;
                  }else{
                        self.tableView.scrollEnabled=YES;
                      self.tvHeight.constant = listBankArray.count*44+20 < KscreenHeight -200?listBankArray.count*44+20 : KscreenHeight -200;
                  }
             
            });

            self.commitBtn.enabled = YES;
        }else{
            self.tvHeight.constant = 0;
            self.tableView.hidden=YES;
            self.backView.hidden = YES;
            
            [self.bankBtn setTitle:@"请先添加银行卡" forState:UIControlStateNormal];
    
        }
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
     [passInput removeFromSuperview];
    if ([msg isEqualToString:@"执行成功"]) {
        //[self showPromptText:@"支付密码验证成功" hideAfterDelay:1.7];
        [self commitClient];
       
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
        return;
    }
        [self.memberMan getBankListSms:Info];
}

- (IBAction)bankBtnClick:(id)sender {
    if (listBankArray.count == 0) {
        FirstBankCardSetViewController * pcVC = [[FirstBankCardSetViewController alloc]init];
        [self.navigationController pushViewController:pcVC animated:YES];
    }else{
        self.tableView.hidden=NO;
        self.backView.hidden = NO;
        [self.tableView reloadData];
    }

  
}
- (IBAction)commitBtnClick:(id)sender {
    if (self.curUser.paypwdSetting== NO) {
        SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
        spvc.titleStr = @"设置支付密码";
        [self.navigationController pushViewController:spvc animated:YES];
        return;
        return;
    }
    [self showPayPopView];
}


- (void)showPayPopView{
    if ([self.withdrawTextField.text isEqualToString:@"" ]) {
        [self showPromptText: @"请输入取现金额" hideAfterDelay: 2.7];
        return;
    }
    NSString *money = [NSString stringWithFormat:@"%.2f",[self.withdrawTextField.text doubleValue]];
    if ([money isEqualToString:@"0.00"]) {
        [self showPromptText: @"输入有效金额" hideAfterDelay: 2.7];
        return;
    }
    double text =[self.withdrawTextField.text doubleValue];
    if (text>[self.curUser.balance doubleValue]) {
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
       return;
    }
        [self showLoadingText:@"正在提交订单"];
        [self.memberMan withdrawSms:withdrawInfo];
}

#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (listBankArray.count > 0) {
        return listBankArray.count;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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

    NSString *num =bankCards.bankNumber;
    NSString *num4 = [num substringFromIndex:num.length- 4 ];
    NSString *bank =  [NSString stringWithFormat:@"  %@ (尾号%@)--%@",bankCards.bankName,num4,self.curUser.name];
    cell.textLabel.font=[UIFont systemFontOfSize:18]; 
    cell.textLabel.text =bank;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
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
    NSString *num =bankCard.bankNumber;
    NSString *num4 = [num substringFromIndex:num.length- 4 ];
   NSString *bank =  [NSString stringWithFormat:@"%@ (尾号%@)--%@",bankCard.bankName,num4,self.curUser.name];
    [self.bankBtn setTitle:bank forState:UIControlStateNormal];
}


#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
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
    if (textField == self.withdrawTextField ) {
        if (textField.text.length + string.length >15) {
            [self showPromptText: @"金额不能超过15位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
    
    NSString * regex;
    regex = @"^[0-9.]";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    if (isMatch) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,100}(([.]\\d{0,2})?)))?";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL isMatch1 = [pred1 evaluateWithObject:[NSString stringWithFormat:@"%@%@",textField.text,string]];
        
        return isMatch1;
    }else{
        
        return NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)findPayPwd{
    [self forgetPayPwd];
}


@end
