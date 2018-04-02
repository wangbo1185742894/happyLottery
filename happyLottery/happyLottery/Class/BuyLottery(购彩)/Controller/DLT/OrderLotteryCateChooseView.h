//
//  OrderLotteryCateChooseView.h
//  Lottery
//
//  Created by Yang on 15/6/22.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {

    TableShowTypeLotteryCateChoose,
    TableShowTypeOrderStateChoose,
    //10.26
    TableShowZHTypeOrderStateChoose,
    TableShowZHCatchStateChoose,
    TableShowZHRightStateChoose,
    TableShowHeMaiRightStateChoose,
    TableShowHeMaiDaTingRightStateChoose,
    
}TableShowType;

@protocol OrderLotteryCateChooseViewDelegate <NSObject>

-(void)orderStateChoosed:(NSDictionary *)orderState;
-(void)lotteryCateChoosed:(NSDictionary *)lotteryInfo;
-(void)zhStateChoose:(NSDictionary *)state;
-(void)zhCatchChoose:(NSDictionary *)catchState;
@end


@interface OrderLotteryCateChooseView : UIView<UITableViewDelegate,UITableViewDataSource>{

    UIControl * backControl;
    UITableView * tableView_;
    TableShowType tableShowType;
    UIImageView *backImage;
}
@property (nonatomic ,strong)     NSArray * sourceArray;
@property (nonatomic ,weak) id<OrderLotteryCateChooseViewDelegate>delegate;
@property (nonatomic ,strong) NSDictionary * curSelectStateInfo;
@property (nonatomic ,strong) NSDictionary * curSelectLotteryInfo;
@property (nonatomic , strong) NSDictionary * zhstateSelect;
@property (nonatomic , strong) NSDictionary * zhCatchSelect;
@property (nonatomic , strong) NSString *isCTZQ;

-(void)show:(UIView *)supView withType:(TableShowType)type;
-(void)hide;
@end
