//
//  ViewController.m
//  Datenverbrauch
//
//  Created by Fabian Weyerstall on 04.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//

#import "ViewController.h"
#import "WebserviceController.h"
#import "BackgroundLayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer setValue:bgLayer forKey:@"GradientLayer"];
    [self.view.layer insertSublayer:bgLayer atIndex:0];
}

-(BOOL)UserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"verbrauch"] isEqualToString:@""]) {
        NSLog(@"loaddefaults True");
        return true;
    }
    else {
        NSLog(@"loaddefaults false");
        return false;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    if ([self UserDefaults] == false) {
        NSLog(@"loaddefaults viewdidload false");
        self.labelVerbrauchInMB.text = @"N/A";
        self.labelVerbrauch.text = @"N/A";
        self.labelAbrechnungszeitraum.text = @"N/A";
        self.labelVerbleibendezeit.text = @"N/A";
        self.labelDatenvolumen.text = @"N/A";
        self.labelGeschwindigkeit.text = @"N/A";
        self.labelTimestamp.text = @"N/A";
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"loaddefaults viewdidload True");
        self.labelVerbrauch.text = [defaults objectForKey:@"verbrauch"];
        self.labelVerbrauchInMB.text = [defaults objectForKey:@"undDemVerbrauchInMB"];
        self.labelTimestamp.text = [defaults objectForKey:@"zeit"];
        self.progressBar.progress = [[defaults objectForKey:@"prozent"] doubleValue];
        self.labelAbrechnungszeitraum.text = [defaults objectForKey:@"abrechnungszeitraum"];
        self.labelVerbleibendezeit.text = [defaults objectForKey:@"verbleibendezeit"];
        self.labelDatenvolumen.text = [defaults objectForKey:@"datenvolumen"];
        self.labelGeschwindigkeit.text = [defaults objectForKey:@"geschwindigkeit"];
    }
    [self datenVerbrauchHolen];
  
}

-(void)saveUserDefaults:(NSString*)verbrauch mitDerZeit:(NSString*)mitDerZeit undDemProzent:(NSNumber*)undDemProzent undDemVerbrauchInMB:(NSString*)undDemVerbrauchInMb abrechnungszeitraum:(NSString*)abrechnungszeitraum verbleibendezeit:(NSString*)verbleibendezeit datenvolumen:(NSString*)datenvolumen geschwindigkeit:(NSString*)geschwindigkeit {
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:mitDerZeit forKey:@"zeit"];
    [defaults setObject:verbrauch forKey:@"verbrauch"];
    [defaults setObject:undDemProzent forKey:@"prozent"];
    [defaults setObject:undDemVerbrauchInMb forKey:@"undDemVerbrauchInMB"];
    [defaults setObject:abrechnungszeitraum forKey:@"abrechnungszeitraum"];
    [defaults setObject:verbleibendezeit forKey:@"verbleibendezeit"];
    [defaults setObject:datenvolumen forKey:@"datenvolumen"];
    [defaults setObject:geschwindigkeit forKey:@"geschwindigkeit"];
   
    NSLog(@"savedDefaults");
    [defaults synchronize];
}


