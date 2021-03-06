//
//  BackgroundLayer.m
//  Datenverbrauch
//
//  Created by Fabian Weyerstall on 12.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//

// Original Code from
//  Created by  on 2/02/12.
//  Copyright (c) 2012 AFG. All rights reserved.

#import "BackgroundLayer.h"

@implementation BackgroundLayer

//Blue gradient background
+ (CAGradientLayer*) blueGradient {
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}



//Red gradient background
+ (CAGradientLayer*) redGradient {
    
    UIColor* colorOne = [UIColor colorWithRed: 0.886 green: 0 blue: 0 alpha: 1];
    UIColor* colorTwo = [UIColor colorWithRed: 0.429 green: 0 blue: 0 alpha: 1];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

//Green gradient background
+ (CAGradientLayer*) greenGradient {
    
    //// Color Declarations
    UIColor* colorTwo = [UIColor colorWithRed: 0 green: 0.299 blue: 0 alpha: 1];
    UIColor* colorOne = [UIColor colorWithRed: 0 green: 0.657 blue: 0 alpha: 1];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

//Orange gradient background
+ (CAGradientLayer*) orangeGradient {
    
    //// Color Declarations
    //// Color Declarations
    UIColor* colorOne = [UIColor colorWithRed: 0.886 green: 0.295 blue: 0 alpha: 1];
    UIColor* colorTwo = [UIColor colorWithRed: 0.429 green: 0.143 blue: 0 alpha: 1];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}


@end
