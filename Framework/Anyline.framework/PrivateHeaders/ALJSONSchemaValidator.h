#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ALJSONSchemaValidator: NSObject

+ (BOOL)validateConfigJSON:(NSString *)JSONString
                     error:(NSError * _Nullable * _Nullable)error;

+ (BOOL)validateInitParamsJSON:(NSString *)JSONString error:(NSError * _Nullable * _Nullable)error;

+ (BOOL)validateJSON:(NSString *)JSONString
        pathToSchema:(NSString * _Nullable)pathToSchema
               error:(NSError * _Nullable * _Nullable)error;

@end


NS_ASSUME_NONNULL_END
