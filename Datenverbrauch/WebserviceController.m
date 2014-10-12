//
//  WebserviceController
//  Datenverbrauch
//
//  Created by Fabian Weyerstall on 04.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//

#import "WebserviceController.h"


@interface WebserviceController()
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@end

@implementation WebserviceController
@synthesize username, password;

// set delegates for success and fail methods
- (id)initWithDelegate:(id)delegate selSucceeded:(SEL)succeeded selFailed:(SEL)failed {
    if ((self = [super init])) {
        self.connectionDelegate = delegate;
        self.succeededAction = succeeded;
        self.failedAction = failed;
    }
    return self;
}



// start URL request
- (void)startRequestForURL:(NSURL*)url andUsername:(NSString *)user andPassword:(NSString*) pass {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // create URL request
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    // [req setHTTPBody:[requestXML dataUsingEncoding:NSUTF8StringEncoding]];
    [req setValue:@"text/xml; charset=\"utf-8\"" forHTTPHeaderField:@"content-type"];
    
    username = user;
    password = pass;
    
    // create URL connection
    con = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    
    receivedData = [[NSMutableData alloc] init];
}

-(void)cancel {
    [con cancel];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
#pragma mark - webservices delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // get response code
    //    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //    int code = [httpResponse statusCode];
    //    NSLog(@"Response-Code: %d", code);
    
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    
    [receivedData appendData:d];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //  NSString* newStr = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    //results = receivedData;

    // call success method with result
    [self.connectionDelegate performSelector:self.succeededAction withObject:receivedData];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // call fail methods with error object
    [self.connectionDelegate performSelector:self.failedAction withObject:error];
    con = nil;
    receivedData = nil;
}

// called when authorization is required
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    
    if ([[challenge protectionSpace] authenticationMethod] ==
        NSURLAuthenticationMethodHTTPBasic)
    {
        //  This is very, very important to check.  Depending on how your
        //  security policies are setup, you could lock your user out of his
        //  or her account by trying to use the wrong credentials too many
        //  times in a row.
        if ([challenge previousFailureCount] > 0)
        {
            [[challenge sender] cancelAuthenticationChallenge:challenge];
            [self cancel];
            NSString *error = @"WrongLogin";
            [self.connectionDelegate performSelector:self.failedAction withObject:error];
        }
        else
        {
            NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username
                                                                     password:self.password
                                                                  persistence:NSURLCredentialPersistenceNone];
            
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            //  NSLog(@"Login Erfolgreich");
        }
    }
    else
    {
        //  Do whatever you want here, for educational purposes,
        //  I'm just going to cancel the challenge
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
    
}


/* required for SSL connection
 - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
 return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
 }
 
 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
 
 //if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
 //if ([trustedHosts containsObject:challenge.protectionSpace.host])
 [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
 
 [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
 }
 */
/*
 - (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
 return;
 }
 
 - (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
 return NO;
 }
 
 - (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
 return;
 }
 */


@end
