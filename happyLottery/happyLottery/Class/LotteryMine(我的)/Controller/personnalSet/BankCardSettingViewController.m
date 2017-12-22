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

@interface BankCardSettingViewController  ()<UITableViewDelegate, UITableViewDataSource,MemberManagerDelegate>{
        NSArray *listArray;
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
}
- (IBAction)addBankCardClick:(id)sender {
    FirstBankCardSetViewController *fvc = [[FirstBankCardSetViewController alloc]init];
    fvc.titleStr=@"添加银行卡";
    [self.navigationController pushViewController:fvc animated:YES];
}

#pragma UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return listArray.count;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
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
