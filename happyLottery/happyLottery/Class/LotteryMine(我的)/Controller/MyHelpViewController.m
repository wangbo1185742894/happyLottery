//
//  MyHelpViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//  帮助

#import "MyHelpViewController.h"
#import "CouponGuidViewController.h"
#import "GetIntegralViewController.h"
#import "FootBallPlayViewController.h"
#import "QuestionsViewController.h"
#import "FunctionsViewController.h"
#import "IntegeralChangeViewController.h"
#import "LotteryInstructionDetailViewController.h"
#import "WebViewController.h"

#define KTableViewCell @"TableViewCell"

@interface MyHelpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (strong,nonatomic) NSArray <NSDictionary *> *listArray;

@end

@implementation MyHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    self.viewControllerNo = @"A207";
    if ([self isIphoneX]) {
        self.top.constant = 24;
    }
//    self.height.constant = 770;
    self.height.constant = 815;
    [self setTableView];
    self.listArray = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"PlayIntroduce" ofType: @"plist"]];
    
}


-(void)setTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 45;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }
    if (section == 1) {
        return 2;
    }
    return 3;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, KscreenWidth, 46)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *labeltiao = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
    labeltiao.backgroundColor = RGBCOLOR(250, 250, 250);
    [view addSubview:labeltiao];
    NSString *imageName;
    NSString *labelText;
    if (section == 0) {
        imageName = @"integralhelp.png";
        labelText = @"玩法介绍";
    } else if (section == 1) {
        imageName = @"lotteryhelp.png";
        labelText = @"积分规则";
    } else {
        imageName = @"assisthelp.png";
        labelText = @"使用帮助";
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 16, 16)];
    [imageView setImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 100, 36)];
    label.text = labelText;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = SystemGreen;
    [view addSubview:imageView];
    [view addSubview:label];
    return view;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 46;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 84;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 52)];
        UIImageView *iamge = [[UIImageView alloc]initWithFrame:CGRectMake((KscreenWidth-217)/2, 34, 17, 17)];
        [iamge setImage:[UIImage imageNamed:@"logo_assist.png"]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((KscreenWidth-217)/2+20, 35, 200, 14)];
        label.text = @"客服电话 400-600-5558";
        label.textColor = RGBCOLOR(25, 26, 26);
        label.userInteractionEnabled=YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTelMe)];
        [label addGestureRecognizer:labelTapGestureRecognizer];
        [view addSubview:iamge];
        [view addSubview:label];
        return view;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:KTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic;
    if (indexPath.section == 0) {
        dic = self.listArray[indexPath.row];
    } else if (indexPath.section == 1){
        dic = self.listArray[indexPath.row+8];
    } else {
        dic = self.listArray[indexPath.row+10];
    }
    cell.textLabel.text = dic[@"Name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
    if (indexPath.section == 0) {
        dic = self.listArray[indexPath.row];
    } else if (indexPath.section == 1){
        dic = self.listArray[indexPath.row+8];
    } else {
        dic = self.listArray[indexPath.row+10];
    }
    if (dic[@"controller"]!=nil) {
        NSString *functionClass = dic[@"controller"];
        BaseViewController *vc = [[NSClassFromString(functionClass) alloc] initWithNibName: functionClass bundle: nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: vc animated: YES];
    }
    else if(dic[@"html"]!=nil){
        WebViewController *webVC = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
        webVC.type = @"html";
        webVC.title = dic[@"title"];
        webVC.htmlName = dic[@"html"];
        [self.navigationController pushViewController:webVC animated:YES];
    }else{
        LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
        detailVC.lotteryDetailDic = dic;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: detailVC animated: YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
