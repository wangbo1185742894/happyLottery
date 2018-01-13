//
//  TopUpsViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "TopUpsViewController.h"


#define KPayTypeListCell @"PayTypeListCell"
@interface TopUpsViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource,LotteryManagerDelegate,UITextFieldDelegate,UIWebViewDelegate>
{
    NSMutableArray <ChannelModel *>*channelList;
    ChannelModel *itemModel;
}
@property (weak, nonatomic) IBOutlet UILabel *labBanlence;
@property (weak, nonatomic) IBOutlet UITextField *txtChongZhiJIne;
@property (weak, nonatomic) IBOutlet UIButton *haveReadBtn;
@property (weak, nonatomic) IBOutlet UIButton *memberDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITableView *tabChannelList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chongZhiSelectItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabPayListHeight;
@property (weak, nonatomic) IBOutlet UIWebView *payWebView;

@end

@implementation TopUpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.payWebView.delegate = self;
    self.memberMan.delegate = self;
    self.lotteryMan.delegate =self;
    [self setTableView];
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    self.txtChongZhiJIne.delegate = self;
    [self getListByChannel];
    [self setItem:nil];
}
-(void)setTableView{
    self.tabChannelList.dataSource =self;
    self.tabChannelList.delegate = self;
    self.tabChannelList.rowHeight = 60;
    [self.tabChannelList registerClass:[PayTypeListCell class] forCellReuseIdentifier:KPayTypeListCell];
}

-(void)setItem:(UIButton *)sender{
    
    for (UIButton *item in self.chongZhiSelectItem) {
        
        item.selected = NO;
        
        
    }
    sender.selected = !sender.selected;
    
    for (UIButton *item in self.chongZhiSelectItem) {
        
        if (sender.selected == YES) {
            self.txtChongZhiJIne.text = [NSString stringWithFormat:@"%ld",sender.tag];
        }
        
        if (item.selected == YES) {
         item.layer.borderColor = SystemGreen.CGColor;
        [item setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(208, 244, 233)] forState:UIControlStateSelected];

        }else{
            item.layer.borderColor = TFBorderColor.CGColor;
            [item setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        }
        item.layer.borderWidth = 1;
        
        item.layer.cornerRadius = 4;
        item.layer.masksToBounds = YES;
    }
    
}

-(void)rechargeSmsIsSuccess:(BOOL)success andPayInfo:(NSDictionary *)payInfo errorMsg:(NSString *)msg{
    
    if (success) {
        if ([itemModel.channel isEqualToString:@"SDALI"]) {
            [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payInfo[@"qrCode"]]]];
        }else if ([itemModel.channel isEqualToString:@"WFTWX"]){
            [self.payWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:payInfo[@"payInfo"]]]];
        }
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

- (IBAction)haveead:(id)sender {
}
- (IBAction)memberDetail:(id)sender{
}
- (IBAction)commitBtnClick:(id)sender {
    [self commitClient];
}
//params - String cardCode 会员卡号, RechargeChannel channel 充值渠道, BigDecimal amounts 充值金额
-(void)commitClient{
    
    NSDictionary *rechargeInfo;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *checkCode = self.txtChongZhiJIne.text;
        
        for (ChannelModel *model in channelList) {
            if (model.isSelect == YES) {
                itemModel= model;
                break;
            }
        }
        rechargeInfo = @{@"cardCode":cardCode,
                          @"channel":itemModel.channel,
                          @"amounts":checkCode,
                          };
        
    } @catch (NSException *exception) {
        rechargeInfo = nil;
    } @finally {
        [self.memberMan rechargeSms:rechargeInfo];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getListByChannel{
    
    [self.lotteryMan listByRechargeChannel:@{@"channelCode":CHANNEL_CODE}];
}

-(void)gotListByRechargeChannel:(NSArray *)infoArray errorMsg:(NSString *)msg{
    channelList = [NSMutableArray arrayWithCapacity:0];
    self.tabChannelList.bounces = NO;
    
    if (infoArray == nil || infoArray.count == 0) {
        [self showPromptText:msg hideAfterDelay:1.7 ];
        [self.tabChannelList reloadData];
        self.tabPayListHeight.constant = channelList.count * self.tabChannelList.rowHeight;
        return;
    }
    
    for (NSDictionary *itemDic in infoArray) {
        ChannelModel *model = [[ChannelModel alloc]initWith:itemDic];
        if ([model.channelValue boolValue] == YES) {
            [channelList addObject:model];
        }
    }
    self.tabPayListHeight.constant = channelList.count * self.tabChannelList.rowHeight;
    [self.tabChannelList reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return channelList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayTypeListCell *cell = [tableView dequeueReusableCellWithIdentifier:KPayTypeListCell];
    [cell chongzhiLoadDataWithModel:channelList[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (ChannelModel *model in channelList) {
        model.isSelect = NO;
    }
    channelList[indexPath.row].isSelect = YES;
    [self.tabChannelList reloadData];
}
- (IBAction)actionSelectItem:(UIButton *)sender {
    [self setItem:sender];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self setItem:nil];
    return YES;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *strUrl = [NSString stringWithFormat:@"%@",request.URL];
    if ([strUrl hasPrefix:@"alipays"] || [strUrl hasPrefix:@"weixin"] ) {
        [[UIApplication sharedApplication] openURL:request.URL];
    }
    return YES;
}

@end
