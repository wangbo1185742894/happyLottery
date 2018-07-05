//
//  ClassListCellViewController.m
//  appmall
//
//  Created by 阿兹尔 on 2018/4/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "ClassListCellViewController.h"
#import "WBMenu.h"
#import "CashAndIntegrationWaterTableViewCell.h"
#define KClassItemViewCell @"CashAndIntegrationWaterTableViewCell"
@interface ClassListCellViewController ()<WBMenuViewDelegate,UITableViewDataSource,UITableViewDelegate,XYTableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *classListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDis;
@property(nonatomic,strong)NSMutableArray*classArray;
@property(nonatomic,assign)NSInteger page;

@end

@implementation ClassListCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bottomDis.constant = BOTTOM_BAR_HEIGHT + 84;
    [UITableView refreshHelperWithScrollView:self.classListView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
    self.classArray = [NSMutableArray arrayWithCapacity:0];
}


-(void)loadNewData{
    _page = 1;
    [self loadData];
}
-(void)loadMoreData{
    _page ++;
    [self loadData];
}



-(void)setTableView{
    self.classListView .delegate = self;
    self.classListView.rowHeight = 140;
    self.classListView.dataSource = self;
    [self.classListView registerNib:[UINib nibWithNibName:KClassItemViewCell bundle:nil] forCellReuseIdentifier:KClassItemViewCell];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)loadData{
    
}

-(void)refresh{
//    [self showNoticeView:@"刷新数据"];
}

-(BOOL)isRefresh{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CashAndIntegrationWaterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KClassItemViewCell];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