+ (NSString *)scanString:(NSString *)string
                startTag:(NSString *)startTag
                  endTag:(NSString *)endTag
{
    
    NSString* scanString = @"";
    
    if (string.length > 0) {
        
        NSScanner* scanner = [[NSScanner alloc] initWithString:string];
        
        @try {
            [scanner scanUpToString:startTag intoString:nil];
            scanner.scanLocation += [startTag length];
            [scanner scanUpToString:endTag intoString:&scanString];
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {
            return scanString;
        }
        
    }
    
    return scanString;
    
}



-(void) datenVerbrauchHolen

{
     NSURL *url = [NSURL URLWithString: @"http://pass.telekom.de/home?continue=true"];
    // create webservice instance with success and failed function
    WebserviceController* connectionController = [[WebserviceController alloc] initWithDelegate:self selSucceeded:@selector(connectionSucceeded:) selFailed:@selector(connectionFailed:)];
    
    [connectionController startRequestForURL:url andUsername:nil andPassword:nil];
    self.spinner.hidden = NO;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    
}






// called if webservice call was successfull
- (void)connectionSucceeded:(NSData *)d {
    
    
    NSString *htmlContent = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"\""
                                                         withString:@""];
   // NSLog(@"%@", htmlContent);
    
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"dd.MM - HH:mm:ss"];
    NSString *line = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:currentDate]];
    
    
    NSString *labelVerbrauchinMBScratch = [ViewController scanString:htmlContent startTag:@"<span class=colored>" endTag:@"</span>"];
    labelVerbrauchinMBScratch = [labelVerbrauchinMBScratch stringByReplacingOccurrencesOfString:@"Â" withString:@""];
    labelVerbrauchinMBScratch = [labelVerbrauchinMBScratch stringByReplacingOccurrencesOfString:@" " withString:@" "];
    NSString *labelVerbrauchinMBScratchN = [labelVerbrauchinMBScratch stringByReplacingOccurrencesOfString:@" MB" withString:@""];
    
    NSString *labelProzentScratch = [ViewController scanString:htmlContent startTag:@"<div class=progressBar>" endTag:@"</div>"];
    labelProzentScratch = [labelProzentScratch stringByReplacingOccurrencesOfString:@"<div class=indicator color_default style=width:" withString:@""];
    labelProzentScratch = [labelProzentScratch stringByReplacingOccurrencesOfString:@"%> " withString:@""];
    
    
    myDouble = [labelProzentScratch doubleValue];
    myDouble = myDouble / 100;
    self.progressBar.progress = myDouble;
    
    //<div class=barTextBelow color_default><span class=colored>579,18 MB</span> von 2 GB mit voller Geschwindigkeit verbraucht
    
    
    NSString *labelVerbrauchScratch = [ViewController scanString:htmlContent startTag:@"<div class=barTextBelow color_default>" endTag:@"</div>"];
    labelVerbrauchScratch = [labelVerbrauchScratch stringByReplacingOccurrencesOfString:@"<span class=colored>" withString:@""];
    labelVerbrauchScratch = [labelVerbrauchScratch stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
   NSString* labelVerbrauchScratchN = [labelVerbrauchScratch stringByReplacingOccurrencesOfString:@" mit voller Geschwindigkeit verbraucht" withString:@""];
    labelVerbrauchScratchN = [NSString stringWithFormat:@"%@ - %@%%", labelVerbrauchScratchN, labelProzentScratch];
    
    
    NSString *labelAbrechnungszeitraumScratch = [ViewController scanString:htmlContent startTag:@"<td class=infoValue billingPeriod>" endTag:@"</td>"];
    
    NSString *labelVerbleibendezeitScratch = [ViewController scanString:htmlContent startTag:@"<td class=infoValue remainingTime>" endTag:@"</td>"];
    labelVerbleibendezeitScratch = [labelVerbleibendezeitScratch stringByReplacingOccurrencesOfString:@"<span class=value>" withString:@""];
    labelVerbleibendezeitScratch = [labelVerbleibendezeitScratch stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    
    NSString *labelDatenvolumenScratch = [ViewController scanString:htmlContent startTag:@"<td class=infoValue totalVolume>" endTag:@"</td>"];
    
    NSString *labelGeschwindigkeitScratch = [ViewController scanString:htmlContent startTag:@"<td class=infoValue maxBandwidth>" endTag:@"</td>"];
    
    
    
    if(![labelVerbrauchScratch isEqualToString:@""]) {
        
        self.labelVerbrauchInMB.text = labelVerbrauchinMBScratch;
        self.labelVerbrauch.text = labelVerbrauchScratchN;
        self.labelAbrechnungszeitraum.text = labelAbrechnungszeitraumScratch;
        self.labelVerbleibendezeit.text = labelVerbleibendezeitScratch;
        self.labelDatenvolumen.text = labelDatenvolumenScratch;
        self.labelGeschwindigkeit.text = labelGeschwindigkeitScratch;
        self.labelTimestamp.text = line;
        self.labelKeinEmpfang.text = @"";
        
        [self saveUserDefaults:labelVerbrauchScratchN mitDerZeit:line undDemProzent:[NSNumber numberWithDouble:myDouble] undDemVerbrauchInMB:labelVerbrauchinMBScratch abrechnungszeitraum:labelAbrechnungszeitraumScratch verbleibendezeit:labelVerbleibendezeitScratch datenvolumen:labelDatenvolumenScratch geschwindigkeit:labelGeschwindigkeitScratch];
        
        CALayer* layer = [self.view.layer valueForKey:@"GradientLayer"];
        [layer removeFromSuperlayer];
        [self.view.layer setValue:nil forKey:@"GradientLayer"];
        
        if(myDouble <= 0.4) {
            CAGradientLayer *bgLayer = [BackgroundLayer greenGradient];
            bgLayer.frame = self.view.bounds;
            [self.view.layer setValue:bgLayer forKey:@"GradientLayer"];
            [self.view.layer insertSublayer:bgLayer atIndex:0];
            NSLog(@"greenGradient");
        } else if(myDouble <= 0.7) {
            CAGradientLayer *bgLayer = [BackgroundLayer orangeGradient];
            bgLayer.frame = self.view.bounds;
            [self.view.layer setValue:bgLayer forKey:@"GradientLayer"];
            [self.view.layer insertSublayer:bgLayer atIndex:0];
            NSLog(@"redGradient");
        }else {
            CAGradientLayer *bgLayer = [BackgroundLayer redGradient];
            bgLayer.frame = self.view.bounds;
            [self.view.layer setValue:bgLayer forKey:@"GradientLayer"];
            [self.view.layer insertSublayer:bgLayer atIndex:0];
            NSLog(@"redGradient");
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [labelVerbrauchinMBScratchN intValue];
    
    } else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        self.labelVerbrauch.text = [defaults objectForKey:@"verbrauch"];
        self.labelTimestamp.text = [defaults objectForKey:@"zeit"];
        self.progressBar.progress = [[defaults objectForKey:@"prozent"] doubleValue];
        self.labelVerbrauchInMB.text = [defaults objectForKey:@"undDemVerbrauchInMB"];
        self.labelAbrechnungszeitraum.text = [defaults objectForKey:@"abrechnungszeitraum"];
        self.labelVerbleibendezeit.text = [defaults objectForKey:@"verbleibendezeit"];
        self.labelDatenvolumen.text = [defaults objectForKey:@"datenvolumen"];
        self.labelGeschwindigkeit.text = [defaults objectForKey:@"geschwindigkeit"];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position.x";
        animation.values = @[ @0, @10, @-10, @10, @0 ];
        animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
        animation.duration = 0.4;
        
        animation.additive = YES;
        
        
        [self.labelKeinEmpfang.layer addAnimation:animation forKey:@"position.x"];
        
        
        self.labelKeinEmpfang.text = @"Keine Verbindung zum Server!";
        CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer setValue:bgLayer forKey:@"GradientLayer"];
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        
    }
    self.spinner.hidden = YES;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];

}

