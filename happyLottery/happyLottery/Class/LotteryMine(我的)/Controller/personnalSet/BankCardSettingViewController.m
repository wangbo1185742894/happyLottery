//
//  BankCardSettingViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//已有银行卡的情况下设置添加银行卡

#import "BankCardSettingViewController.h"
#import "BankCardSetTableViewCell.h"
#import "FirstBankCardSetViewController.h"
#import "AESUtility.h"
#import "WBInputPopView.h"
#import "BankCard.h"
#import "WBInputPopView.h"
#import "SetPayPWDViewController.h"

@interface BankCardSettingViewController  ()<UITableViewDelegate, UITableViewDataSource,MemberManagerDelegate,WBInputPopViewDelegate>{
        NSMutableArray *listBankArray;
        BankCard *bankCard;
        WBInputPopView *passInput;
}


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *addBankCardBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tvHeight;


@end

@implementation BankCardSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡设置";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.memberMan.delegate =self;
    listBankArray = [[NSMutableArray alloc]init];
    self.name.text = self.curUser.name;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getBankListClient];
}

- (IBAction)addBankCardClick:(id)sender {
    FirstBankCardSetViewController *fvc = [[FirstBankCardSetViewController alloc]init];
    fvc.titleStr=@"添加银行卡";
    [self.navigationController pushViewController:fvc animated:YES];
}

#pragma MemberManagerDelegate


-(void)getBankListSms:(NSDictionary *)bankInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
         NSLog(@"%@",bankInfo);
        
        //[self showPromptText: @"获得会员已绑定的银行卡列表成功" hideAfterDelay: 1.7];
        [listBankArray removeAllObjects];
        if (bankInfo !=nil) {
            for (id object in bankInfo) {
                NSLog(@"listBankArray=%@", object);
                BankCard *bankCards = [[BankCard alloc]initWith:object];
                [listBankArray addObject:bankCards];
            }
            if (listBankArray.count>0) {
                
                self.tvHeight.constant = listBankArray.count*82;
                
            }else{
                self.tvHeight.constant = 0;
            }
            [self.tableView reloadData];
        }
       
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)unBindBankCardSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [passInput removeFromSuperview];
    if ([msg isEqualToString:@"执行成功"]) {
        self.curUser.bankBinding = 0;
        [self showPromptText: @"解绑银行卡成功" hideAfterDelay: 1.7];
        [self getBankListClient];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}


-(void)validatePaypwdSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
      [passInput removeFromSuperview];
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"支付密码验证成功" hideAfterDelay:1.7];
        [self unBindBankCardClient];
      
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
        
    }
}

- (void)showPayPopView{
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
            [self showPromptText:@"请输入支付密码" hideAfterDelay:1.7];
            return;
        }
        
        NSDictionary *cardInfo= @{@"cardCode":self.curUser.cardCode,
                                  @"payPwd":[AESUtility encryptStr:text]};
        [self.memberMan validatePaypwdSms:cardInfo];
    }];
    
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

-(void)unBindBankCardClient{
      NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *paypwd =@"123456";
        
        Info = @{@"cardCode":cardCode,
                 @"bankNumber":bankCard.bankNumber,
                 @"payPwd": [AESUtility encryptStr: paypwd]
                 };
        
    } @catch (NSException *exception) {
        return;
    }
        [self.memberMan unBindBankCardSms:Info];

}

-(void)btnAction:(UIButton *)btn{
    int n = (int)btn.tag ;
    bankCard = listBankArray[n];
    
    if(self.curUser.paypwdSetting == NO) {
        SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
        spvc.titleStr = @"设置支付密码";
        [self.navigationController pushViewController:spvc animated:YES];
        return;
    }else{
        [self showPayPopView];
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
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    BankCardSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BankCardSetTableViewCell" owner:self options:nil] lastObject];
    }
  
    BankCard *bk = listBankArray[indexPath.row];
    
    cell.bankName.text = bk.bankName;
    cell.bankNum.text = bk.tempBankNumber;
    cell.unBindBtn.tag = indexPath.row;
    [cell.unBindBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
