//
//  SOAPRequest.h
//  Lottery
//
//  Created by YanYan on 6/8/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOAPConstant.h"

@interface SOAPRequest : NSObject


@property (nonatomic, strong) NSString *apiName;
@property (nonatomic, strong) NSDictionary *paramDic;

- (NSString *) getSOAPMessage;
- (NSString *) getClient;
@end
