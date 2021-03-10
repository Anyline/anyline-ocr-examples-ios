//
//  ALResultEntry.h
//  AnylineExamples
//
//  Created by Philipp Müller on 07.05.18.
//

@interface ALResultEntry : NSObject

@property (strong, atomic) NSString *title;
@property (strong, atomic) NSString *value;
@property (atomic) BOOL isAvailable;


/// Whether the value is a code potentially made up of letters and numbers rather than a word, number, or date. When this is YES, the value will be displayed in a monospaced font (to better distinguish e.g. 0/O, 1/I), and will be spelled out character-by-character in VoiceOver instead of read normally.
@property (atomic) BOOL shouldSpellOutValue;
@property (atomic) BOOL isMandatory;

/// Create a result entry to show on the result screen
/// @param title The name of the result to display, e.g. 'Surname' or 'Voucher code'
/// @param value The result value, e.g. 'Dent' or 'ZZ9PZA'
/// @param shouldSpellOutValue Whether the value is a code potentially made up of letters and numbers rather than a word, number, or date. When this is YES, the value will be displayed in a monospaced font (to better distinguish e.g. 0/O, 1/I), and will be spelled out character-by-character in VoiceOver instead of read normally. Defaults to NO.
/// @param isMandatory This BOOL value will be used for our result and history screen. This can be used to filter the most important result fields. If isMandatory is set to YES, it will be alwas displayed.If it's set to NO, it will not show in every screen. Defaults to YES
- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value shouldSpellOutValue:(BOOL)shouldSpellOutValue isMandatory:(BOOL)isMandatory;
- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value shouldSpellOutValue:(BOOL)shouldSpellOutValue;
- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value;
- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value isMandatory:(BOOL)isMandatory;
- (instancetype)initWithTitle:(NSString *)title value:(NSString *)value isAvailable:(BOOL)available;

- (instancetype)initWithDicitonary:(NSDictionary *)dict;

- (NSDictionary *)toDictionary;

@end
