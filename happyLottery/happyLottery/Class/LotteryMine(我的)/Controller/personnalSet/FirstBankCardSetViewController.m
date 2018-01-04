//
//  FirstBankCardSetViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//首次设置银行卡

#import "FirstBankCardSetViewController.h"
#import "WBInputPopView.h"
#import "BankCard.h"

@interface FirstBankCardSetViewController ()<MemberManagerDelegate,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{
    NSMutableArray *listBankArray;
    BankCard *bankCard;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *getBankBtn;
@property (weak, nonatomic) IBOutlet UITextField *bankCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@end

@implementation FirstBankCardSetViewController
@synthesize titleStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = titleStr;
    self.memberMan.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _nameTextField.delegate = self;
    _bankCodeTextField.delegate = self;
    if ([self isIphoneX]) {
        self.bottom.constant = 34;
        self.top.constant = 88;
          self.backViewBottom.constant = 34;
    }
    listBankArray = [[NSMutableArray alloc]init];
    [self.memberMan getSupportBankSms];
}
- (IBAction)getBankClick:(id)sender {
    self.backView.hidden = NO;
    self.tableView.hidden = NO;
//    if (listBankArray.count > 0) {
//       self.tableViewHeight.constant = listBankArray.count *40;
//    }
   
    [self.tableView reloadData];
}

- (IBAction)commitBtnClick:(id)sender {
    if (_nameTextField.text.length ==0 || _nameTextField.text==nil) {
        [self showPromptText: @"请输入真实姓名" hideAfterDelay: 1.7];
        return;
    }
    
    else if (_bankCodeTextField.text.length < 16) {
        [self showPromptText: @"请输入正确银行卡号" hideAfterDelay: 1.7];
        return;
    }else{
        [self bindNameClient];
        [self addBankCardClient];
    }
    
}

-(void)bindNameSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        //[self showPromptText: @"实名认证成功" hideAfterDelay: 1.7];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

-(void)addBankCardSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText: @"添加银行卡成功" hideAfterDelay: 1.7];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

-(void)getSupportBankSms:(NSDictionary *)supportBankInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
       // NSLog(@"%@",supportBankInfo);
    if ([msg isEqualToString:@"执行成功"]) {
      //  [self showPromptText: @"获得支持的银行成功" hideAfterDelay: 1.7];
       
        for (id object in supportBankInfo) {
            NSLog(@"listBankArray=%@", object);
           BankCard *bankCard = [[BankCard alloc]initWith:object];
            [listBankArray addObject:bankCard];
        }
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)bindNameClient{
    
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *name = self.nameTextField.text;
        
        Info = @{@"cardCode":cardCode,
                         @"name":name
                         };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan bindNameSms:Info];
    }
    
}

-(void)addBankCardClient{
    
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *bankNumber=self.bankCodeTextField.text ;
        NSString * str = [bankNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        Info = @{@"cardCode":cardCode,
                         @"bankNumber":str,
                         @"bankName": bankCard.bankName,
                  @"bankUserName": self.nameTextField.text,
                  @"bankEposit": bankCard.bankShortName
                         };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan addBankCardSms:Info];
    }
    
}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text=@"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.nameTextField) {
        if (![self isValidateName:self.nameTextField.text]) {
            [self showPromptText: @"请输入真实姓名" hideAfterDelay: 1.7];
            self.nameTextField.text= @"";
            return;
        }
        
    }
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
    if (textField == self.nameTextField ) {
        regex = @"^[A-Za-z]";
        
    }else{
        regex = @"^[0-9]";
        
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (textField == self.nameTextField ) {
        if (str.length >15) {
            [self showPromptText: @"姓名不能超过15位" hideAfterDelay: 1.7];
            return NO;
        }
    }
    
    if (textField == self.bankCodeTextField ) {
        // 四位加一个空格
        if ([string isEqualToString:@""]) {
            
            // 删除字符
            if ((textField.text.length - 2) % 5 == 0) {
                
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            
            return YES;
        } else {
            if (textField.text.length % 5 == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
    
        
      
        if (str.length >24) {
            [self showPromptText: @"银行卡号码不能超过19位" hideAfterDelay: 1.7];
            return NO;
        }
          return YES;
    }
    
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isMatch = [pred evaluateWithObject:string];
    return YES;
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
    cell.textLabel.text =bankCards.bankName;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    //    cell.lable.text = optionDic[@"title"];
    //    cell.lable.font = [UIFont systemFontOfSize:15];
    
    
    
    
    
    
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
    self.getBankBtn.titleLabel.text = bankCard.bankName;
    self.tableView.hidden=YES;
    self.backView.hidden = YES;
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
