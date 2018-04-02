//
//  LotteryNumber.h
//  Lottery
//
//  Created by AMP on 5/24/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XHNumberView;

@interface LotteryNumber : NSObject
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSString *numberDesc;
@property (nonatomic, strong) NSString *numberColor;
@property int numberValue;
@property (nonatomic , weak) XHNumberView * xHNumberView;

@end
