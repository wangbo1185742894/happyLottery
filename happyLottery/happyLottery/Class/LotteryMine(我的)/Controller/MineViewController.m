//
//  MineViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//  我的

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "UIImage+RandomSize.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource,MemberManagerDelegate>{
    NSArray *listArray;
    UIButton *noticeBtn;
    UILabel *label;
}
@property (weak, nonatomic) IBOutlet UIButton *personSetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;//签到
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;//余额
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UILabel *integralLab;//积分
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;
@property (weak, nonatomic) IBOutlet UIButton *redPacketBtn;
@property (weak, nonatomic) IBOutlet UILabel *redPacketLab;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;//充值
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsBtn;//提现

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(strong, nonatomic) NSString * memberSubFunctionClass;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.memberMan.delegate = self;
 
     listArray = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"Mine" ofType: @"plist"]];
    [_tableview registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //_tableview.separatorColor = RGBCOLOR(240, 240, 240);
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [self noticeCenterSet];
   
    [_tableview reloadData];
}

//-(void)loginUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
//    NSLog(@"%@",userInfo);
//    
//}

- (void) notLogin{
    
    LoginViewController * loginVC = [[LoginViewController alloc]init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController: loginVC];
    navVC.navigationBar.barTintColor = SystemGreen;
    
    navVC.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18]};
    navVC.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:navVC animated:NO completion:nil];
}

-(void)noticeCenterSet{
    noticeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    noticeBtn.frame = CGRectMake(0, 0, 35, 30);
    label = [[UILabel alloc]init];
    label.frame =CGRectMake(25, 0,10, 10);
    label.layer.cornerRadius = label.bounds.size.width/2;
    label.layer.masksToBounds = YES;
    label.text = @"2";
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    [noticeBtn addSubview:label];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: noticeBtn];
    //[noticeBtn setTitle:@"发起合买" forState:UIControlStateNormal];
    [noticeBtn setImage:[UIImage imageNamed:@"news_ _bj_default@2x.png"] forState:UIControlStateNormal];
    [noticeBtn addTarget: self action: @selector(noticeBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

-(void)noticeBtnClick{
    
    
}

- (IBAction)personSetClick:(id)sender {
    
}

- (IBAction)loginBtnClick:(id)sender {

    [self notLogin];

}

- (IBAction)signInBtnClick:(id)sender {
    
}
- (IBAction)blanceBtnClick:(id)sender {
    
}
- (IBAction)integralBtnClick:(id)sender {
    
}
- (IBAction)redPacketBtnClick:(id)sender {
    
}
- (IBAction)rechargeBtnClick:(id)sender {
    
}
- (IBAction)withdrawalsBtnClick:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)registerUser:(NSDictionary *)userInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    NSLog(@"%@",userInfo);
}

#pragma UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* array = listArray[section];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *optionDic = listArray[indexPath.section][indexPath.row];
    
    cell.image.image = [UIImage reSizeImageName:optionDic[@"icon"] andMinWidth:18];
    
    //    cell.imageView.image = [UIImage imageNamed: optionDic[@"icon"]];
    
    cell.lable.text = optionDic[@"title"];
    cell.lable.font = [UIFont systemFontOfSize:15];
 
    
   
    
    
    
    //    _UITableViewCellSeparatorView
    
    //    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 13, 23, 2)];
    //    sep.backgroundColor = [UIColor redColor];
    
   
       
        
  
    
    
    return cell;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    tableView.backgroundColor = [UIColor clearColor];
    NSString *sectionTitle;
    if ([self respondsToSelector:@selector(tableView)]) {
        sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    }else{
        sectionTitle = nil;
    }
    
    if (sectionTitle == nil) {
        UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)] ;
        [sectionView setBackgroundColor:[UIColor clearColor]];
        return  sectionView;
    }
    
    UILabel * label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(15, 0, 320, 40);
    label.backgroundColor = [UIColor clearColor];
    label.font=[UIFont systemFontOfSize:15];
    label.text = sectionTitle;
    
    UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)] ;
    [sectionView setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:label];
    return sectionView;
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
    
    NSDictionary *optionDic = listArray[indexPath.section][indexPath.row];
    
    self.memberSubFunctionClass = optionDic[@"actionClassName"];
//    if ([optionDic[@"title"] isEqualToString:@"身份认证"] || [optionDic[@"title"] isEqualToString:@"密码修改"]) {
//       // [self showInputPopView];
//        return;
//    }else if ([optionDic[@"title"] isEqualToString:@"分享彩运宝"]){
//
//        //        self.navigationItem.rightBarButtonItem.enabled = NO;
//        [self showShareView];
//    }else{
//
//        UIViewController *vc = [[NSClassFromString(_memberSubFunctionClass) alloc] initWithNibName: _memberSubFunctionClass bundle: nil];
//        vc.hidesBottomBarWhenPushed = YES;
//
//        if ([vc isKindOfClass:[SetPayPwdViewController class]]) {
//            SetPayPwdViewController * setPayPwdVC = (SetPayPwdViewController *)vc;
//            setPayPwdVC.setPayPwdType = SetPayPwdTypeReset;
//        }
//
//        if ([vc isKindOfClass:[MyHemaiSchemeViewController class]]) {
//            MyHemaiSchemeViewController * hemaiVC = (MyHemaiSchemeViewController *)vc;
//            hemaiVC.isSponsor = YES;
//        }
//        [self.navigationController pushViewController: vc animated: YES];
//
//    }
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
