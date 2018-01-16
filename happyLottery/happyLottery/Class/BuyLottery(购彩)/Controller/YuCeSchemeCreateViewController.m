//
//  YuCeSchemeCreateViewController.m
//  Lottery
//
//  Created by onlymac on 2017/10/12.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "YuCeSchemeCreateViewController.h"
#import "YuCeSchemeCreateCell.h"
#import "YuceSchemeDetailViewController.h"
#import "YuCeLiShiZhanJViewController.h"
#import "YuCeScheme.h"
#import "jcBetContent.h"
#import "JCFATransaction.h"
#import "LoginViewController.h"

@interface YuCeSchemeCreateViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,YuCeSchemeCreateCellDelegate>
{
    NSInteger page;
    __weak IBOutlet UILabel *labBottom;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerWidth;
@property (weak, nonatomic) IBOutlet UITableView *SchemeCreateTableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectMoneyBtn;
@property (weak, nonatomic) IBOutlet UIView *viewContentItem;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectBetBtn;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *flagLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectXuqiuBtn;
@property (copy, nonatomic) NSString *earningsType;
@property (copy, nonatomic) NSString *orderName;
@property (copy, nonatomic) NSString *moneyStr;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (copy, nonatomic) NSString *xuQiuBtnTag;
@property (strong,nonatomic)JCFATransaction * transaction;


- (IBAction)actionMoneyBtn:(UIButton *)sender;
- (IBAction)actionBetBtn:(UIButton *)sender;
- (IBAction)actionCreateScheme:(UIButton *)sender;
- (IBAction)actionXuQiuBtn:(UIButton *)sender;
@end

@implementation YuCeSchemeCreateViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A016";
    page = 0;
    
    self.transaction = [[JCFATransaction alloc]init];
    self.transaction.beiTou = 1;
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.title = @"竞彩方案";
    [self.SchemeCreateTableView registerNib:[UINib nibWithNibName:@"YuCeSchemeCreateCell" bundle:nil] forCellReuseIdentifier:@"YuCeSchemeCreateCell"];
    
    self.SchemeCreateTableView.delegate = self;
    self.SchemeCreateTableView.dataSource = self;
    
    
    
    
    
    UIButton *btn =  self.selectMoneyBtn[0];
    btn.selected = YES;
    UIButton *btn1 = self.selectBetBtn[0];
    btn1.selected = YES;
    UIButton *btn2 = self.selectXuqiuBtn[0];
    btn2.selected = YES;
    self.SchemeCreateTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.earningsType = @"STEADY";
    self.orderName = @"earnings";
    self.moneyStr = @"10元";
    self.xuQiuBtnTag = @"300";
    [self updateBtnState];
    [self setRightBtn];
    [self setLotteryManager];
    [self loadData];
    
//    [self setTableViewLoadRefresh];

}

-(void)setLotteryManager{
    self.curUser = [GlobalInstance instance].curUser;
    self.lotteryMan.delegate = self;
}