// called if webservice call has failed
- (void)connectionFailed:(NSError *)error {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];   
    self.labelVerbrauch.text = [defaults objectForKey:@"verbrauch"];
    self.labelTimestamp.text = [defaults objectForKey:@"zeit"];
    self.progressBar.progress = [[defaults objectForKey:@"prozent"] doubleValue];
    self.labelVerbrauchInMB.text = [defaults objectForKey:@"undDemVerbrauchInMB"];
    self.labelAbrechnungszeitraum.text = [defaults objectForKey:@"abrechnungszeitraum"];
    self.labelVerbleibendezeit.text = [defaults objectForKey:@"verbleibendezeit"];
    self.labelDatenvolumen.text = [defaults objectForKey:@"datenvolumen"];
    self.labelGeschwindigkeit.text = [defaults objectForKey:@"geschwindigkeit"];
       self.spinner.hidden = YES;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update:(id)sender {
    [self datenVerbrauchHolen];
}


//- (void) datenVerbrauchHolen
//{
//
//    NSError *e = nil;
//
//    NSURL *url = [NSURL URLWithString: @"http://pass.telekom.de/home?continue=true"];
//
//    NSData *d = [[NSData alloc] initWithContentsOfURL: url
//                                              options: NSDataReadingUncached
//                                                error: &e];
//
//    if (e != nil) // Primitive Error Handling
//    {
//        NSLog(@"Fetch error %@", e);
//
//    }
//
//    e = nil;
//    NSString *htmlContent = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
//
//    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"\""
//                                                         withString:@""];
//
//    NSDate* currentDate = [NSDate date];
//    NSDateFormatter *dateFormatter = [NSDateFormatter new];
//    [dateFormatter setDateFormat:@"dd.MM - HH:mm:ss"];
//    NSString *line = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:currentDate]];
//
//
//    NSString *labelVerbrauchinMBScratch = [ViewController scanString:htmlContent startTag:@"<span class=colored>" endTag:@"</span>"];
//    labelVerbrauchinMBScratch = [labelVerbrauchinMBScratch stringByReplacingOccurrencesOfString:@"Â" withString:@""];
//    labelVerbrauchinMBScratch = [labelVerbrauchinMBScratch stringByReplacingOccurrencesOfString:@" " withString:@" "];
//    NSString *labelVerbrauchinMBScratchN = [labelVerbrauchinMBScratch stringByReplacingOccurrencesOfString:@" MB" withString:@""];
//
//
//    NSString *labelVerbrauchScratch = [ViewController scanString:htmlContent startTag:@"<div class=barTextBelow color_default>" endTag:@"</div>"];
//    labelVerbrauchScratch = [labelVerbrauchScratch stringByReplacingOccurrencesOfString:@"<span class=colored>" withString:@""];
//    labelVerbrauchScratch = [labelVerbrauchScratch stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
//
//    NSString *labelAbrechnungszeitraumScratch = [ViewController scanString:htmlContent startTag:@"<td class=infoValue billingPeriod>" endTag:@"</td>"];
//
//    NSString *labelVerbleibendezeitScratch = [ViewController scanString:htmlContent startTag:@"<td class=infoValue remainingTime>" endTag:@"</td>"];
//    labelVerbleibendezeitScratch = [labelVerbleibendezeitScratch stringByReplacingOccurrencesOfString:@"<span class=value>" withString:@""];
//    labelVerbleibendezeitScratch = [labelVerbleibendezeitScratch stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
//
//    NSString *labelDatenvolumenScratch = [ViewController scanString:htmlContent startTag:@"<td class=infoValue totalVolume>" endTag:@"</td>"];
//
//    NSString *labelGeschwindigkeitScratch = [ViewController scanString:htmlContent startTag:@"<td class=infoValue maxBandwidth>" endTag:@"</td>"];
//
//    NSString *labelProzentScratch = [ViewController scanString:htmlContent startTag:@"<div class=progressBar>" endTag:@"</div>"];
//    labelProzentScratch = [labelProzentScratch stringByReplacingOccurrencesOfString:@"<div class=indicator color_default style=width:" withString:@""];
//    labelProzentScratch = [labelProzentScratch stringByReplacingOccurrencesOfString:@"%> " withString:@""];
//
//
//    double myDouble = [labelProzentScratch doubleValue];
//    myDouble = myDouble / 100;
//    self.progressBar.progress = myDouble;
//
//    if(![labelVerbrauchScratch isEqualToString:@""]) {
//
//        self.labelVerbrauchInMB.text = labelVerbrauchinMBScratch;
//        self.labelVerbrauch.text = labelVerbrauchScratch;
//        self.labelAbrechnungszeitraum.text = labelAbrechnungszeitraumScratch;
//        self.labelVerbleibendezeit.text = labelVerbleibendezeitScratch;
//        self.labelDatenvolumen.text = labelDatenvolumenScratch;
//        self.labelGeschwindigkeit.text = labelGeschwindigkeitScratch;
//        self.labelTimestamp.text = line;
//
//        [self saveUserDefaults:labelVerbrauchScratch mitDerZeit:line undDemProzent:[NSNumber numberWithDouble:myDouble] undDemVerbrauchInMB:labelVerbrauchinMBScratch abrechnungszeitraum:labelAbrechnungszeitraumScratch verbleibendezeit:labelVerbleibendezeitScratch datenvolumen:labelDatenvolumenScratch geschwindigkeit:labelGeschwindigkeitScratch];
//
//        [UIApplication sharedApplication].applicationIconBadgeNumber = [labelVerbrauchinMBScratchN intValue];
//    } else {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
//        self.labelVerbrauch.text = [defaults objectForKey:@"verbrauch"];
//        self.labelTimestamp.text = [defaults objectForKey:@"zeit"];
//        self.progressBar.progress = [[defaults objectForKey:@"prozent"] doubleValue];
//        self.labelVerbrauchInMB.text = [defaults objectForKey:@"undDemVerbrauchInMB"];
//        self.labelAbrechnungszeitraum.text = [defaults objectForKey:@"abrechnungszeitraum"];
//        self.labelVerbleibendezeit.text = [defaults objectForKey:@"verbleibendezeit"];
//        self.labelDatenvolumen.text = [defaults objectForKey:@"datenvolumen"];
//        self.labelGeschwindigkeit.text = [defaults objectForKey:@"geschwindigkeit"];
//    }
//
//    if (e != nil)
//    {
//        NSLog(@"Parse error %@", e);
//    }
//    NSLog(@"Verbrauch: %@", labelVerbrauchinMBScratch);
//}

@end
