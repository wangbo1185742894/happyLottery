//
//  Utility.m
//
//  Created by AMP on 9/9/11.
//  Copyright 2011 AMP. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>
#import "Macro.h"
#import <sys/utsname.h>
#import <sys/sysctl.h> //设备类型
#import <SystemConfiguration/CaptiveNetwork.h> //网络状态
#import <CoreTelephony/CTCarrier.h> //运营商
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation Utility
+ (NSString *) hashIDForString : (NSString *) str {
    return [NSString stringWithFormat: @"%lu", (unsigned long)[str hash]];
}

+ (BOOL) isIpad {
    if ([[UIDevice currentDevice] respondsToSelector: @selector(userInterfaceIdiom)]) {
        return([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
    }

    return NO;
}
+ (id) objFromJson: (NSString*) jsonStr {
    if (jsonStr == nil) {
        return nil;
    }
    if (![jsonStr isKindOfClass:[NSString class]]) {
        return jsonStr;
    }
    NSData * jsonData = [jsonStr dataUsingEncoding: NSUTF8StringEncoding];
    NSError * error=nil;
    NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    return parsedData;
}
+ (NSString *) stringFromMD5: (NSString *) str {
    if (self == nil ||[str length] == 0)
        return nil;

    const char *value = [str UTF8String];

    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);

    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity: CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat: @"%02x", outputBuffer[count]];
    }

    return outputString;
}

+ (NSString *) urlEncode: (NSString *) string {
    NSString *newString = CFBridgingRelease( CFBridgingRetain( (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding) )) ) );
    if (newString) {
        return newString;
    }
    return @"";
}

