//
//  BuyLotteryViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BuyLotteryViewController.h"
#import "WBAdsImgView.h"
#import "JCZQPlayViewController.h"
#import "HomeMenuItemView.h"
#import "NewsListCell.h"
#import "MyOrderListViewController.h"

#define KNewsListCell @"NewsListCell"
@interface BuyLotteryViewController ()<WBAdsImgViewDelegate,HomeMenuItemViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    __weak IBOutlet UIView *scrContentView;
    __weak IBOutlet NSLayoutConstraint *homeViewHeight;
    WBAdsImgView *adsView;
    UIView  *menuView;
    CGFloat curY;
    __weak IBOutlet NSLayoutConstraint *newsViewMarginTop;
    __weak IBOutlet NSLayoutConstraint *tabForecastListHeight;
    __weak IBOutlet UITableView *tabForecaseList;
}
@end

@implementation BuyLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewFeature];
    [self setADSUI];
    [self setMenu];
    [self setNewsView];
    [self setTableView];
   
}

-(void)setTableView{

    tabForecaseList.delegate = self;
    tabForecaseList.dataSource = self;
    [tabForecaseList registerClass:[NewsListCell class] forCellReuseIdentifier:KNewsListCell];
    tabForecaseList.rowHeight = 117;
    [tabForecaseList reloadData];
    tabForecastListHeight.constant = tabForecaseList.rowHeight * 3;
    CGFloat height = 0;
    if ([self isIphoneX]) {
        height = tabForecaseList.mj_y + tabForecaseList.rowHeight * 3 + 20;
    }else{
        height = tabForecaseList.mj_y + tabForecaseList.rowHeight * 3;
    }
    homeViewHeight.constant = height;
    tabForecaseList.bounces = NO;
}

-(void)setNewsView{
    newsViewMarginTop.constant = curY;
}

-(void)setViewFeature{
    scrContentView.backgroundColor = MAINBGC;
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)setMenu{
    curY = adsView.mj_y + adsView.mj_h ;
    menuView = [[UIView alloc]initWithFrame:CGRectMake(0, curY, KscreenWidth, 83)];
    [scrContentView addSubview:menuView];
    
    NSArray *items = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"HomeMenuItemsConfig" ofType: @"plist"]];
    NSInteger width = KscreenWidth/items.count;
    NSInteger height = menuView.mj_h;
    for (int i = 0; i<items.count; i++) {
        NSDictionary *itemdic = items[i];
        HomeMenuItemView *menuItem = [[HomeMenuItemView alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
        [menuItem setItemIcom:[UIImage imageNamed:itemdic[@"itemImage"]] title:itemdic[@"itemTitle"] setTag:1000+i];
        
        menuItem.delegate = self;
        menuView.backgroundColor = [UIColor whiteColor];
        [menuView addSubview:menuItem];
    }
     curY = menuView.mj_h + menuView.mj_y + 10;
   
}

-(void)setADSUI{

    adsView = [[WBAdsImgView alloc]initWithFrame:CGRectMake(0,[self isIphoneX]?20:0, KscreenWidth, 175.0/667.0 * KscreenHeight)];

    adsView.delegate = self;
    [scrContentView addSubview:adsView];
    [adsView setImageUrlArray:@[@"",@"http://oy9n5uzrj.bkt.clouddn.com/ms/20171205/25b8ff0a955c475bbaf1aa1055dee4a9",@"http://oy9n5uzrj.bkt.clouddn.com/ms/20171128/6d6a844b31f8411e936c91c86ceb1a60"]];
}

-(void)adsImgViewClick:(NSInteger)itemIndex{
    [self showPromptText:[NSString stringWithFormat:@"点击了%ld",itemIndex] hideAfterDelay:1.9];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = NO;
    
}

#pragma HomeMenuItemViewDelegate
-(void)itemClick:(NSInteger)index{
    
    
}

#pragma UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:KNewsListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (IBAction)actionMoreNews:(UIButton *)sender {
    MyOrderListViewController * orderVC = [[MyOrderListViewController alloc]init];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

@end
