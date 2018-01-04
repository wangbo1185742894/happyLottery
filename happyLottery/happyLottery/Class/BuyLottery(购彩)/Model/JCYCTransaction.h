//
//  JCYCTransaction.h
//  Lottery
//
//  Created by 王博 on 2017/10/19.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BaseTransaction.h"
#import "JczqShortcutModel.h"
@interface JCYCTransaction : BaseTransaction
@property(nonatomic,strong)JczqShortcutModel * shortCutModel;

@property (nonatomic,strong)NSString * identifier;
@property (assign,nonatomic)NSInteger  beiTou;
@property(nonatomic,strong)NSString * issueNumber;

@end
