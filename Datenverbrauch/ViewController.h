//
//  ViewController.h
//  Datenverbrauch
//
//  Created by Fabian Weyerstall on 04.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    double myDouble;
}

@property (strong, nonatomic) IBOutlet UILabel *labelVerbrauchInMB;
@property (strong, nonatomic) IBOutlet UILabel *labelVerbrauch;
@property (strong, nonatomic) IBOutlet UILabel *labelAbrechnungszeitraum;
@property (strong, nonatomic) IBOutlet UILabel *labelVerbleibendezeit;
@property (strong, nonatomic) IBOutlet UILabel *labelDatenvolumen;
@property (strong, nonatomic) IBOutlet UILabel *labelGeschwindigkeit;
@property (strong, nonatomic) IBOutlet UILabel *labelTimestamp;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *labelKeinEmpfang;

-(IBAction)update:(id)sender;
-(void)datenVerbrauchHolen;
- (void)connectionSucceeded:(NSData *)d;
- (void)connectionFailed:(NSError *)error;

-(BOOL)UserDefaults;
-(void)saveUserDefaults:(NSString*)verbrauch mitDerZeit:(NSString*)mitDerZeit undDemProzent:(NSNumber*)undDemProzent undDemVerbrauchInMB:(NSString*)undDemVerbrauchInMb abrechnungszeitraum:(NSString*)abrechnungszeitraum verbleibendezeit:(NSString*)verbleibendezeit datenvolumen:(NSString*)datenvolumen geschwindigkeit:(NSString*)geschwindigkeit;

+ (NSString *)scanString:(NSString *)string
                startTag:(NSString *)startTag
                  endTag:(NSString *)endTag;

@end

