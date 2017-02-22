//
//  ALIdentificationView.m
//  AnylineExamples
//
//  Created by Matthias on 24/05/15.
//  Copyright © 2016 Anyline GmbH. All rights reserved.
//

#import "ALIdentificationView.h"

#import <Anyline/AnylineMRZModuleView.h>

@interface ALIdentificationView()

@property (nonatomic,strong) UILabel *nr;
@property (nonatomic,strong) UILabel *surname;
@property (nonatomic,strong) UILabel *given_names;
@property (nonatomic,strong) UILabel *code;
@property (nonatomic,strong) UILabel *type;
@property (nonatomic,strong) UILabel *dob;
@property (nonatomic,strong) UILabel *expiration_date;
@property (nonatomic,strong) UILabel *sex;
@property (nonatomic,strong) UILabel *line0;
@property (nonatomic,strong) UILabel *line1;
@property (nonatomic,strong) UILabel *line2;
@end


@implementation ALIdentificationView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setupView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView {
    { // look of the view
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0];
        
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.layer.shadowPath = shadowPath.CGPath;
        self.layer.cornerRadius = 5.0;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowOpacity = 0.7f;
        self.layer.shadowRadius = 50.0;
        self.layer.masksToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PassBlank"]];
        [self addSubview:backgroundView];
        [self sendSubviewToBack:backgroundView];
    }
    
    { // fields
        
        self.nr =  [ALIdentificationView AL_IdentificationLabel2];
        self.nr.text = @"NRNRNRNR";
        self.nr.frame = CGRectMake(self.frame.size.width-80, 7 , 80, 30);
        [self addSubview:self.nr];
        
        self.surname =  [ALIdentificationView AL_IdentificationLabel2];
        self.surname.text = @"SURNAME";
        self.surname.frame = CGRectMake(self.frame.size.width-200, 32, 200, 30);
        [self addSubview:self.surname];
        
        self.given_names =  [ALIdentificationView AL_IdentificationLabel2];
        self.given_names.frame = CGRectMake(self.frame.size.width-200, 57, 200, 30);
        self.given_names.text = @"GIVEN NAMES";
        [self addSubview:self.given_names];
        
        self.code =  [ALIdentificationView AL_IdentificationLabel2];
        self.code.frame = CGRectMake(self.frame.size.width-180, 7, 200, 30);
        self.code.text = @"AUT";
        [self addSubview:self.code];
        
        self.type =  [ALIdentificationView AL_IdentificationLabel2];
        self.type.frame = CGRectMake(self.frame.size.width-200, 7, 200, 30);
        self.type.text = @"P";
        [self addSubview:self.type];
        
        self.dob =  [ALIdentificationView AL_IdentificationLabel2];
        self.dob.frame = CGRectMake(self.frame.size.width-200, 82 , 80, 30);
        self.dob.text = @"19851242";
        [self addSubview:self.dob];
        
        self.expiration_date =  [ALIdentificationView AL_IdentificationLabel2];
        self.expiration_date.frame = CGRectMake(self.frame.size.width-200, 107 , 80, 30);
        self.expiration_date.text = @"20200121";
        [self addSubview:self.expiration_date];
        
        self.sex =  [ALIdentificationView AL_IdentificationLabel2];
        self.sex.frame = CGRectMake(self.frame.size.width-200, 132, 200, 30);
        self.sex.text = @"M";
        [self addSubview:self.sex];
        
        self.line0 =  [ALIdentificationView AL_IdentificationLabel];
        self.line0.frame = CGRectMake(6, 165, 300, 20);
        self.line0.text = @"P<AUTGASSER<<MATTHIAS<<<<<<<<<<<<<<<<<<<<<<<";
        [self addSubview:self.line0];
        
        self.line1 =  [ALIdentificationView AL_IdentificationLabel];
        self.line1.frame = CGRectMake(6, 178, 300, 20);
        self.line1.text = @"P2004908<6AUT8S07125M1706103<<<<<<<<<<<<<<<4";
        [self addSubview:self.line1];
    
        self.line2 =  [ALIdentificationView AL_IdentificationLabel];
        self.line2.frame = CGRectMake(6, 191, 300, 20);
        self.line2.text = @"P2004908<6AUT8S07125M1706103<<<<<<<<<<<<<<<4";
        [self addSubview:self.line2];

    }
}

#pragma mark - Label Factory

+ (UILabel *)AL_IdentificationLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setFont:[UIFont fontWithName:@"CourierNewPSMT" size:11.0]];
    return label;
}
+ (UILabel *)AL_IdentificationLabel2 {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setFont:[UIFont fontWithName:@"CourierNewPS-BoldMT" size:12.0]];
    return label;
}


- (void)updateIdentification:(ALIdentification *)aIdentification {
    
    self.nr.text = aIdentification.documentNumber;
    self.surname.text = aIdentification.surNames;
    self.given_names.text = aIdentification.givenNames;
    self.code.text = aIdentification.nationalityCountryCode;
    self.type.text = aIdentification.documentType;
    self.dob.text = aIdentification.dayOfBirth;
    self.expiration_date.text = aIdentification.expirationDate;
    self.sex.text = aIdentification.sex;
    
    if([aIdentification.documentType hasPrefix:@"P"]) {
        self.line0.text = [[NSString
                            stringWithFormat:@"P<%@%@<<%@",aIdentification.issuingCountryCode,aIdentification.surNames,[aIdentification.givenNames stringByReplacingOccurrencesOfString:@" " withString:@"<"]]
                            stringByPaddingToLength:44 withString:@"<" startingAtIndex:0];
        self.line1.text = @"";
        self.line2.text = [[[NSString
                            stringWithFormat:@"%@<%@%@%@%@%@%@%@%@%@",aIdentification.documentNumber,aIdentification.checkdigitNumber,aIdentification.nationalityCountryCode,aIdentification.dayOfBirth,aIdentification.checkdigitDayOfBirth,aIdentification.sex,aIdentification.expirationDate,aIdentification.checkdigitExpirationDate,aIdentification.personalNumber,aIdentification.checkDigitPersonalNumber]
                           stringByPaddingToLength:43 withString:@"<" startingAtIndex:0]
                           stringByAppendingFormat:@"%@",aIdentification.checkdigitFinal];
    } else {
        self.line0.text = [[NSString
                            stringWithFormat:@"ID%@<<%@",aIdentification.issuingCountryCode,aIdentification.documentNumber]
                           stringByPaddingToLength:30 withString:@"<" startingAtIndex:0];

        self.line1.text = [[[NSString
                            stringWithFormat:@"%@%@%@%@%@%@%@",aIdentification.dayOfBirth,aIdentification.checkdigitDayOfBirth,aIdentification.sex,aIdentification.expirationDate,aIdentification.checkdigitExpirationDate,aIdentification.nationalityCountryCode,aIdentification.personalNumber2]
                           stringByPaddingToLength:29 withString:@"<" startingAtIndex:0]
                           stringByAppendingFormat:@"%@",aIdentification.checkdigitFinal];
        
        self.line2.text = [[NSString
                            stringWithFormat:@"%@<<%@",aIdentification.surNames,[aIdentification.givenNames stringByReplacingOccurrencesOfString:@" " withString:@"<"]]
                           stringByPaddingToLength:30 withString:@"<" startingAtIndex:0];

    }

    
}

@end
