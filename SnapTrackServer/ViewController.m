//
//  ViewController.m
//  SnapTrackServer
//
//  Created by Mullen, Connor on 8/29/13.
//  Copyright (c) 2013 Mullen, Connor. All rights reserved.
//

#import "ViewController.h"
#import "SnapTrackService.h"

@interface ViewController ()
@property (strong, nonatomic) SnapTrackService *snapTrackService;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _snapTrackService = [[SnapTrackService alloc] init];
    self.snapTrackService.delegate = self;
}

- (void)showAlertView
{
    self.alertView = [[UIAlertView alloc]
                 initWithTitle:@"Bluetooth is Off"
                 message:@"You must have bluetooth on to use this app."
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [self.alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setName:(id)sender {
    [_snapTrackService setUserName: self.textField.text];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    if (theTextField == self.textField) {
        [theTextField resignFirstResponder];
    }
    
    return YES;
}

@end
