//
//  AppDelegate.m
//  Datenverbrauch
//
//  Created by Fabian Weyerstall on 04.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"didReceiveLocalNotification");
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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


- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Background fetch");
    
    NSError *e = nil;
    
    NSURL *url = [NSURL URLWithString: @"http://pass.telekom.de/home?continue=true"];
    
    NSData *d = [[NSData alloc] initWithContentsOfURL: url
                                              options: NSDataReadingUncached
                                                error: &e];
    
    if (e != nil) // Primitive Error Handling
    {
        NSLog(@"Fetch error %@", e);
        completionHandler (UIBackgroundFetchResultFailed);
        return;
    }
    
    e = nil;
    NSString *htmlContent = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"\""
                                                         withString:@""];
    NSString *labelVerbrauchinMBScratch = [AppDelegate scanString:htmlContent startTag:@"<span class=colored>" endTag:@"</span>"];
    labelVerbrauchinMBScratch = [labelVerbrauchinMBScratch stringByReplacingOccurrencesOfString:@"Â" withString:@""];
    labelVerbrauchinMBScratch = [labelVerbrauchinMBScratch stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *labelVerbrauchinMBScratchN = [labelVerbrauchinMBScratch stringByReplacingOccurrencesOfString:@" MB" withString:@""];
    
    if (e != nil)
    {
        NSLog(@"Parse error %@", e);
        completionHandler (UIBackgroundFetchResultFailed);
        return;
    }
    NSLog(@"Verbrauch: %@", labelVerbrauchinMBScratch);
    
    
    if(![labelVerbrauchinMBScratchN intValue] == 0) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [labelVerbrauchinMBScratchN intValue];
        
        // fire Notification
        UILocalNotification *note = [[UILocalNotification alloc] init];
        NSString *alter = [NSString stringWithFormat:@"Neuer Verbrauch: %@", labelVerbrauchinMBScratch];
        [note setAlertBody:alter];
        [[UIApplication sharedApplication] scheduleLocalNotification: note];
    } else {
        // fire Notification
        UILocalNotification *note = [[UILocalNotification alloc] init];
        NSString *alter = [NSString stringWithFormat:@"Daten konnten nicht aktualisiert werden!"];
        [note setAlertBody:alter];
        [[UIApplication sharedApplication] scheduleLocalNotification: note];
    }
    // call Completition Handler
    completionHandler (UIBackgroundFetchResultNewData);
}

@end
