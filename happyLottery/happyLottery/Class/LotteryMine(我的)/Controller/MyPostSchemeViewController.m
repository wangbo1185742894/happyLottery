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

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

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
@property (strong, nonatomic) NSIndexPath* editingIndexPath;
@property (strong, nonatomic) NSIndexPath* selectIndexPath; //当前要删除的cell

@end

@implementation MyPostSchemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的跟投";
    self.viewControllerNo = @"A424";
    if (!self.isFaDan) {
        [self actionGenDan:self.btnGendan];
        self.viewControllerNo = @"A422";
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
    self.tabBarController.selectedIndex = 4;
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [super navigationBackToLastPage];
}

#pragma mark =====deletecell=======
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
        [self.tabSchemeListView setEditing:NO];
        [dataArray removeObjectAtIndex:self.selectIndexPath.row];
        [self.tabSchemeListView deleteRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
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
        UITableViewCell *tableCell;
        tableCell = [self.tabSchemeListView cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                UIButton *deleteButton = subview.subviews[0];
                [deleteButton setBackgroundColor:RGBCOLOR(254, 165, 19)];
            }
        }
//        if(self.btnGendan.selected == YES){
//
//
//        }else{
//            PostSchemeViewCell *tableCell = [self.tabSchemeListView cellForRowAtIndexPath:self.editingIndexPath];
//            for (UIView *subview in tableCell.subviews)
//            {
//                if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
//                {
//                    UIButton *deleteButton = subview.subviews[0];
//                    [deleteButton setBackgroundColor:RGBCOLOR(254, 165, 19)];
//                }
//            }
//        }
        
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
