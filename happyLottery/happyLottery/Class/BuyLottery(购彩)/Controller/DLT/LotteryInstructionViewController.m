//
//  LotteryInstructionViewController.m
//  Lottery
//
//  Created by YanYan on 6/7/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "LotteryInstructionViewController.h"

#import "LotteryInstructionDetailViewController.h"
#define CellH 55

@interface LotteryInstructionViewController () {
    

//    NSArray *lotteryData;
    UITableView *tableViewContent_;
}

@property(nonatomic,strong)NSArray*lotteryData;

@end

@implementation LotteryInstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray * array = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    // Do any additional setup after loading the view from its nib.
    self.lotteryData = @[array[0],array[1],array[2]];
    self.title = TextPageTitleInstruction;
    [self showLoadingViewWithText: TextLoading];
}

-(NSArray*)lotteryData{

_lotteryData =[NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"LotteryInstructionConfig" ofType: @"plist"]];
    return _lotteryData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    if (tableViewContent_ == nil) {
        CGRect tableViewFrame = self.view.frame;
        tableViewFrame.origin.x += 10;
        tableViewFrame.origin.y += 10;
        tableViewFrame.size.width -= 20;
        tableViewFrame.size.height = 440;
        tableViewContent_ = [[UITableView alloc] initWithFrame: tableViewFrame style: UITableViewStylePlain];
        tableViewContent_.scrollEnabled = NO;
        tableViewContent_.backgroundColor = RGBCOLOR(239, 239, 244);
        tableViewContent_.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableViewContent_.layer.cornerRadius = 5;
        tableViewContent_.delegate = self;
        tableViewContent_.dataSource = self;
        [self.view addSubview: tableViewContent_];
    }
    [self hideLoadingView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_lotteryData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * lb= [[UILabel alloc] initWithFrame:CGRectMake(0, CellH-1, tableView.frame.size.width, 1)];
        lb.backgroundColor = RGBCOLOR(240, 240, 240);
    }
    
    NSDictionary *lotteryInfoDic = _lotteryData[indexPath.row];
    cell.imageView.image = [UIImage imageNamed: lotteryInfoDic[@"icon"]];
    cell.textLabel.text = lotteryInfoDic[@"Name"];
    {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *view;
        if ([cell subviews].count>1) {
            view = [cell subviews][1];
        }
        
        CGRect downLineFrame = view.frame;
        [view removeFromSuperview];
        if ([self respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            downLineFrame.origin.y = [self tableView:tableView heightForRowAtIndexPath:indexPath] - SEPHEIGHT;
        }else{
            downLineFrame.origin.y = 44 - SEPHEIGHT;
        }
        
        downLineFrame.origin.x = SEPLEADING;
        downLineFrame.size.width = tableView.frame.size.width - 2*SEPLEADING;
        downLineFrame.size.height = SEPHEIGHT;
        UILabel *downLine = [[UILabel alloc] init];
        downLine.backgroundColor = SEPCOLOR;
        NSInteger lineCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
        if (indexPath.row == lineCount - 1) {
            downLineFrame.origin.x = 0;
            downLineFrame.size.width = tableView.frame.size.width;
            //            downLineFrame.origin.y -= 1;
            //            downLine.frame =
        }//else{
        //downLine.frame = downLineFrame;
        //        }
        downLine.frame = downLineFrame;
        [cell addSubview:downLine];
        
        if (indexPath.row == 0) {
            UILabel *upLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, SEPHEIGHT)];
            upLine.backgroundColor = SEPCOLOR;
            [cell addSubview:upLine];
            
        }
        
        
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = CellSelectedColor;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    NSDictionary *lotteryInfoDic = _lotteryData[indexPath.row];
    LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
    detailVC.lotteryDetailDic = lotteryInfoDic;
    [self.navigationController pushViewController: detailVC animated: YES];
    
}

-(void)toDetailVC:(NSInteger)index andTarget:(UIViewController*)targetVC{
    
    NSDictionary *lotteryInfoDic = self.lotteryData[index];
    LotteryInstructionDetailViewController *detailVC = [[LotteryInstructionDetailViewController alloc] initWithNibName: @"LotteryInstructionDetailViewController" bundle: nil];
    detailVC.lotteryDetailDic = lotteryInfoDic;
    
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    [targetVC.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    

    [targetVC.navigationController pushViewController: detailVC animated: YES];
}
@end
