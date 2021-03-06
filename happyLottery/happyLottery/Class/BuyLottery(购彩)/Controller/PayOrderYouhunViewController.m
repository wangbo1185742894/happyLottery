//
//  PayOrderYouhunViewController.m
//  happyLottery
//
//  Created by 王博 on 2018/1/18.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "PayOrderYouhunViewController.h"
#import "PayOrderLegViewController.h"
#import "MyCouponTableViewCell.h"

#define KMyCouponTableViewCell @"MyCouponTableViewCell"
@interface PayOrderYouhunViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    Coupon *selectCoupon;
    Coupon *oldCoupon;
    NSInteger selectIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tabYouhuiquanLIst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDis;
@property (weak, nonatomic) IBOutlet UIButton *actionSubmit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;

@end

@implementation PayOrderYouhunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可用优惠券";
    self.topDis.constant = NaviHeight;
    self.bottomDis.constant = BOTTOM_BAR_HEIGHT;
    for (Coupon * model in self.couponList) {
        if (model.isSelect == YES) {
            oldCoupon = model;
        }
    }
    
    [self setTableView];
    [self.tabYouhuiquanLIst reloadData];
}

-(void)setTableView{
    self.tabYouhuiquanLIst.delegate = self;
    self.tabYouhuiquanLIst.dataSource = self;
    self.tabYouhuiquanLIst.rowHeight = 111;
    
    [self.tabYouhuiquanLIst registerNib:[UINib nibWithNibName:@"MyCouponTableViewCell" bundle:nil] forCellReuseIdentifier:KMyCouponTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMyCouponTableViewCell];
    [cell loadData:self.couponList[indexPath.row]];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couponList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectIndex = indexPath.row;
    selectCoupon = self.couponList[indexPath.row];
    for (Coupon * model in self.couponList) {
        if (selectCoupon == model) {
            selectCoupon.isSelect = !selectCoupon.isSelect;
            if (selectCoupon.isSelect == NO) {
                selectCoupon = nil;
            }
        }else{
            model.isSelect = NO;
        }
    }
    [self.tabYouhuiquanLIst reloadData];
    
}
- (IBAction)actionSubmitCoupon:(UIButton *)sender {
    self.payOrderVC.curSelectCoupon = selectCoupon;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)navigationBackToLastPage{
    for (Coupon * model in self.couponList) {
        if (model == oldCoupon) {
            model.isSelect = YES;
        }else{
            model.isSelect = NO;
        }
    }
    self.payOrderVC.curSelectCoupon = oldCoupon;
    [super navigationBackToLastPage];
}

@end
