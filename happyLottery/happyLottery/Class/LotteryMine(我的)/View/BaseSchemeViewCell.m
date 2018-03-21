//
//  BaseSchemeViewCell.m
//  Lottery
//
//  Created by 王博 on 17/4/25.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BaseSchemeViewCell.h"

@implementation BaseSchemeViewCell


- (id) objFromJson: (NSString*) jsonStr {
    if (jsonStr == nil) {
        return @"";
    }
    NSData * jsonData = [jsonStr dataUsingEncoding: NSUTF8StringEncoding];
    NSError * error=nil;
    NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    return parsedData;
}

-(UILabel*)creactLab:(NSString *)title andFrame:(CGRect)frame{
    
    UILabel *tempLab = [[UILabel alloc]initWithFrame:frame];
    if (![title isKindOfClass:[NSString class]]) {
        tempLab.attributedText = (NSAttributedString*)title;
        tempLab.textAlignment = NSTextAlignmentCenter;
    }else{
        tempLab.text = title;
        tempLab.textAlignment = NSTextAlignmentCenter;
        tempLab.font = [UIFont systemFontOfSize:13];
        tempLab.textColor = TEXTGRAYCOLOR;
    }
    tempLab.backgroundColor = RGBCOLOR(245, 245, 245);
    tempLab.adjustsFontSizeToFitWidth = YES;
    tempLab.numberOfLines = 0;
    return tempLab;
    
}

-(UILabel*)creactAttributedLab:(NSAttributedString *)title andFrame:(CGRect)frame{
    
    UILabel *tempLab = [[UILabel alloc]initWithFrame:frame];
    tempLab.attributedText = title;
    tempLab.textAlignment = NSTextAlignmentCenter;
    
    
    tempLab.backgroundColor = RGBCOLOR(245, 245, 245);
    tempLab.adjustsFontSizeToFitWidth = YES;
    tempLab.numberOfLines = 0;
    return tempLab;
    
}

-(NSString *)getPassType:(NSString *)passType{
    
    @try {
        NSArray *passTypes = [passType componentsSeparatedByString:@","];
        NSString *trPassType;
        NSMutableArray *types = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *type in passTypes) {
            if ([type isEqualToString:@"P1"]) {
                 [types addObject: @"单场"];
            }else{
                
                NSString * temp  = [type stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
                
                [types addObject:[temp stringByReplacingOccurrencesOfString:@"_" withString:@"串"]];
            }
        }
        
        trPassType = [types componentsJoinedByString:@","];
        

        return trPassType;
    } @catch (NSException *exception) {
        return @"";
    }

}

@end
