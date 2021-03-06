//
//  UserInfoDetailViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/6.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "UserInfoDetailViewController.h"
#import "MGLabel.h"

@interface UserInfoDetailViewController ()<MemberManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labLeft;
@property (weak, nonatomic) IBOutlet MGLabel *labRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;

@end

@implementation UserInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.memberMan.delegate = self;
    if ([self.model isMemberOfClass:[ChasePrepayModel class]]) {
        ChasePrepayModel *itemModel = (ChasePrepayModel *)self.model;
        [self.memberMan chaseCompleteCount:@{@"chaseSchemeNo":itemModel.chaseSchemeNo}];
    }else{
        [self loadData];
    }
    _topDis.constant = NaviHeight;
    self.title = @"明细详情";
}

-(void)loadData{
    self.labLeft .text = [self.model getLeftTitle];
    NSString *title = [[self.model getRightTitle] stringByReplacingOccurrencesOfString:@"#" withString:@""];
    self.labRight.text = title;
    NSArray *keyList = [[self.model getRightTitle] componentsSeparatedByString:@"#"];
    if (keyList.count > 1) {
        NSString *keyWord = [keyList[1] stringByReplacingOccurrencesOfString:@"#" withString:@""];
        self.labRight.keyWord = keyWord;
        self.labRight.keyWordColor = SystemGreen;
    }
}

-(void)chaseCompleteCount:(NSDictionary *)paraDic errorMsg:(NSString *)msg{
    if (paraDic == nil) {
        return;
    }
    ChasePrepayModel *itemModel = (ChasePrepayModel *)self.model;
    itemModel.lotteryCode = paraDic[@"lotteryCode"];
    itemModel.totalCatch = paraDic[@"totalCatch"];
    itemModel.catchIndex = paraDic[@"catchIndex"];
    [self loadData];
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

