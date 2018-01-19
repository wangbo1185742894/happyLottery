//
//  MyCouponViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/28.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MyCouponViewController.h"
#import "MyCouponTableViewCell.h"
#import "Coupon.h"

@interface MyCouponViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listUseCouponArray;
    NSMutableArray *listUnUseCouponArray;
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
    listUseCouponArray = [[NSMutableArray alloc]init];
    listUnUseCouponArray = [[NSMutableArray alloc]init];
    page=1;
    if ( self.segment.selectedSegmentIndex == 0) {
    
        [self initRefresh1];
        
        self.tableView1.hidden = NO;
        self.tableView2.hidden = YES;
    }else  if (self.segment.selectedSegmentIndex == 1) {
    
        [self initRefresh2];
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
            
            [listUnUseCouponArray removeAllObjects];
            //[self getCouponByStateClient:@"true"];
            page=1;
              [self initRefresh1];
            break;
        case 1:
            self.tableView2.hidden=NO;
            self.tableView1.hidden=YES;
            page=1;
            [listUseCouponArray removeAllObjects];
//            [self getCouponByStateClient:@"false"];
              [self initRefresh2];
            break;
        default:
            break;
    }
}

-(void)initRefresh1{
    __weak typeof(self) weakSelf = self;
  
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [weakSelf getCouponByStateClient:@"true"];
         [self.tableView1.mj_header endRefreshing];
    }];
    self.tableView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
         ///[self.tableView1.mj_footer beginRefreshing];
        [weakSelf getCouponByStateClient:@"true"];
        
    }];
    // 马上进入刷新状态
    [self.tableView1.mj_header beginRefreshing];
}
-(void)initRefresh2{
    __weak typeof(self) weakSelf = self;
    
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [weakSelf getCouponByStateClient:@"false"];
         [self.tableView2.mj_header endRefreshing];
    }];
    self.tableView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
          //[self.tableView2.mj_header beginRefreshing];
        [weakSelf getCouponByStateClient:@"false"];
        
    }];
    
    // 马上进入刷新状态
  
     [self.tableView2.mj_header beginRefreshing];
}

-(void)getCouponByStateSms:(NSArray *)couponInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    NSLog(@"couponInfo%@",couponInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        NSEnumerator *enumerator = [couponInfo objectEnumerator];
        id object;
        if ((object = [enumerator nextObject]) != nil){
            
                if (self.segment.selectedSegmentIndex == 0) {
                    
                    NSArray *array =couponInfo ;
                   
                        
                        if (page == 1) {
                            [listUseCouponArray removeAllObjects];
                             if (array.count>0) {
                                 for (int i=0; i<array.count; i++) {
                                     
                                     Coupon *coupon = [[Coupon alloc]initWith:array[i]];
                                     [listUseCouponArray addObject:coupon];
                                     NSLog(@"redPacket%@",coupon.status);
                                 }
                                 [self.tableView1.mj_footer endRefreshing];
                                 self.tableView1.hidden = NO;
                                 self.tableView2.hidden = YES;
                                 [self.tableView1 reloadData];
                                 self.enptyView.hidden=YES;
                             }
                        }else{
                         if (array.count>0) {
//
                        for (int i=0; i<array.count; i++) {
                            
                            Coupon *coupon = [[Coupon alloc]initWith:array[i]];
                            [listUseCouponArray addObject:coupon];
                             NSLog(@"redPacket%@",coupon.status);
                           
                        }
                             if (listUseCouponArray.count>0) {
                                 self.tableView1.hidden = NO;
                                 self.tableView2.hidden = YES;
                                 [self.tableView1 reloadData];
                                 [self.tableView1.mj_footer endRefreshing];
                             }else{
                                [self.tableView1.mj_footer endRefreshingWithNoMoreData];
                                 
                             }
                             
                    }
                        }
                }else if(self.segment.selectedSegmentIndex==1){
                    NSArray *array =couponInfo;

                    if (page == 1) {
                        [listUnUseCouponArray removeAllObjects];
                        if (array.count>0) {
                            for (int i=0; i<array.count; i++) {
                                
                                Coupon *coupon = [[Coupon alloc]initWith:array[i]];
                                [listUnUseCouponArray addObject:coupon];
                                NSLog(@"redPacket%@",coupon.status);
                                
                            }
                            self.tableView2.hidden = NO;
                            self.tableView1.hidden = YES;
                              [self.tableView2 reloadData];
                            self.enptyView.hidden=YES;
                            [self.tableView2.mj_footer endRefreshing];
                        } else{
                            
                            self.enptyView.hidden=NO;
                            self.tableView2.hidden = YES;
                            self.tableView1.hidden = YES;
                        }
                    }else{
                        if (array.count>0) {
                            //
                            for (int i=0; i<array.count; i++) {
                                
                                Coupon *coupon = [[Coupon alloc]initWith:array[i]];
                                [listUnUseCouponArray addObject:coupon];
                                NSLog(@"redPacket%@",coupon.status);
                                
                            }
                            if (listUnUseCouponArray.count>0) {
                                self.tableView2.hidden = NO;
                                self.tableView1.hidden = YES;
                                [self.tableView2 reloadData];
                                [self.tableView2.mj_footer endRefreshing];
                            }else{
                                [self.tableView2.mj_footer endRefreshingWithNoMoreData];
                                
                            }
                            
                        }
                    }
        }
        
        }else{
            if (page == 1){
                
                self.enptyView.hidden=NO;
                self.tableView2.hidden = YES;
                self.tableView1.hidden = YES;
            }
              [self.tableView1.mj_footer endRefreshingWithNoMoreData];
            [self.tableView2.mj_footer endRefreshingWithNoMoreData];
        }
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)getCouponByStateClient:(NSString*)isValid{
    NSDictionary *Info;
    @try {
        
        NSString *cardCode = self.curUser.cardCode;
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        Info = @{@"cardCode":cardCode,
                 @"isValid":isValid,
                 @"page":pagestr,
                 @"pageSize":@"10"
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan getCouponByStateSms:Info];
    }
    
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
         

            cell.sourceLab.text = [NSString stringWithFormat:@"来源：%@",coupon.couponSource];
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
         
            cell.sourceLab.text = [NSString stringWithFormat:@"来源：%@",coupon.couponSource];
            cell.dateLab.text = [NSString stringWithFormat:@"截止时间：%@",coupon.invalidTime];
            cell.descriptionLab.text=[NSString stringWithFormat:@"单笔订单满%@可用",coupon.quota];
            cell.bjImage.image = [UIImage imageNamed:@"bj_overdue"];
        }
    }


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
