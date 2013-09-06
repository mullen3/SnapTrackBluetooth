//
//  SnapTrackService.h
//  SnapTrackServer
//
//  Created by Mullen, Connor on 8/29/13.
//  Copyright (c) 2013 Mullen, Connor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol SnapTrackServiceProtocol <NSObject>

- (void)showAlertView;

@end


@interface SnapTrackService : NSObject <CBPeripheralManagerDelegate> {

    
}

@property (nonatomic, assign) id <SnapTrackServiceProtocol> delegate;
@property (copy, nonatomic) NSString *name;

@end
