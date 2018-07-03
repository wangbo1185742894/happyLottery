//
//  Utility.h
//
//  Created by AMP on 9/9/12.
//  Copyright 2011 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (id) objFromJson: (NSString*) jsonStr;
+ (NSString *)hashIDForString : (NSString *)str;
+(BOOL)isIpad;
+(NSString *)stringFromMD5 : (NSString *)str;
+(NSString *)urlEncode : (NSString *)string;
+(UIColor *)colorFromR : (CGFloat) rv g : (CGFloat) gv b : (CGFloat)bv;
+ (NSString *) legalString: (id) str;
+(BOOL)verifyString : (NSString *)str withRegex : (NSString *)regex;
+(BOOL)isPortrait;
+(BOOL)isIOS7;
+(BOOL)isIOS6;
+(BOOL)isIOS5;
+(BOOL)isIOS7Later;
+(BOOL)isIOS8Later;
+(BOOL)isIOS11Later;
+(BOOL)isLegalURL : (NSString *)urlStr;
+(BOOL)isLegalString : (NSString *)str;
+(BOOL)isLegalEmailAddress : (NSString *)emailStr;
+(BOOL)isLegalPassword : (NSString *)pwd;
+(BOOL)isLegalTelNumber:(NSString *) telNumber;
+ (BOOL)isLegalUserIdCard: (NSString *) idCard;
+(NSString *)showPrice : (float)price;
+ (BOOL) is4Screen;
+ (NSString *) curLanguage;
+ (NSString*) bundleVersion;
+ (BOOL)isNumeric:(NSString *)code;
+ (void) exportAsPDF:(UIView*) pageView path:(NSString *) filePath;
// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString;
//+ (NSUInteger) getFactorial: (NSUInteger) baseNum;
+ (NSUInteger) getFactorial: (NSUInteger) baseNum tillNumber: (NSUInteger) tillNum;
+ (NSUInteger) getArrangeGroup:(NSUInteger)baseNum  withExponent:(NSUInteger)exponent;

+ (NSNumber *)stringToNumber:(NSString *)string;
+ (NSString *)NumberToString:(NSNumber *)number;
+(NSString*)getTheCorrectNum:(NSString*)tempString;
@end

@interface Utility (Date)
+ (NSString *)timeStringFromFormat : (NSString *)format withTI : (double)ti;
+(NSString *)timeStringFromFormat : (NSString *)format withDate : (NSDate *)date;
+(NSString *)literalStringTI : (double)ti;
+ (NSDate *) dateFromDateStr: (NSString *) str withFormat: (NSString *) format;
+(double)curTimeinterval;
+(NSString *)curTimeintervalStr;
+(NSDate *)dateFromTI : (NSTimeInterval)ti;
+(double)timeintervalSinceTI : (NSTimeInterval)ti;
+(BOOL)isValidURLString : (NSString *)urlStr;
+(double)timeintervalForDate : (NSDate *)date;
+ (NSString *)weekDayGetForTimeString:(NSString *)time;
+ (NSString*) JsonFromId: (id) obj;
+(BOOL)isIOS11After;
+(BOOL)isIphoneX;
+(BOOL)isIphone5s;
+ (NSString *)weekDayGetForTimeDate:(NSDate *)date;
+ (NSString*)iphoneType;
+(NSString*)getTheCorrectNum:(NSString*)tempString;
+(NSString *)getCurrentDeviceModel;
@end
