//
//  UMChongZhiViewController.h
//  Lottery
//
//  Created by 王博 on 2017/8/17.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeYCModel.h"
@interface UMChongZhiViewController : BaseViewController
@property(nonatomic,strong)JczqShortcutModel * model;
@property(nonatomic,strong)NSString *curPlayType;
@property(nonatomic,assign)BOOL isHis;
@end
