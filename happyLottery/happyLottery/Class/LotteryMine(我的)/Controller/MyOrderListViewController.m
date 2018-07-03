//
//  MyOrderListViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//我的订单

#import "MyOrderListViewController.h"
#import "DLTSchemeDetailViewController.h"
#import "CTZQSchemeDetailViewController.h"
#import "JCLQSchemeDetailViewController.h"
#import "GYJSchemeDetailViewController.h"
#import "JCZQSchemeModel.h"
#import "SchemListCell.h"
#import "SchemeDetailViewController.h"
#import "MJRefresh.h"
#import "NoticeCenterViewController.h"
#define KSchemListCell @"SchemListCell"
@interface MyOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

{
    CostType curSchemeType;
    __weak IBOutlet NSLayoutConstraint *viewDisTop;
    __weak IBOutlet UITableView *tabSchemeList;
    JCZQSchemeModel* schemeModel;
    NSMutableArray <JCZQSchemeItem *> *dataArray;
    NSInteger page;
}

@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A204";
    dataArray = [NSMutableArray arrayWithCapacity:0];
    self.title = @"我的订单";
    page = 1;
    
    if ([self isIphoneX]) {
        viewDisTop.constant = 88;
    }else{
        viewDisTop.constant = 64;
    }
    curSchemeType = CostTypeCASH;
    [self setTableViewLoadRefresh];
    [self setTableView];
    
    [self loadNewData];
    if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    }

}


- (IBAction)actionCostTypeSelect:(UISegmentedControl *)sender {
    page = 1;
    if (sender.selectedSegmentIndex == 0) {
        curSchemeType = CostTypeCASH;
    }else if (sender.selectedSegmentIndex == 1){
        curSchemeType = CostTypeSCORE;
    }
    [self loadNewData];
}

-(void)setTableViewLoadRefresh{
    
    [UITableView refreshHelperWithScrollView:tabSchemeList target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];

}

-(void)setTableView{
    tabSchemeList.delegate = self;
    tabSchemeList.dataSource = self;
    [tabSchemeList registerClass:[ SchemListCell class] forCellReuseIdentifier:KSchemListCell];
    tabSchemeList.rowHeight = 73;
    
    self.lotteryMan.delegate =self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)actionSelectSchemeTpye:(UISegmentedControl *)sender {
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchemListCell *cell = [tableView dequeueReusableCellWithIdentifier:KSchemListCell];
    [cell refreshData:dataArray[indexPath.row]];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
//    //删除
////    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
////        [self.titleArr removeObjectAtIndex:indexPath.row];
////        completionHandler (YES);
////        [self.tableView reloadData];
////    }];
////    deleteRowAction.image = [UIImage imageNamed:@"删除"];
////    deleteRowAction.backgroundColor = [UIColor redColor];
////
////    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
//    return config;
//}

-(void)loadNewData{
    page = 1;
    NSString *costType = @"CASH";
    if (curSchemeType == CostTypeCASH) {
        costType = @"CASH";
    }else if(curSchemeType == CostTypeSCORE){
        costType  = @"SCORE";
    }
    [self.lotteryMan getSchemeRecord:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(10),@"costType":costType}];
}

-(void)loadMoreData{
    page++;
    NSString *costType = @"CASH";
    if (curSchemeType == CostTypeCASH) {
        costType = @"CASH";
    }else if(curSchemeType == CostTypeSCORE){
        costType  = @"SCORE";
    }
    [self.lotteryMan getSchemeRecord:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize),@"costType":costType}];
}

-(void)gotSchemeRecord:(NSArray *)infoDic errorMsg:(NSString *)msg{

    [tabSchemeList tableViewEndRefreshCurPageCount:infoDic.count];
    if (infoDic == nil) {
        [self showPromptText:msg hideAfterDelay:17];
        return;
    }
    if (page == 1) {
         [dataArray removeAllObjects];
//        NSString *costType = @"CASH";
//        if (curSchemeType == CostTypeCASH) {
//            costType = @"CASH";
//        }else if(curSchemeType == CostTypeSCORE){
//            costType  = @"SCORE";
//        }
//       JCZQSchemeItem *item = [dataArray firstObject];
//        if ([item.costType isEqualToString:costType]) {
//
//        }
        
    }
    
    for (NSDictionary *itemDic in infoDic) {
        JCZQSchemeItem *model = [[JCZQSchemeItem alloc]initWith:itemDic];
        [dataArray addObject:model];
    }
    [tabSchemeList reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([dataArray[indexPath.row].lottery isEqualToString:@"RJC"] || [dataArray[indexPath.row].lottery isEqualToString:@"SFC"]) {
        CTZQSchemeDetailViewController*schemeVC = [[CTZQSchemeDetailViewController alloc]init];
        schemeVC.schemeNO = dataArray[indexPath.row].schemeNO;
        NSString *imageName = [dataArray[indexPath.row] getSchemeImgState];
        schemeVC.imageName = imageName;
        [self.navigationController pushViewController:schemeVC animated:YES];
    }else if([dataArray[indexPath.row].lottery isEqualToString:@"DLT"]||[dataArray[indexPath.row].lottery isEqualToString:@"SSQ"] || [dataArray[indexPath.row].lottery isEqualToString:@"SX115"] || [dataArray[indexPath.row].lottery isEqualToString:@"SD115"]){
        DLTSchemeDetailViewController *schemeVC = [[DLTSchemeDetailViewController alloc]init];
        schemeVC.schemeNO = dataArray[indexPath.row].schemeNO;
        NSString *imageName = [dataArray[indexPath.row] getSchemeImgState];
        schemeVC.imageName = imageName;
        [self.navigationController pushViewController:schemeVC animated:YES];
    }else if ([dataArray[indexPath.row].lottery isEqualToString:@"JCGJ"] || [dataArray[indexPath.row].lottery isEqualToString:@"JCGYJ"]){
        GYJSchemeDetailViewController*schemeVC = [[GYJSchemeDetailViewController alloc]init];
        schemeVC.schemeNO = dataArray[indexPath.row].schemeNO;
        NSString *imageName = [dataArray[indexPath.row] getSchemeImgState];
        schemeVC.imageName = imageName;
        [self.navigationController pushViewController:schemeVC animated:YES];
    }else if ([dataArray[indexPath.row].lottery isEqualToString:@"JCLQ"]){
        JCLQSchemeDetailViewController*schemeVC = [[JCLQSchemeDetailViewController alloc]init];
        schemeVC.schemeNO = dataArray[indexPath.row].schemeNO;
        NSString *imageName = [dataArray[indexPath.row] getSchemeImgState];
        schemeVC.imageName = imageName;
        [self.navigationController pushViewController:schemeVC animated:YES];
    }else{
        SchemeDetailViewController *schemeVC = [[SchemeDetailViewController alloc]init];
        schemeVC.schemeNO = dataArray[indexPath.row].schemeNO;
        NSString *imageName = [dataArray[indexPath.row] getSchemeImgState];
        schemeVC.imageName = imageName;
        [self.navigationController pushViewController:schemeVC animated:YES];
    }
   
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

-(void)navigationBackToLastPage{
    for (BaseViewController *baseVC in self.navigationController.viewControllers) {
        if ([baseVC isKindOfClass:[NoticeCenterViewController class]]) {
            [self.navigationController popToViewController:baseVC animated:YES];
            return;
        }
    }
    self.tabBarController.selectedIndex = 4;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
