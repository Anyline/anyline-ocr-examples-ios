//
//  ALEUDrivingLicenseView.m
//  AnylineExamples
//
//  Created by Daniel Albertini on 19.12.17.
//

#import "ALEUDrivingLicenseView.h"

@implementation ALEUDrivingLicenseView

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
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"driverlicense"]];
    backgroundView.frame = self.bounds;
    backgroundView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:backgroundView];
    [self sendSubviewToBack:backgroundView];
    
    { // fields
        
        self.surname =  [[UILabel alloc] initWithFrame:CGRectMake(130, 70, 200, 20)];
        [self addSubview:self.surname];
        
        self.surname2 =  [[UILabel alloc] initWithFrame:CGRectMake(130, 90, 200, 20)];
        [self addSubview:self.surname2];
        
        self.givenNames =  [[UILabel alloc] initWithFrame:CGRectMake(130, 110, 200, 20)];
        [self addSubview:self.givenNames];
        
        self.birthdate =  [[UILabel alloc] initWithFrame:CGRectMake(130, 130, 200, 20)];
        [self addSubview:self.birthdate];
        
        self.idNumber =  [[UILabel alloc] initWithFrame:CGRectMake(130, 150, 200, 20)];
        [self addSubview:self.idNumber];
    }
}


@end
