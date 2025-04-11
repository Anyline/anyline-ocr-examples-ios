#import <Foundation/Foundation.h>

@interface NSString (ALExtensions)

/**
 * Test if the string contains aString
 *
 * @param aString the other string to test
 * returns YES if the string contains the other aString, NO otherwise
 */
- (BOOL)AL_contains:(NSString*)aString;

- (NSUInteger)AL_occurrenceCountOfCharacter:(UniChar)character;

+ (NSString *)AL_base64_encode:(NSData *)data;

- (NSString *)AL_base64_decodeToString;

- (NSData *)AL_base64_decodeToData;

+ (NSString *)documentsDirectory;

+ (NSString *)checksumOfPath:(NSString *)path;

#ifdef __cplusplus

+ (instancetype)stringWithCppString:(std::string)cppString;

- (std::string)cppString;

#endif

@end
