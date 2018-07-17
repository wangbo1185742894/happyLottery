//
//  CashInfoViewController.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    CashInfoGoucai = 0,
    CashInfoChongzhi,
    CashInfoZhuihao,
    CashInfoPaijiang,
    CashInfoTixian,
    CashInfoCaijin,
    CashInfoYongjin,
    CashInfoFanyong,
}CashInfoType;

@interface CashInfoViewController : BaseViewController
-(void)setMenuOffset:(CashInfoType)index;
@end
