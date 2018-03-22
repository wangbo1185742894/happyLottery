//
//  WBSelectView.h
//  select
//
//  Created by 王博 on 16/2/23.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBSelectViewDelegate <NSObject>

-(void)didSelect:(NSIndexPath*)indexPath;

@end

@interface WBSelectView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)cancelButton:(UIButton *)sender;
- (IBAction)backGroundButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;


@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)id <WBSelectViewDelegate>delegate;

@property (nonatomic,strong)NSArray* dataArray;

@end
