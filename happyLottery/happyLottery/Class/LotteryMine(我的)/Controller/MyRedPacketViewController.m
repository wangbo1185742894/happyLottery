//
//  MyRedPacketViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MyRedPacketViewController.h"
#import "MyRedPacketTableViewCell.h"
#import "RedPacket.h"

@interface MyRedPacketViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listUseRedPacketArray;
    NSMutableArray *listUnUseRedPacketArray;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;


@end

@implementation MyRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的红包";
    self.memberMan.delegate = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
   
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    listUseRedPacketArray = [[NSMutableArray alloc]init];
    listUnUseRedPacketArray = [[NSMutableArray alloc]init];
    
    [self getRedPacketByStateClient:@"true"];
    //[self openRedPacketClient];
}
- (IBAction)segmentClick:(id)sender {
    
    switch( self.segment.selectedSegmentIndex)
    {
        case 0:
     
        [self getRedPacketByStateClient:@"true"];
            
        case 1:
      
        [self getRedPacketByStateClient:@"false"];
            
        default:
            break;
    }
}

-(void)getRedPacketByStateSms:(NSDictionary *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        if (redPacketInfo!=nil) {
            [listUseRedPacketArray removeAllObjects];
            NSArray *array = redPacketInfo;
            for (int i=0; i<array.count; i++) {
                RedPacket *redPacket = [[RedPacket alloc]initWith:array[i]];
                [listUseRedPacketArray addObject:redPacket];
                
            }
            [self.tableView1 reloadData];
        }
      
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)openRedPacketSms:(NSDictionary *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

-(void)getRedPacketByStateClient:(NSString*)isValid{
    NSDictionary *Info;
    @try {
        
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"isValid":isValid
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan getRedPacketByStateSms:Info];
    }
    
}

-(void)openRedPacketClient{
    NSDictionary *Info;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"id":cardCode
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan openRedPacketSms:Info];
    }
    
}

#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView ==self.tableView1) {
        if (listUseRedPacketArray.count > 0) {
            return listUseRedPacketArray.count;
        }
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    MyRedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRedPacketTableViewCell" owner:self options:nil] lastObject];
    }
    
    
        if (listUseRedPacketArray.count > 0) {
            RedPacket *redPacket = listUseRedPacketArray[indexPath.row];
           
            if (self.segment.selectedSegmentIndex == 0) {
                 cell.packetImage.image = [UIImage imageNamed:@"click"];
                cell.endImage.hidden = YES;
            }else if(self.segment.selectedSegmentIndex==1){
                 cell.packetImage.image = [UIImage imageNamed:@"not"];
                cell.endImage.hidden = NO;
            }
            cell.nameLab.text = redPacket.redPacketContent;
            cell.sourceLab.text = redPacket.redPacketChannel;
            cell.endTimeLab.text = [NSString stringWithFormat:@"%@过期",redPacket.endValidTime];
        }
    
 
    
    
    return cell;
}


#pragma UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0;
    //    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
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
