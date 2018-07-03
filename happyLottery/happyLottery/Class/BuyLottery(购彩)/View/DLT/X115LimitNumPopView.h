//
//  X115LimitNumPopView.h
//  Lottery
//
//  Created by 王博 on 2017/12/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol X115LimitNumPopViewDelegate
-(void)goonBuy;
@end

@interface X115LimitNumPopView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labLimitInfo;
@property (weak, nonatomic) IBOutlet UILabel *labDltLimitInfo;
@property(nonatomic,strong)id <X115LimitNumPopViewDelegate >delegate;
-(void)setLabLimitInfoText:(NSString *)text;
@end
