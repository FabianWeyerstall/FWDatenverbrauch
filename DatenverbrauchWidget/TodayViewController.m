//
//  TodayViewController.m
//  DatenverbrauchWidget
//
//  Created by Fabian Weyerstall on 04.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

//#import "Functions.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   self.preferredContentSize = CGSizeMake(320, 60);
   self.view.translatesAutoresizingMaskIntoConstraints = NO;

}




-(void)saveUserDefaults:(NSString*)verbrauch mitDerZeit:(NSString*)mitDerZeit undDemProzent:(NSNumber*)undDemProzent{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:mitDerZeit forKey:@"zeit"];
    [defaults setObject:verbrauch forKey:@"verbrauch"];
    [defaults setObject:undDemProzent forKey:@"prozent"];
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

-(IBAction)buttonReload:(id)sender {
    NSError *e = nil;
    
    NSURL *url = [NSURL URLWithString: @"http://pass.telekom.de/home?continue=true"];
    
    NSData *d = [[NSData alloc] initWithContentsOfURL: url
                                              options: NSDataReadingUncached
                                                error: &e];
    
    if (e != nil) // Primitive Error Handling
    {
        NSLog(@"Fetch error %@", e);
    }
    
    e = nil;
    NSString *htmlContent = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];

    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    
    NSString *labelVerbrauchScratch = [TodayViewController scanString:htmlContent startTag:@"<span class=colored>" endTag:@"</span>"];
    labelVerbrauchScratch = [labelVerbrauchScratch stringByReplacingOccurrencesOfString:@"Â" withString:@""];
    labelVerbrauchScratch = [labelVerbrauchScratch stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *line = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:currentDate]];
    
    NSString *labelProzentScratch = [TodayViewController scanString:htmlContent startTag:@"<div class=progressBar>" endTag:@"</div>"];
    labelProzentScratch = [labelProzentScratch stringByReplacingOccurrencesOfString:@"<div class=indicator color_default style=width:" withString:@""];
    labelProzentScratch = [labelProzentScratch stringByReplacingOccurrencesOfString:@"%> " withString:@""];
    double myDouble = [labelProzentScratch doubleValue];
    myDouble = myDouble / 100;
    self.progressBar.progress = myDouble;
    
    
    if(![labelVerbrauchScratch isEqualToString:@""]) {
        self.labelVerbrauchWidget.text = labelVerbrauchScratch;
        self.labelTimestamp.text = line;
        self.progressBar.progress = myDouble;
        [self saveUserDefaults:labelVerbrauchScratch mitDerZeit:line undDemProzent:[NSNumber numberWithDouble:myDouble]];
    } else {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        self.labelVerbrauchWidget.text = [defaults objectForKey:@"verbrauch"];
        self.labelTimestamp.text = [defaults objectForKey:@"zeit"];
        self.progressBar.progress = [[defaults objectForKey:@"prozent"] doubleValue];
        //self.progressBar.progress = 0.0;
    }
    
    if (e != nil)
    {
        NSLog(@"Parse error %@", e);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    
    NSLog(@"Background fetch");
    
    NSError *e = nil;
    
    NSURL *url = [NSURL URLWithString: @"http://pass.telekom.de/home?continue=true"];
    
    NSData *d = [[NSData alloc] initWithContentsOfURL: url
                                              options: NSDataReadingUncached
                                                error: &e];
    
    if (e != nil) // Primitive Error Handling
    {
        NSLog(@"Fetch error %@", e);
        completionHandler (NCUpdateResultFailed);
        return;
    }
    
    e = nil;
    NSString *htmlContent = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
 
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    
    NSString *labelVerbrauchScratch = [TodayViewController scanString:htmlContent startTag:@"<span class=colored>" endTag:@"</span>"];
    labelVerbrauchScratch = [labelVerbrauchScratch stringByReplacingOccurrencesOfString:@"Â" withString:@""];
    labelVerbrauchScratch = [labelVerbrauchScratch stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
    NSDate* currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *line = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:currentDate]];
    
    NSString *labelProzentScratch = [TodayViewController scanString:htmlContent startTag:@"<div class=progressBar>" endTag:@"</div>"];
    labelProzentScratch = [labelProzentScratch stringByReplacingOccurrencesOfString:@"<div class=indicator color_default style=width:" withString:@""];
    labelProzentScratch = [labelProzentScratch stringByReplacingOccurrencesOfString:@"%> " withString:@""];
    double myDouble = [labelProzentScratch doubleValue];
    myDouble = myDouble / 100;
    self.progressBar.progress = myDouble;
    
    
    if(![labelVerbrauchScratch isEqualToString:@""]) {
        self.labelVerbrauchWidget.text = labelVerbrauchScratch;
        self.labelTimestamp.text = line;
        self.progressBar.progress = myDouble;
        [self saveUserDefaults:labelVerbrauchScratch mitDerZeit:line undDemProzent:[NSNumber numberWithDouble:myDouble]];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.labelVerbrauchWidget.text = [defaults objectForKey:@"verbrauch"];
        self.labelTimestamp.text = [defaults objectForKey:@"zeit"];
        self.progressBar.progress = [[defaults objectForKey:@"prozent"] doubleValue];
    }
    
    if (e != nil)
    {
        NSLog(@"Parse error %@", e);
        completionHandler (NCUpdateResultFailed);
        return;
    }
    
    
    // call Completition Handler
    completionHandler (NCUpdateResultNewData);
}

@end
