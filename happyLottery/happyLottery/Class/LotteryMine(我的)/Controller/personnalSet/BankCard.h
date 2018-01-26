//
//  BankCard.h
//  happyLottery
//
//  Created by LYJ on 2017/12/25.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCard : BaseModel

@property(nonatomic,strong)NSString *bankName;
@property(nonatomic,strong)NSString *bankShortName;
@property(nonatomic,strong)NSString *bankEposit;
@property(nonatomic,strong)NSString *bankNumber;
@property(nonatomic,strong)NSString *bankUserName;
@property(nonatomic,strong)NSString *cardCode;
@property(nonatomic,strong)NSString *memberId;
@property(nonatomic,strong)NSString *tempBankNumber;
@property(nonatomic,strong)NSString *_id;
@property(nonatomic,strong)NSString *useDefault;

@end
