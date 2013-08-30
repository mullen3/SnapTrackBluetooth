//
//  ViewController.h
//  SnapTrackServer
//
//  Created by Mullen, Connor on 8/29/13.
//  Copyright (c) 2013 Mullen, Connor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnapTrackService.h"

@interface ViewController : UIViewController <SnapTrackServiceProtocol>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (retain, nonatomic) IBOutlet UIAlertView *alertView;
- (IBAction)setName:(id)sender;



@end
