//
//  BackgroundLayer.h
//  Datenverbrauch
//
//  Created by Fabian Weyerstall on 12.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface BackgroundLayer : NSObject

+(CAGradientLayer*) blueGradient;
+(CAGradientLayer*) redGradient;
+(CAGradientLayer*) greenGradient;
+(CAGradientLayer*) orangeGradient;

@end

