//
//  TodayViewController.h
//  DatenverbrauchWidget
//
//  Created by Fabian Weyerstall on 04.10.14.
//  Copyright (c) 2014 Fabian Weyerstall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController  <NSURLConnectionDelegate>{
    NSMutableData *receivedData;
    NSMutableArray *results;
    NSURLConnection *con;
    NSMutableDictionary *resultsDict;
    NSString *verbrauchSave;
    NSString *timeSave;
    
}

- (IBAction)buttonReload:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *labelTimestamp;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *labelVerbrauchWidget;
@end
