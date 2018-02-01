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
    NSString *name;
    BOOL _canedit;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)name:UITextFieldTextDidChangeNotification object:self.nameTextField];

    if (self.popTitle != nil) {
        [self showPromptText:self.popTitle hideAfterDelay:2.0];
    }
    if (titleStr == nil) {
        self.title = @"添加银行卡";
    }else{
        self.title = titleStr;
    }
    
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
    name= self.curUser.name;
    if ([name isEqualToString:@""]||name ==nil) {
        self.nameTextField.enabled=YES;
    }else{
        self.nameTextField.enabled=NO;
        self.nameTextField.text=name;
    }
    [self.memberMan getSupportBankSms];
}

- (IBAction)getBankClick:(id)sender {
  
//    if (listBankArray.count > 0) {
//       self.tableViewHeight.constant = listBankArray.count *40;
//    }
  [_nameTextField resignFirstResponder];
   // [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.backView.hidden = NO;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}

- (IBAction)commitBtnClick:(id)sender {
 
    if ([name isEqualToString:@""]||name ==nil) {
      
        if (self.nameTextField.text.length > 15) {
            [self showPromptText:@"姓名不能超过15位" hideAfterDelay:2];
            return;
        }
        if (_nameTextField.text.length ==0 || _nameTextField.text==nil) {
            [self showPromptText: @"请输入真实姓名" hideAfterDelay: 1.7];
            return;
        }
        if (self.curUser.name == nil || self.curUser.name.length == 0) {
            
            [self bindNameClient];
        }
    }
    
      NSString *bankname = self.getBankBtn.titleLabel.text;
   if ([bankname isEqualToString:@"请选择开户银行"]) {
        [self showPromptText: @"请选择开户银行" hideAfterDelay: 1.7];
        return;
    }
    
    else if (_bankCodeTextField.text.length < 16) {
        [self showPromptText: @"请输入正确银行卡号" hideAfterDelay: 1.7];
        return;
    }else{
     
        [self addBankCardClient];
    }
    
}

-(void)bindNameSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText: @"实名认证成功" hideAfterDelay: 1.7];
        self.curUser.name =_nameTextField.text;
        _nameTextField.enabled = NO;
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)addBankCardSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        self.curUser.bankBinding =1;
        [self showPromptText: @"添加银行卡成功" hideAfterDelay: 1.7];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

-(void)getSupportBankSms:(NSDictionary *)supportBankInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
       // NSLog(@"%@",supportBankInfo);
    if ([msg isEqualToString:@"执行成功"]) {
      //  [self showPromptText: @"获得支持的银行成功" hideAfterDelay: 1.7];
        [listBankArray removeAllObjects];
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
       return;
    }
        [self.memberMan bindNameSms:Info];

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
        return;
    }
        [self.memberMan addBankCardSms:Info];

}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.nameTextField) {
        if (self.nameTextField.text.length > 15) {
            [self showPromptText:@"姓名不能超过15位" hideAfterDelay:2];
            return;
        }
        
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    

    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (textField == self.nameTextField ) {
        if ([textField isFirstResponder]) {
            
            if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
                return NO;
            }
            
            //判断键盘是不是九宫格键盘
            if ([self isNineKeyBoard:string] ){
                return YES;
            }else{
                if ([self hasEmoji:string] || [self stringContainsEmoji:string]){
                    return NO;
                }
            }
        }
        if (textField == self.nameTextField) {
            if (![self isValidateRealName:string]) {
                return NO;
            }
        }
    }
    
    if (textField == self.bankCodeTextField ) {
        
        NSString * regex;
        
        
        regex = @"^[0-9]";
        
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch = [pred evaluateWithObject:string];
        if (isMatch == NO) {
            return NO;
        }
        
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
            
            return NO;
        }
          return YES;
    }
    
   
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
    cell.textLabel.text =[NSString stringWithFormat:@"  %@ ", bankCards.bankName];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    
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
    [self.getBankBtn setTitle:bankCard.bankName forState:UIControlStateNormal];
    self.backView.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionCancel:(UIButton *)sender {
    self.backView.hidden = YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        int chNum =0;
        for (int i=0; i<toBeString.length; ++i)
        {
            NSRange range = NSMakeRange(i, 1);
            NSString *subString = [toBeString substringWithRange:range];
            const char *cString = [subString UTF8String];
            if (cString == NULL) {
                _canedit = NO;
            }else{
                if (strlen(cString) == 3)
                {
                    NSLog(@"汉字:%@",subString);
                    chNum ++;
                }
            }
          
        }
        
        if (chNum>=9) {
            _canedit =NO;
        }
        
        if (!position) {
            if (toBeString.length > 10) {
                textField.text = [toBeString substringToIndex:10];
                _canedit =YES;
            }
        }
        
        else{
        }
    }
    
    else{
        if (toBeString.length > 20) {
            textField.text = [toBeString substringToIndex:20];
            _canedit =NO;
        }
    }
}


@end
