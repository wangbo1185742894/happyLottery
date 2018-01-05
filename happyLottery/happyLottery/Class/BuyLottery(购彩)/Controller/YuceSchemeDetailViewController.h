//
//  YuceSchemeDetailViewController.h
//  Lottery
//
//  Created by onlymac on 2017/10/12.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BaseViewController.h"
#import "YuCeScheme.h"
@interface YuceSchemeDetailViewController : BaseViewController
@property(nonatomic,strong)YuCeScheme *scheme;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,assign)NSInteger  index;
@property (copy, nonatomic) NSString *xuQiuBtnTag;
@end
