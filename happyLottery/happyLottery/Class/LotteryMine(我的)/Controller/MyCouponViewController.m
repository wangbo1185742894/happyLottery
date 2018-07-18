//
//  MyCouponViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/28.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MyCouponViewController.h"
#import "MyCouponTableViewCell.h"
#import "DiscoverViewController.h"
#import "Coupon.h"

@interface MyCouponViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray <Coupon *>*listUseCouponArray;
    NSMutableArray  <Coupon *>*  listUnUseCouponArray;
    int currPage1;
    int pageSize1;
    int totalCount1;
    int totalPage1;
    int currPage2;
    int pageSize2;
    int totalCount2;
    int totalPage2;
    int page;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UIView *enptyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hrightCons;

@end

@implementation MyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    self.memberMan.delegate = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    _segment.hidden = NO;
    self.hrightCons.constant = 32;
    if (_fromZf) {
        self.hrightCons.constant = 0;
        _segment.hidden = YES;
    }
    listUseCouponArray = [[NSMutableArray alloc]init];
    listUnUseCouponArray = [[NSMutableArray alloc]init];
     [self initRefresh2];
         [self initRefresh1];
    if ( self.segment.selectedSegmentIndex == 0) {
    
        [self loadTrueNewData];
        
        self.tableView1.hidden = NO;
        self.tableView2.hidden = YES;
    }else  if (self.segment.selectedSegmentIndex == 1) {
        [self loadFalseNewData];
       
        self.tableView2.hidden = NO;
        self.tableView1.hidden = YES;
    }
}
- (IBAction)segmetClick:(id)sender {
    switch( self.segment.selectedSegmentIndex)
    {
        case 0:
            self.tableView1.hidden=NO;
            self.tableView2.hidden=YES;
             [listUseCouponArray removeAllObjects];
            [listUnUseCouponArray removeAllObjects];
            
            
            [self loadTrueNewData];
            break;
        case 1:
            self.tableView2.hidden=NO;
            self.tableView1.hidden=YES;
            [self loadFalseNewData];
            [listUseCouponArray removeAllObjects];
            [listUnUseCouponArray removeAllObjects];
            break;
        default:
            break;
    }
}

-(void)initRefresh1{
    
    [UITableView refreshHelperWithScrollView:self.tableView1 target:self loadNewData:@selector(loadTrueNewData) loadMoreData:@selector(loadTrueMoreData) isBeginRefresh:NO];
    
}
-(void)initRefresh2{
    [UITableView refreshHelperWithScrollView:self.tableView2 target:self loadNewData:@selector(loadFalseNewData) loadMoreData:@selector(loadFalseMoreData) isBeginRefresh:NO];
}


-(void)loadTrueNewData{
    [self getCouponNewData:@"true"];
}

-(void)loadFalseNewData{
    [self getCouponNewData:@"false"];
}

-(void)loadTrueMoreData{
    [self getCouponMoreData:@"true"];
}

-(void)loadFalseMoreData{
    [self getCouponMoreData:@"false"];
}

