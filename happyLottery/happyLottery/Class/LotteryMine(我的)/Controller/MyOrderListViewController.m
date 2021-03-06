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
#import "DeleteOrderView.h"
#import "LegOrderDetailViewController.h"
#define KSchemListCell @"SchemListCell"
#define KdeleteOrderIntroduce  @"deleteOrderIntroduce"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)





@interface MyOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate>

{
    CostType curSchemeType;
    __weak IBOutlet NSLayoutConstraint *viewDisTop;
    __weak IBOutlet UITableView *tabSchemeList;
    JCZQSchemeModel* schemeModel;
    NSMutableArray <JCZQSchemeItem *> *dataArray;
    NSInteger page;
    DeleteOrderView *introView;
}
@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置
@property (strong, nonatomic) NSIndexPath* selectIndexPath; //当前要删除的cell

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *  isShow = [[NSUserDefaults standardUserDefaults] objectForKey:KdeleteOrderIntroduce];
   
    if (isShow == nil) {
        introView = [[DeleteOrderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow addSubview:self->introView];
        });
    }else{
        introView.hidden = YES;
        if(introView.superview!=nil){
            [introView removeFromSuperview];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    introView.hidden = YES;
    if(introView.superview!=nil){
        [introView removeFromSuperview];
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


-(NSString *)getLotteryByCode:(NSString *)code{
    if ([code isEqualToString:@"JCZQ"]) {
        return @"竞彩足球";
    }else if([code isEqualToString:@"DLT"]){
        return [NSString stringWithFormat:@"大乐透"];
    }else if([code isEqualToString:@"RJC"]){
        return [NSString stringWithFormat:@"任选9场"];
    }else if([code isEqualToString:@"SFC"]){
        return [NSString stringWithFormat:@"胜负14场"];
    }else if ([code isEqualToString:@"JCGYJ"]){
        return @"冠亚军";
    }else if ([code isEqualToString:@"JCGJ"]){
        return @"冠军";
    }else if ([code isEqualToString:@"SSQ"]){
        return [NSString stringWithFormat:@"双色球"];
    }else if ([code isEqualToString:@"JCLQ"]){
        return @"竞彩篮球";
    }else if ([code isEqualToString:@"SD115"]){
        return [NSString stringWithFormat:@"山东11选5"];
        
    }else if ([code isEqualToString:@"SX115"]){
        return [NSString stringWithFormat:@"陕西11选5"];
    }
    return @"彩票";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JCZQSchemeItem *scheme = dataArray[indexPath.row];
    if (scheme.postboyId.length > 0) {   //如果有快递小哥，进入订单详情页面，否则进入方案详情页面
        LegOrderDetailViewController *detail = [[LegOrderDetailViewController alloc]init];
        detail.schemeNo = scheme.schemeNO;
        detail.schemetype =  SchemeTypeZigou;
        detail.lotteryName = [self getLotteryByCode:dataArray[indexPath.row].lottery];
        [self.navigationController pushViewController:detail animated:YES];
    }else {
            if ([scheme.lottery isEqualToString:@"RJC"] || [scheme.lottery isEqualToString:@"SFC"]) {
                CTZQSchemeDetailViewController*schemeVC = [[CTZQSchemeDetailViewController alloc]init];
                schemeVC.schemeNO = dataArray[indexPath.row].schemeNO;
                NSString *imageName = [dataArray[indexPath.row] getSchemeImgState];
                schemeVC.imageName = imageName;
                [self.navigationController pushViewController:schemeVC animated:YES];
            }else if([scheme.lottery isEqualToString:@"DLT"]||[scheme.lottery isEqualToString:@"SSQ"] || [scheme.lottery isEqualToString:@"SX115"] || [scheme.lottery isEqualToString:@"SD115"]){
                DLTSchemeDetailViewController *schemeVC = [[DLTSchemeDetailViewController alloc]init];
                schemeVC.schemeNO = dataArray[indexPath.row].schemeNO;
                NSString *imageName = [dataArray[indexPath.row] getSchemeImgState];
                schemeVC.imageName = imageName;
                [self.navigationController pushViewController:schemeVC animated:YES];
            }else if ([scheme.lottery isEqualToString:@"JCGJ"] || [scheme.lottery isEqualToString:@"JCGYJ"]){
                GYJSchemeDetailViewController*schemeVC = [[GYJSchemeDetailViewController alloc]init];
                schemeVC.schemeNO = dataArray[indexPath.row].schemeNO;
                NSString *imageName = [dataArray[indexPath.row] getSchemeImgState];
                schemeVC.imageName = imageName;
                [self.navigationController pushViewController:schemeVC animated:YES];
            }else if ([scheme.lottery isEqualToString:@"JCLQ"]){
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

#pragma mark ======deleteCell=======
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:TitleHint message:@"您确定删除吗?"];
        [alert addBtnTitle:TitleNotDo action:^{
            [tableView setEditing:NO animated:YES];
        }];

        [alert addBtnTitle:TitleDo action:^{
            [tableView setEditing:NO animated:YES];
            self.selectIndexPath = indexPath;
            JCZQSchemeItem *seleteScheme = self->dataArray[indexPath.row];
            NSDictionary *dic = @{@"schemeNo":seleteScheme.schemeNO};
            [self.lotteryMan getDeleteSchemeByNo:dic];
        }];
        [alert showAlertWithSender:self];
    }
}

- (void) deleteSchemeByNo:(NSString *)resultStr  errorMsg:(NSString *)msg{
    if (msg == nil) {
        [tabSchemeList setEditing:NO];
        [dataArray removeObjectAtIndex:self.selectIndexPath.row];
        [tabSchemeList deleteRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
//        [tabSchemeList reloadData];
         [self showPromptText:@"删除订单成功" hideAfterDelay:1.7];
    } else {
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
         [self configSwipeButtons];
    }
}

- (void)configSwipeButtons
{
    // 获取选项按钮的reference
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0"))
//    {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        //        for (UIView *subview in tabSchemeList.subviews)
        //        {
        //            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
        //            {
        //                // 和iOS 10的按钮顺序相反
        //                UIButton *deleteButton = subview.subviews[0];
        //                [deleteButton setTitle:@"确认删除" forState:UIControlStateNormal];
        //                [deleteButton setBackgroundColor:RGBCOLOR(254, 165, 19)];
        //            }
        //        }
//    }
    if (SYSTEM_VERSION_LESS_THAN(@"11.0"))
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        SchemListCell *tableCell = [tabSchemeList cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                UIButton *deleteButton = subview.subviews[0];
                [deleteButton setBackgroundColor:RGBCOLOR(254, 165, 19)];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = nil;
}

- ( UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:TitleHint message:@"您确定删除吗?"];
        [alert addBtnTitle:TitleNotDo action:^{
            completionHandler (NO);
        }];
        
        [alert addBtnTitle:TitleDo action:^{
            completionHandler (YES);
            self.selectIndexPath = indexPath;
            JCZQSchemeItem *seleteScheme = self->dataArray[indexPath.row];
            NSDictionary *dic = @{@"schemeNo":seleteScheme.schemeNO};
            [self.lotteryMan getDeleteSchemeByNo:dic];
            
        }];
        [alert showAlertWithSender:self];
        
    }];
    deleteRowAction.backgroundColor = RGBCOLOR(254, 165, 19);
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

@end