- (void)setRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:0];
    rightBtn.frame = CGRectMake(0, 0,30, 44);
    [rightBtn setImage:[UIImage imageNamed:@"history_icon_default_fangan"] forState:0];
    [rightBtn setImage:[UIImage imageNamed:@"history_icon_pressed_fangan"] forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightAction{
    NSLog(@"点击了right按钮");
    YuCeLiShiZhanJViewController *LiShiZhanJVC = [[YuCeLiShiZhanJViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:LiShiZhanJVC animated:YES];
}


//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark -- tableViewDelegateMethods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YuCeSchemeCreateCell *cell = [YuCeSchemeCreateCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.monery = self.moneyStr;
    [cell refreshData:self.dataArr[indexPath.row] xuQiuBtn:self.xuQiuBtnTag];
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YuceSchemeDetailViewController *detailVC = [[YuceSchemeDetailViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    detailVC.scheme = self.dataArr[indexPath.row];
    detailVC.dataArray = self.dataArr;
    detailVC.money = self.moneyStr;
    detailVC.index = indexPath.row;
    detailVC.xuQiuBtnTag = self.xuQiuBtnTag;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionMoneyBtn:(UIButton *)sender {
    for (UIButton *btn in self.selectMoneyBtn) {
        btn.selected = NO;
    }
   UIButton * btn1 = self.selectMoneyBtn[sender.tag - 100];
    btn1.selected = YES;
    
    [self updateBtnState];
    
    self.moneyStr = [self getStringWithMoneyBtn:btn1];

}


- (NSString *)getStringWithMoneyBtn:(UIButton *)sender{
    NSString *str;
    switch (sender.tag) {
        case 100:
            str = sender.titleLabel.text;
            break;
        case 101:
            str = sender.titleLabel.text;
            break;
        case 102:
            str = sender.titleLabel.text;
            break;
        case 103:
            str = sender.titleLabel.text;
            break;
        default:
            str = @"default";
            break;
    }
    return str;
}

- (void)updateBtnState{
 
    
    for (UIButton *btn in self.selectBetBtn) {
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = RGBCOLOR(230, 230, 230).CGColor;
        btn.layer.borderWidth = 1;
        
        if (btn.selected == YES) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            
            for (UILabel *lab in self.flagLabel) {
                if (lab.tag == btn.tag + 100) {
                    lab.textColor = [UIColor whiteColor];
                }else{
                    lab.textColor = SystemGreen;
                }
            }
        }else{
            [btn setTitleColor:SystemGreen forState:0];
            
        }
    }
}



- (IBAction)actionBetBtn:(UIButton *)sender {
    for (UIButton *btn in self.selectBetBtn) {
        btn.selected = NO;
    }
    UIButton * btn1 = self.selectBetBtn[sender.tag - 1100];
    btn1.selected = YES;
    
    self.earningsType = [self getStringWithBtn:btn1];
    
    [self updateBtnState];
}


- (NSString *)getStringWithBtn:(UIButton *)sender{
    NSString *str;
    switch (sender.tag) {
        case 1100:
           str = [self.lotteryMan getStringformfeid:EarningsTypeSTEADY];
            break;
        case 1101:
           str = [self.lotteryMan getStringformfeid:EarningsTypeLOW_RISK];
            break;
        case 1102:
           str = [self.lotteryMan getStringformfeid:EarningsTypeHIGH_RISK];
            break;
        default:
           str =  @"default";
            break;
    }
    
    return str;

}

- (IBAction)actionCreateScheme:(UIButton *)sender {
    page = 0;
    [self loadData];
    
}


- (void)loadData{
    //    STEADY, LOW_RISK , HIGH_RISK
    NSDictionary *dic = @{@"earningsType":self.earningsType,
                          @"orderName":self.orderName,
                          };
    [self showLoadingViewWithText:@"正在加载"];
    [self.lotteryMan getListByRecScheme:dic];
}


- (void)gotListByRecScheme:(NSArray *)infoArr errorMsg:(NSString *)errorMsg{
    [self hideLoadingView];
//    [self.SchemeCreateTableView.mj_footer endRefreshing];
//    [self.SchemeCreateTableView.mj_header endRefreshing];
    if (infoArr == nil) {
        if (self.dataArr != nil ) {
            [self.dataArr removeAllObjects];
        }
    }
    
    if (infoArr != nil) {
        if (self.dataArr != nil ) {
            [self.dataArr removeAllObjects];
        }
        for (NSDictionary *dic in infoArr) {
            YuCeScheme *yuceScheme = [[YuCeScheme alloc]initWith:dic];
            [self.dataArr addObject:yuceScheme];
        }
    }
    
    
    if (self.dataArr.count == 0) {
        
//        [self showBlankPageImageName:@"tableviewnodata.png" titleName:TextNoData tableViewFrame:self.SchemeCreateTableView.frame];
    }else{
//        [self hideBlankPage];
    }
    
    [self.SchemeCreateTableView reloadData];
    
}
- (IBAction)actionXuQiuBtn:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        labBottom.center = CGPointMake(sender.center.x, labBottom.center.y);
    }];
    for (UIButton *btn in self.selectXuqiuBtn) {
        btn.selected = NO;
    }
    UIButton * btn1 = self.selectXuqiuBtn[sender.tag - 300];
    btn1.selected = YES;
    self.xuQiuBtnTag = [NSString stringWithFormat:@"%d",sender.tag];
    [self getStringWithXuQiuBtn:btn1];
    [self updateBtnState];
    [self loadData];
    
    
}

- (NSString *)getStringWithXuQiuBtn:(UIButton *)sender{
    
    switch (sender.tag) {
        case 300:
            self.orderName = @"earnings";
            break;
        case 301:
            self.orderName = @"predictIndex";
        default:
            break;
    }
    return self.orderName;
}

- (void)touzhuAction:(YuCeScheme *)scheme{
   
    
    if (self.curUser.isLogin) {
        self.transaction.betSource = @"2";
        self.transaction.yuceScheme = scheme;
        self.transaction.identifier = @"JCZQ";
        self.transaction.schemeSource = SchemeSourceFORECAST;
        [self showTouzhuInfo];
        
    }else{
        
        [self needLogin];
        return;
    }
}



-(void)showTouzhuInfo{
    NSInteger selectnum = 0;
    NSInteger i = 0;
    NSInteger a = 0;
    NSInteger b = 0;
        for (jcBetContent *model in self.transaction.yuceScheme.jcBetContent) {
            
            for (YCbetPlayTypes *model1 in model.betPlayTypes) {
                i++;
                if (i == 1) {
                    a =  model1.options.count ;
                }else if(i == 2){
                    b = model1.options.count;
                }
                selectnum = a * b;
            }
           
        }

    NSString *maxPrizeStr =  [self.moneyStr substringToIndex:(self.moneyStr.length -1)];
    NSInteger maxPrize = [maxPrizeStr integerValue];
    
    self.transaction.maxPrize = maxPrize;
    self.transaction.betCount = selectnum;
    self.transaction.beiTou = maxPrize / (selectnum * 2);
    
    self.transaction.betCost = self.transaction.betCount * 2 * self.transaction.beiTou;
}

//-(void)gotLotteryCurRoundTimeout {
//    [self hideLoadingView];
//    [self showPromptText:requestTimeOut hideAfterDelay:3.0];
//
//}
//
//-(void)setTableViewLoadRefresh{
//
//    self.SchemeCreateTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
//
//        page ++;
//        [self loadData];
//    }];
//
//    self.SchemeCreateTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        page = 0;
//
//        [self loadData];
//    }];
//}
@end
