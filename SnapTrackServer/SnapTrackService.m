//
//  SnapTrackService.m
//  SnaptrackServer
//
//  Created by Mullen, Connor on 8/28/13.
//  Copyright (c) 2013 Mullen, Connor. All rights reserved.
//

#import "SnapTrackService.h"

#define CHARACTERISTIC_NAME_UUID_STRING @"C54C3B19-64AC-423A-8282-09BA48CDB28C"
#define SNAPTRACK_SERVICE_UUID_STRING @"7D1201BE-C06C-424B-862E-A2B4006BE326"

@interface SnapTrackService() <CBPeripheralManagerDelegate>
{
    CBPeripheralManager *manager;
    CBMutableService *snapTrackService;
    CBMutableCharacteristic *snapTrackNameCharacteristic;
    CBUUID *cbuuidService;
    CBUUID *cbuuidName;
}

@end

@implementation SnapTrackService

- (id) init
{
    self = [super init];
    
    if (self) {
        manager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    }
    
    return self;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
            // TODO: add more cases
        case CBPeripheralManagerStatePoweredOn:
            [self setupService];
            
            break;
            
        default:
            break;
    }
}

- (void)setupService
{
    cbuuidService = [CBUUID UUIDWithString:SNAPTRACK_SERVICE_UUID_STRING];
    
    cbuuidName = [CBUUID UUIDWithString:CHARACTERISTIC_NAME_UUID_STRING];
    
    NSString *name = @"Dirk Diggler";
    NSData *data = [name dataUsingEncoding:NSUTF8StringEncoding];
    
    snapTrackNameCharacteristic = [[CBMutableCharacteristic alloc]
                                   initWithType:cbuuidName
                                   properties:CBCharacteristicPropertyRead
                                   value:data
                                   permissions:0];
    
    snapTrackService = [[CBMutableService alloc] initWithType:cbuuidService primary:YES];
    
    snapTrackService.characteristics = [NSArray arrayWithObject:snapTrackNameCharacteristic];
    
    [manager addService:snapTrackService];
}

- (void)advertise
{
    NSArray *services = [NSArray arrayWithObject:cbuuidService];
    
    [manager startAdvertising:[NSDictionary dictionaryWithObject:services forKey:CBAdvertisementDataServiceUUIDsKey]];
}

@end
