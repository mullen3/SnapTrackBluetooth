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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