+ (NSString *) legalString: (id) str {
    if (str == nil || [str isKindOfClass: [NSNull class]]) {
        return @"";
    }
    
    if ([str isKindOfClass: [NSString class]]) {
        if ([[str lowercaseString] rangeOfString: @"null"].location != NSNotFound) {
            return @"";
        }
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else {
        str = [str description];
    }
    return str;
}

+ (UIColor *) colorFromR: (CGFloat) rv g: (CGFloat) gv b: (CGFloat) bv {
    return [UIColor colorWithRed: rv / 255 green: gv / 255 blue: bv / 255 alpha: 1.0];
}

+ (NSArray *) runRegEx: (NSString *) regStr ForString: (NSString *) string {
    if (string == nil) {
        return nil;
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: regStr
                                  options: NSRegularExpressionCaseInsensitive
                                  error: &error];

    NSArray *matches = [regex matchesInString: string
                        options: 0
                        range: NSMakeRange(0, [string length])];

    return matches;
}

+ (BOOL) verifyString: (NSString *) str withRegex: (NSString *) regex {
    NSArray *result = [Utility runRegEx: regex ForString: str];
    if ([result count] == 1) {
        NSRange range = [result[0] range];
        if (range.length ==[str length]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL) isPortrait {
    UIInterfaceOrientation ori = [[UIApplication sharedApplication] statusBarOrientation];
    return ( (ori == UIInterfaceOrientationPortrait) || (ori == UIInterfaceOrientationPortraitUpsideDown));
}

+(BOOL)isIOS7Later{
    NSString *osVersionStr = [[UIDevice currentDevice] systemVersion];
    if ([osVersionStr floatValue] > 7.0 || [osVersionStr floatValue] == 7.0) {
        return YES;
    }else{
        return NO;
    }
    
}

+(BOOL)isIOS8Later{
    NSString *osVersionStr = [[UIDevice currentDevice] systemVersion];
    if ([osVersionStr floatValue] > 8.0 || [osVersionStr floatValue] == 8.0) {
        return YES;
    }else{
        return NO;
    }
    
}

+(BOOL)isIOS11After{
    NSString *osVersionStr = [[UIDevice currentDevice] systemVersion];
    if ([osVersionStr floatValue] < 11.0) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)isIOS10Later{
    NSString *osVersionStr = [[UIDevice currentDevice] systemVersion];
    if ([osVersionStr floatValue] > 10.0 || [osVersionStr floatValue] == 10.0) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)isIOS10Before{
    NSString *osVersionStr = [[UIDevice currentDevice] systemVersion];
    if ([osVersionStr floatValue] < 10.0) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)isIOS11Later{
    NSString *osVersionStr = [[UIDevice currentDevice] systemVersion];
    if ([osVersionStr floatValue] > 11.0 || [osVersionStr floatValue] == 11.0) {
        return YES;
    }else{
        return NO;
    }

}
+(BOOL)isIOS7 {
    NSString *osVersionStr = [[UIDevice currentDevice] systemVersion];
    if ([osVersionStr rangeOfString: @"7"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (BOOL) isIOS6 {
    NSString *osVersionStr = [[UIDevice currentDevice] systemVersion];
    if ([osVersionStr rangeOfString: @"6"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (BOOL) isIOS5 {
    NSString *osVersionStr = [[UIDevice currentDevice] systemVersion];
    if ([osVersionStr rangeOfString: @"5"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (BOOL) isLegalURL: (NSString *) urlStr {
    if ([urlStr rangeOfString: @"http" options: NSCaseInsensitiveSearch].location == NSNotFound) {
        return NO;
    }
    return YES;
}

+ (BOOL) isLegalEmailAddress: (NSString *) mailAddr {
    if ( ( ([mailAddr rangeOfString: @"@"].location == NSNotFound) ||
          ([mailAddr rangeOfString: @"."].location == NSNotFound) ) ) {
        return NO;
    }
    return YES;
}

+ (BOOL) isLegalPassword: (NSString *) pwd {
    if ([[Utility legalString: pwd] length] < 5) {
        return NO;
    }
    return YES;
}

+ (BOOL)isLegalUserIdCard: (NSString *) idCard{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

+(BOOL)isLegalTelNumber:(NSString *) telNumber{
//    @"^1+[3578]+\\d{9}" 电话号码正则修改。
    NSString *pattern = REG_PHONENUM_STR;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+ (BOOL) isLegalString: (NSString *) str {
    
    NSString *str1 = [NSString stringWithFormat:@"%@",str];
    if ( (str1 == nil) || !([str1 length] > 0) ) {
        return NO;
    }
    return YES;
}

+ (NSString *) showPrice: (float) price {
    return [NSNumberFormatter localizedStringFromNumber: @ (price)numberStyle: NSNumberFormatterCurrencyStyle];
}


+ (BOOL) is4Screen {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.height > 480) {
        return YES;
    }
    return NO;
}

+ (NSString *) curLanguage {
    NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

+ (NSString*) bundleVersion {
     NSString *versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    return versionString;
}

+ (BOOL)isNumeric:(NSString *)code{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString: code];
    
    if ([_NumericOnly isSupersetOfSet: myStringSet])
    {
        return YES;
    }
    return NO;
}

+ (void) exportAsPDF:(UIView*) pageView path:(NSString *) filePath
{
    // Create the PDF context using the default page size of 850 x 1100.
    UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageView.frame.size.width, pageView.frame.size.height), nil);
    
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [pageView.layer renderInContext:pdfContext];
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ([hexString hasPrefix: @"#"]) {
        [scanner setScanLocation:1]; // bypass '#' character
    }
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

//+ (NSUInteger) getFactorial: (NSUInteger) baseNum {
//    if (baseNum == 1) {
//        return 1;
//    }
//    return baseNum * [Utility getFactorial: (baseNum-1)];
//}
+ (NSUInteger) getFactorial: (NSUInteger) baseNum tillNumber: (NSUInteger) tillNum{
    if (baseNum == tillNum) {
        return 1;
    }
    return baseNum * [Utility getFactorial: (baseNum-1) tillNumber: (NSUInteger) tillNum];
}
+ (NSUInteger) getArrangeGroup:(NSUInteger)baseNum  withExponent:(NSUInteger)exponent{

    NSUInteger num =1;
    for (int i=0; i<exponent; i++) {
        num *=(baseNum-i);
    }
    return num;
}

+ (NSNumber *)stringToNumber:(NSString *)string{

    NSNumber * num = [NSNumber numberWithInt:[string intValue]];
    return num;
}
+ (NSString *)NumberToString:(NSNumber *)number{

    NSString * string = [NSString stringWithFormat:@"%d",[number intValue]];
    return string;
}



@end

@implementation Utility (Date)

+ (NSString *)timeStringFromFormat : (NSString *)format withTI : (double)ti {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat: format];
    NSDate *now = [NSDate dateWithTimeIntervalSince1970: ti];
    NSString *timeStr = [formater stringFromDate: now];
    return timeStr;
}

+ (NSDate *) dateFromDateStr: (NSString *) str withFormat: (NSString *) format {
    if (str == nil || format == nil) {
        return nil;
    }

    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formater setDateFormat: format];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formater setTimeZone:GTMzone];
    NSDate *date = [formater dateFromString: str];
    return date;
}

+ (NSString *) timeStringFromFormat: (NSString *) format withDate: (NSDate *) date {
    if (date == nil || format == nil) {
        return nil;
    }
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    
    [formater setDateFormat: format];
    NSString *timeStr = [formater stringFromDate: date];
    return timeStr;
}

+ (BOOL)timeCompareWithNSCalendarUnitMinute:(NSString *)timeStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:timeStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 比较时间
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:[NSDate date] toDate:oldDate options:0];
    if (components.minute >= 1) {
        return YES;
    } else {
        return NO;
    }
}


+ (NSString *) literalStringTI: (double) ti {
    NSDate *now = [NSDate date];
    NSDate *aDate = [Utility dateFromTI: ti];
    NSString *nowString = [[now description] substringToIndex: 10];
    NSString *aDateString = [[aDate description] substringToIndex: 10];
    if ([nowString isEqualToString: aDateString]) {
        return NSLocalizedString(@"today", "today text");
    } else {
        return [Utility timeStringFromFormat: @"MM-dd" withTI: ti];
    }
    return nil;
}

+ (NSTimeInterval) curTimeinterval {
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    return ti;
}

+ (NSString *) curTimeintervalStr {
    return FormatStr(@"%.0f", [Utility curTimeinterval]);
}

+ (NSDate *) dateFromTI: (NSTimeInterval) ti {
    return [NSDate dateWithTimeIntervalSince1970: ti];
}

+ (double) timeintervalSinceTI: (NSTimeInterval) ti {
    NSDate *date = [NSDate date];
    NSTimeInterval nowti = [date timeIntervalSince1970];
    return nowti - ti;
}

+ (BOOL) isValidURLString: (NSString *) urlStr {
    if ([urlStr rangeOfString: @"http" options: NSCaseInsensitiveSearch].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (double) timeintervalForDate: (NSDate *) date {
    return [date timeIntervalSince1970];
}

+ (NSString *)weekDayGetForTimeDate:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    NSUInteger week = [comps weekday];
    NSString * weekString;
    switch (week) {
        case 1:
            weekString = @"周日";
            break;
        case 2:
            weekString = @"周一";
            break;
        case 3:
            weekString = @"周二";
            break;
        case 4:
            weekString = @"周三";
            break;
        case 5:
            weekString = @"周四";
            break;
        case 6:
            weekString = @"周五";
            break;
        case 7:
            weekString = @"周六";
            break;
        default:
            break;
    }
    return weekString;
}

+ (NSString *)weekDayGetForTimeString:(NSString *)time{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [Utility dateFromDateStr:time withFormat:@"yyyy-MM-dd"];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:date];
    NSUInteger week = [comps weekday];
    NSString * weekString;
    switch (week) {
        case 1:
            weekString = @"周日";
            break;
        case 2:
            weekString = @"周一";
            break;
        case 3:
            weekString = @"周二";
            break;
        case 4:
            weekString = @"周三";
            break;
        case 5:
            weekString = @"周四";
            break;
        case 6:
            weekString = @"周五";
            break;
        case 7:
            weekString = @"周六";
            break;
        default:
            break;
    }
    return weekString;
}


+ (NSString*) JsonFromId: (id) obj {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: obj
                                                       options: NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding: NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

+(BOOL)isIphoneX{
    if ([[self iphoneType] isEqualToString:@"iPhone X"]) {
        
        return YES;
    }else{
        if (KscreenHeight == 812) {
            return YES;
        }else{
            return NO;
        }
    }
    
}

+(BOOL)isIphone5s{
    if ([[self iphoneType] isEqualToString:@"iPhone 5s"]) {
        return YES;
    }else {
        if (KscreenWidth == 320&&KscreenHeight == 568) {
            return YES;
        }
        return NO;
    }
}

+ (NSString*)iphoneType {
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    return @"";
}

/*
 * 处理一个数字加小数点的字符串,前面无0,保留两位。网上有循环截取的方法,如果数字过长,浪费内存,这个方法在优化内存的基础上设计的。
 */
+(NSString*)getTheCorrectNum:(NSString*)tempString
{
    //先判断第一位是不是 . ,是 . 补0
    if ([tempString hasPrefix:@"."]) {
        tempString = [NSString stringWithFormat:@"0%@",tempString];
    }
    //计算截取的长度
    NSUInteger endLength = tempString.length;
    //判断字符串是否包含 .
    if ([tempString containsString:@"."]) {
        //取得 . 的位置
        NSRange pointRange = [tempString rangeOfString:@"."];
        NSLog(@"%lu",pointRange.location);
        //判断 . 后面有几位
        NSUInteger f = tempString.length - 1 - pointRange.location;
        //如果大于2位就截取字符串保留两位,如果小于两位,直接截取
        if (f > 2) {
            endLength = pointRange.location + 3;
        }
    }
    //先将tempString转换成char型数组
    NSUInteger start = 0;
    const char *tempChar = [tempString UTF8String];
    //遍历,去除取得第一位不是0的位置
    for (int i = 0; i < tempString.length; i++) {
        if (tempChar[i] == '0') {
            start++;
        }else {
            break;
        }
    }
    //如果第一个字母为 . start后退一位
    if (tempChar[start] == '.') {
        start--;
    }
    //根据最终的开始位置,计算长度,并截取
    NSRange range = {start,endLength-start};
    tempString = [tempString substringWithRange:range];
    return tempString;
}

+(NSString *)getCurrentDeviceModel {
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone_X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone_X";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone_XR";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone_XS";
    if ([platform isEqualToString:@"iPhone11,4"] ||
        [platform isEqualToString:@"iPhone11,6"]) return @"iPhone_XS_Max";
    
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPodTouch";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPodTouch2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPodTouch3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPodTouch4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPodTouch5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPodTouch6G";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad4";
    
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPadAir2";
    
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPadmini4";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPadmini4";
    
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]){
        UIApplication *application = [UIApplication sharedApplication];
        if ([[application valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
            return @"iPhone_X";
        }else{
            return @"iPhoneSimulator";
        }
    }
    return platform;
}

+(NSString *)toStringByInteger:(NSInteger )i{
    return  [NSString stringWithFormat:@"%ld",i];
}

+(NSString *)toStringByfloat:(CGFloat )f{
    return  [NSString stringWithFormat:@"%.2f",f];
}


@end