-(void)getCouponByStateSms:(NSArray *)couponInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{

  
    
    if (success == YES && couponInfo != nil) {

        
        if (self.segment.selectedSegmentIndex == 0) {
            [self.tableView1 tableViewEndRefreshCurPageCount:couponInfo.count];
        }else{
            [self.tableView2 tableViewEndRefreshCurPageCount:couponInfo.count];
        }
        
        UITableView *itemTableView;
        NSMutableArray *itemDataArray;
        if (self.segment.selectedSegmentIndex == 0) {
            itemTableView = self.tableView1;
            itemDataArray = listUseCouponArray;
        }else{
            itemTableView = self.tableView2;
            itemDataArray = listUnUseCouponArray;
        }
        
        if (page == 1) {
            [itemDataArray removeAllObjects];
        }
        
        for (NSDictionary *itemDic in couponInfo) {
            Coupon *coupon = [[Coupon alloc]initWith:itemDic];
            [itemDataArray addObject:coupon];
        }
        self.tableView1.hidden = YES;
        self.tableView2.hidden = YES;
        itemTableView .hidden = NO;
        
        [itemTableView reloadData];

    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

-(void)getCouponMoreData:(NSString*)isValid{
    page++;
    NSDictionary *Info;
    @try {
        
        NSString *cardCode = self.curUser.cardCode;
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        Info = @{@"cardCode":cardCode,
                 @"isValid":isValid,
                 @"page":pagestr,
                 @"pageSize":@(KpageSize)
                 };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.memberMan getCouponByStateSms:Info];
}

-(void)getCouponNewData:(NSString*)isValid{
    page = 1;
    NSDictionary *Info;
    @try {
        
        NSString *cardCode = self.curUser.cardCode;
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        Info = @{@"cardCode":cardCode,
                 @"isValid":isValid,
                 @"page":pagestr,
                 @"pageSize":@(KpageSize)
                 };
        
    } @catch (NSException *exception) {
        
    }
    [self.memberMan getCouponByStateSms:Info];

}

#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView ==self.tableView1) {
        if (listUseCouponArray.count > 0) {
            return listUseCouponArray.count;
        }
    }else if (tableView ==self.tableView2){
        
        if (listUnUseCouponArray.count > 0) {
            return listUnUseCouponArray.count;
        }
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 111;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    MyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
//    SCORE_CONVERT("积分兑换"),
//    LUCKY_DRAW("抽奖"),
//    SYSTEM("系统赠送"),
//    ACTIVITY("活动");
    Coupon *coupon = [[Coupon alloc]init];
    if (tableView ==self.tableView1) {
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCouponTableViewCell" owner:self options:nil] lastObject];
        }
        if (listUseCouponArray.count > 0) {
            coupon = listUseCouponArray[indexPath.row];
            cell.endImage.hidden = YES;
             NSString *deduction =coupon.deduction;
            cell.priceLab.text = deduction;
            cell.nameLab.text =[NSString stringWithFormat:@"¥%@元优惠券",deduction];
            cell.countLab.text = coupon.count;

            cell.sourceLab.text = [NSString stringWithFormat:@"%@",coupon.couponSource];
            cell.dateLab.text = [NSString stringWithFormat:@"截止时间：%@",coupon.invalidTime];
            cell.descriptionLab.text=[NSString stringWithFormat:@"单笔订单满%@可用",coupon.quota];
            cell.bjImage.image = [UIImage imageNamed:@"bjCoupon"];
        }

    }else if (tableView ==self.tableView2){
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCouponTableViewCell" owner:self options:nil] lastObject];
        }
        if (listUnUseCouponArray.count > 0) {
            
            coupon = listUnUseCouponArray[indexPath.row];
            cell.endImage.hidden = NO;
            cell.priceLab.text = coupon.deduction;
            cell.nameLab.text =[NSString stringWithFormat:@"¥%@元优惠券",coupon.deduction];
            cell.priceLab.textColor = [UIColor lightGrayColor];
            cell.yuanLab.textColor =[UIColor lightGrayColor];
            NSString *status =coupon.status;
            NSString *sourecs;
           cell.countLab.text = coupon.count;
            cell.countLab.textColor=[UIColor blackColor];
            cell.sourceLab.text = [NSString stringWithFormat:@"%@",coupon.couponSource];
            cell.dateLab.text = [NSString stringWithFormat:@"截止时间：%@",coupon.invalidTime];
            cell.descriptionLab.text=[NSString stringWithFormat:@"单笔订单满%@可用",coupon.quota];
            cell.bjImage.image = [UIImage imageNamed:@"bj_overdue"];
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0;
    //    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (tableView ==self.tableView1){
        MyCouponTableViewCell  *selectCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectCell.selected==YES) {
            selectCell.bjImage.image = [UIImage imageNamed:@"bluecoupon"];
        }else{
             selectCell.bjImage.image = [UIImage imageNamed:@"bjCoupon"];
        }
       
    }else if (tableView ==self.tableView1){
        [tableView deselectRowAtIndexPath: indexPath animated: YES];
    }
//    }else if (tableView ==self.tableView1){
//        MyCouponTableViewCell  *selectCell = [self.tableView1 cellForRowAtIndexPath:indexPath];
//        if (selectCell.selected==YES) {
//            selectCell.bjImage.image = [UIImage imageNamed:@"bluecoupon"];
//        }else{
//            selectCell.bjImage.image = [UIImage imageNamed:@"bj_overdue"];
//        }
//    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==self.tableView1){
        MyCouponTableViewCell  *selectCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectCell.selected==NO) {
            selectCell.bjImage.image = [UIImage imageNamed:@"bjCoupon"];
        }else{
            selectCell.bjImage.image = [UIImage imageNamed:@"bluecoupon"];
        }
        
    }
}

- (void)navigationBackToLastPage{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[DiscoverViewController class]]) {
            self.tabBarController.selectedIndex = 3;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    [super navigationBackToLastPage];
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
