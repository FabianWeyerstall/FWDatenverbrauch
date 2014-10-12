//
//  WebserviceController.h
//  Datenverbrauch
//
//  Created by Fabian Weyerstall on 04.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebserviceController : NSObject <NSURLConnectionDelegate, UIApplicationDelegate>{
    NSMutableData *receivedData;
    NSMutableArray *results;
    NSURLConnection *con;
    NSMutableDictionary *resultsDict;
}

@property (strong, nonatomic) id connectionDelegate;
@property (nonatomic) SEL succeededAction;
@property (nonatomic) SEL failedAction;

- (id)initWithDelegate:(id)delegate selSucceeded:(SEL)succeeded selFailed:(SEL)failed;
- (void)startRequestForURL:(NSURL*)url andUsername:(NSString *)username andPassword:(NSString*) password;
-(void)cancel;
@end
