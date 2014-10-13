//
//  AppDelegate.h
//  Datenverbrauch
//
//  Created by Fabian Weyerstall on 04.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
        double myDouble;
    

}
@property (strong, nonatomic) UIWindow *window;

-(void)saveUserDefaults:(NSString*)verbrauch mitDerZeit:(NSString*)mitDerZeit undDemProzent:(NSNumber*)undDemProzent undDemVerbrauchInMB:(NSString*)undDemVerbrauchInMb abrechnungszeitraum:(NSString*)abrechnungszeitraum verbleibendezeit:(NSString*)verbleibendezeit datenvolumen:(NSString*)datenvolumen geschwindigkeit:(NSString*)geschwindigkeit;

@end

