//
//  JCZQPlayViewController.h
//  happyLottery
//
//  Created by 王博 on 2017/12/11.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"

@interface JCZQPlayViewController : BaseViewController
@property(nonatomic,assign)JCZQPlayType playType;

//自购, 合买, 追号, 推荐, 发单, 跟单
@property (assign,nonatomic)SchemeType fromSchemeType;

@end
