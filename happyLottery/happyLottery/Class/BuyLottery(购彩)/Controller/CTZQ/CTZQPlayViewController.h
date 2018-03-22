//
//  CTZQPlayViewController.h
//  Lottery
//
//  Created by only on 16/3/23.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTZQTransaction.h"
#import "Lottery.h"

@interface CTZQPlayViewController : BaseViewController
@property (nonatomic, strong)Lottery *lottery;
@property (nonatomic, strong)NSString *tempResource;
@property (nonatomic, strong)CTZQTransaction *transaction;

@end
