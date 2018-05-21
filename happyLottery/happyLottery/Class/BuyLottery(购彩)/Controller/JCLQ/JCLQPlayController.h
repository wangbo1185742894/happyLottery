//
//  JCLQPlayController.h
//  Lottery
//
//  Created by 王博 on 16/8/16.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "BaseViewController.h"

@interface JCLQPlayController : BaseViewController
@property (assign,nonatomic)SchemeType fromSchemeType;
@property (nonatomic, strong)Lottery *lottery;
@property (nonatomic, strong)NSString *tempResource;

@end
