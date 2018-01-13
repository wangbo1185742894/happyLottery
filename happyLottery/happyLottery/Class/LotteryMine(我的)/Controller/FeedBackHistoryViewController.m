//
//  FeedBackHistoryViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FeedBackHistoryViewController.h"
#import "FeedBackHistoryTableViewCell.h"

static NSString * const ReuseIdentifier = @"cell";
@interface FeedBackHistoryViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度

@end

@implementation FeedBackHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"历史反馈";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
      self.memberMan.delegate = self;
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
     [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([FeedBackHistoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
    page=1;
    [self FeedBackHistoryClient];
    
}

-(void)FeedBackHistoryClient{
    NSDictionary *Info;
    @try {
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@"10"
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan getFeedbackListSms:Info];
    }
    
}

-(void)getFeedbackListSms:(NSArray *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    NSLog(@"getFeedbackList%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        //[self showPromptText: @"现金流水成功" hideAfterDelay: 1.7];
//        NSEnumerator *enumerator = [boltterInfo objectEnumerator];
//        id object;
//        if ((object = [enumerator nextObject]) != nil)  {
//            
//            NSArray *array =boltterInfo;
//            
//            
//            if (page == 1) {
//                [listScoreBlotterArray removeAllObjects];
//                if (array.count>0) {
//                    for (int i=0; i<array.count; i++) {
//                        CashBoltter *cashBoltter = [[CashBoltter alloc]initWith:array[i]];
//                        [listScoreBlotterArray addObject:cashBoltter];
//                        
//                    }
//                    [self.tableView1.mj_footer endRefreshing];
//                    self.tableView1.hidden = NO;
//                    self.tableView2.hidden = YES;
//                    [self.tableView1 reloadData];
//                    self.emptyView.hidden=YES;
//                } else{
//                    
//                    self.emptyView.hidden=NO;
//                    self.tableView2.hidden = YES;
//                    self.tableView1.hidden = YES;
//                }
//            }else{
//                if (array.count>0) {
//                    //
//                    for (int i=0; i<array.count; i++) {
//                        
//                        CashBoltter *cashBoltter = [[CashBoltter alloc]initWith:array[i]];
//                        [listScoreBlotterArray addObject:cashBoltter];
//                        
//                    }
//                    if (listScoreBlotterArray.count>0) {
//                        self.tableView1.hidden = NO;
//                        self.tableView2.hidden = YES;
//                        [self.tableView1 reloadData];
//                        [self.tableView1.mj_footer endRefreshing];
//                    }else{
//                        [self.tableView1.mj_footer endRefreshingWithNoMoreData];
//                        
//                    }
//                    
//                }
//            }
//        }else{
//            [self.tableView1.mj_footer endRefreshingWithNoMoreData];
//            if (page == 1){
//                
//                self.emptyView.hidden=NO;
//                self.tableView2.hidden = YES;
//                self.tableView1.hidden = YES;
//            }
//        }
//        
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedBackHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height)
    {
        return height.floatValue;
    }
    else
    {
        return 120;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath
{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
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
