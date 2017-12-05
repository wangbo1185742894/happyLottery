
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


@interface AESUtility : NSObject {

}
+ (NSString*)encryptStr:(NSString*)plainText;
+ (NSString*)decryptStr:(NSString*)encryptText;
@end