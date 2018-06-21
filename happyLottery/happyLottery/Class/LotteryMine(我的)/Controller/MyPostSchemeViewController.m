//
//  MyPostSchemeViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "MyPostSchemeViewController.h"
#import "PaySuccessViewController.h"
#import "FollowSchemeViewCell.h"
#import "PostSchemeViewCell.h"
#import "JCZQSchemeModel.h"
#import "FASSchemeDetailViewController.h"
#import "NoticeCenterViewController.h"
#define KFollowSchemeViewCell @"FollowSchemeViewCell"
#define KPostSchemeViewCell  @"PostSchemeViewCell"

@interface MyPostSchemeViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>
{
    NSInteger page;
    __weak IBOutlet NSLayoutConstraint *viewDisTop;
    NSMutableArray <JCZQSchemeItem *> *dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tabSchemeListView;
@property (weak, nonatomic) IBOutlet UIButton *btnGendan;
@property (weak, nonatomic) IBOutlet UIButton *btnFadan;
@property (weak, nonatomic) IBOutlet UIImageView *imgBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disImgLeft;

@end

@implementation MyPostSchemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的跟单";
    self.viewControllerNo = @"A422";
    if (self.isFaDan) {
        [self actionGenDan:self.btnFadan];
        self.viewControllerNo = @"A424";
    }
    dataArray = [NSMutableArray arrayWithCapacity:0];
    if ([self isIphoneX]) {
        viewDisTop.constant = 88;
    }else{
        viewDisTop.constant = 64;
    }
    [self setTableView];
    [self setTableViewLoadRefresh];
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{
    self.tabSchemeListView.delegate = self;
    self.tabSchemeListView.dataSource = self;
    self.tabSchemeListView.rowHeight = 73;
    [self.tabSchemeListView registerNib:[UINib nibWithNibName:KPostSchemeViewCell bundle:nil] forCellReuseIdentifier:KPostSchemeViewCell];
    [self.tabSchemeListView registerNib:[UINib nibWithNibName:KFollowSchemeViewCell bundle:nil] forCellReuseIdentifier:KFollowSchemeViewCell];
    self.lotteryMan.delegate =self;
}

-(void)setTableViewLoadRefresh{
    
    [UITableView refreshHelperWithScrollView:self.tabSchemeListView target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.btnGendan.selected == YES){
        FollowSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KFollowSchemeViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadData:[dataArray objectAtIndex:indexPath.row]];
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }else{
        
        PostSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KPostSchemeViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell loadData:[dataArray objectAtIndex:indexPath.row]];
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

-(void)loadNewData{
    page = 1;
    NSString *costType = @"CASH";
    [self.lotteryMan getSchemeRecord:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize),@"costType":costType,@"schemeType":[self getSchemeType]}];
}

-(void)loadMoreData{
    page++;
    NSString *costType = @"CASH";
 
    [self.lotteryMan getSchemeRecord:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize),@"costType":costType,@"schemeType":[self getSchemeType]}];
}

-(NSString *)getSchemeType{
    if(self.btnGendan.selected == YES){
        return @"BUY_FOLLOW";
    }else{
        return @"BUY_INITIATE";
    }
}

-(void)gotSchemeRecord:(NSArray *)infoDic errorMsg:(NSString *)msg{
    
    [self.tabSchemeListView tableViewEndRefreshCurPageCount:infoDic.count];
    if (infoDic == nil) {
        [self showPromptText:msg hideAfterDelay:17];
        return;
    }
    if(page == 1){
        [dataArray removeAllObjects];
    }
    for (NSDictionary *itemDic in infoDic) {
        JCZQSchemeItem *model = [[JCZQSchemeItem alloc]initWith:itemDic];
        [dataArray addObject:model];
    }
    [self.tabSchemeListView reloadData];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (IBAction)actionGenDan:(UIButton*)sender {
    
    self.btnFadan.selected = NO;
    self.btnGendan.selected = NO;
     self.disImgLeft.constant = sender.mj_x + 10;
    [UIView animateWithDuration:0.5 animations:^{
           [self.imgBottom.superview layoutIfNeeded];
//    self.imgBottom.mj_x = sender.mj_x + 10;
    }];
    
    sender.selected = YES;
    [self loadNewData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.btnGendan.selected == YES){
        return 100;
    }else{
     return 85;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JCZQSchemeItem *model = [dataArray objectAtIndex:indexPath.row];
    FASSchemeDetailViewController *detailCV = [[FASSchemeDetailViewController alloc]init];
    detailCV.schemeNo = model.schemeNO;
    detailCV.schemeType = [self getSchemeType];
    detailCV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailCV animated:YES];
}

-(void)navigationBackToLastPage{
//    for (BaseViewController *baseVC in self.navigationController.viewControllers) {
//        if ([baseVC isKindOfClass:[PaySuccessViewController class]]) {
//
//            return;
//        }
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [super navigationBackToLastPage];
}

@end
