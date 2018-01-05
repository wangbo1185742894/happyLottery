//
//  JCFATransaction.h
//  Lottery
//
//  Created by onlymac on 2017/11/1.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BaseTransaction.h"
#import "YuCeScheme.h"
#import "jcBetContent.h"
@interface JCFATransaction : BaseTransaction

@property (nonatomic,strong)YuCeScheme *yuceScheme;

@property (nonatomic,strong)NSString * identifier;
@property (assign,nonatomic)NSInteger  beiTou;
@property(nonatomic,strong)NSString * issueNumber;


-(NSMutableDictionary*)submitParaDicScheme;
- (id)lottDataScheme;




@end
