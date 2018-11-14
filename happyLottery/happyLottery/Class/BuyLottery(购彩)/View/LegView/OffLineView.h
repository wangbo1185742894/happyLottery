//
//  OffLineView.h
//  happyLottery
//
//  Created by LYJ on 2018/9/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OffLineViewDelegate <NSObject>

- (void)alreadyRechare;

@end

@interface OffLineView : UIView


@property (nonatomic,strong)NSString *orderNo;

@property (nonatomic,strong)NSString *weiXianCode;

@property (nonatomic,strong)NSString *telephone;

@property (nonatomic,weak)id <OffLineViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *liShiLsb;

- (void)loadDate;

- (void)closeView;


@end
