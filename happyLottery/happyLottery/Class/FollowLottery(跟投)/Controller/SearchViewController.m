//
//  SearchViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SearchViewController.h"
#import "HotFollowSchemeViewCell.h"
#define KHotFollowSchemeViewCell @"HotFollowSchemeViewCell"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UITextField *tfSearchKey;
@property (weak, nonatomic) IBOutlet UITableView *tabSearchResultList;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    [self setTextFiled];
    
}

-(void)setTextFiled{
    self.tfSearchKey.layer.cornerRadius = self.tfSearchKey.mj_h / 2;
    self.tfSearchKey.layer.masksToBounds = YES;
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@"请输入您所需的关键字" attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.tfSearchKey.attributedPlaceholder = firstPart;
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *rightView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftView.backgroundColor = [UIColor redColor];
    rightView.backgroundColor = [UIColor redColor];
    self.tfSearchKey.rightView = rightView;
    [rightView addTarget:self action:@selector(cleanKeyWord) forControlEvents:UIControlEventTouchUpInside];
    self.tfSearchKey.rightViewMode =  UITextFieldViewModeAlways;
    self.tfSearchKey.leftView =leftView ;
    self.tfSearchKey.leftViewMode =  UITextFieldViewModeAlways;
}

-(void)cleanKeyWord{
    self.tfSearchKey.text = @"";
}

-(void)setTableView{
    self.tabSearchResultList.delegate = self;
    self.tabSearchResultList.dataSource = self;

    [self.tabSearchResultList registerNib:[UINib nibWithNibName:KHotFollowSchemeViewCell bundle:nil] forCellReuseIdentifier:KHotFollowSchemeViewCell];

    [self.tabSearchResultList reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotFollowSchemeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHotFollowSchemeViewCell];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 200;
}

- (IBAction)actionBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)actionSearch:(id)sender {
}


@end
