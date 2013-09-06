//
//  SnapTrackService.m
//  SnaptrackServer
//
//  Created by Mullen, Connor on 8/28/13.
//  Copyright (c) 2013 Mullen, Connor. All rights reserved.
//

#import "SnapTrackService.h"

#define CHARACTERISTIC_NAME_UUID_STRING @"C54C3B19-64AC-423A-8282-09BA48CDB28C"
#define SNAPTRACK_SERVICE_UUID_STRING @"7D12"
#define USER_DEFAULTS_NAME_KEY @"name"

@interface SnapTrackService() <CBPeripheralManagerDelegate>
{
    CBPeripheralManager *manager;
    CBMutableService *snapTrackService;
    CBMutableCharacteristic *snapTrackNameCharacteristic;
    CBUUID *cbuuidService;
    CBUUID *cbuuidName;
    NSUserDefaults *prefs;
    NSString *_name;
}

@end

@implementation SnapTrackService

- (id) init
{
    self = [super init];
    
    if (self) {
        manager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
        // this should never be called twice?
        prefs = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
            // TODO: add more cases
        case CBPeripheralManagerStatePoweredOn:
            [self setupService];

            [self advertise];
            break;
        case CBPeripheralManagerStatePoweredOff:
            // not necessary iOS handles this for us.
            // [self.delegate showAlertView];
            [self setupService];
            [self advertise];
            NSLog(@"Powered off");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@"Unsupported State");
            break;
        default:
            NSLog(@"state was updated in unhandled case");
            break;
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"Do we ever get here when the characteristic is read? %@", snapTrackNameCharacteristic.value);
    request.value = [snapTrackNameCharacteristic.value subdataWithRange:NSMakeRange(request.offset, snapTrackNameCharacteristic.value.length - request.offset)];
    [manager respondToRequest:request withResult:CBATTErrorSuccess];
}



- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Manager did start advertising");
}

- (NSString *) name
{
    // if name hasn't been intialized get it from user defaults
    if (!_name && prefs) {
        _name = [[NSString alloc] initWithString:[prefs stringForKey:USER_DEFAULTS_NAME_KEY]];
        NSLog(@"intializing name from prefs file: %@", _name);
    }
    NSLog(@"get to name: name is %@", _name);
    return _name;
}

- (void) setName:(NSString *)name
{
    NSLog(@"Setting name");
    if (name) {
        _name = name;
        NSLog(@"Name is: %@", _name);
        // if user preferences are loaded and the value hasn't been set
        if (prefs)
        {
            // idk if this is slow, but going to update anyways
            [prefs setValue:_name forKey:USER_DEFAULTS_NAME_KEY];
            NSLog(@"Name is: %@", [prefs stringForKey:USER_DEFAULTS_NAME_KEY]);
            // will this really be updated?
            if (snapTrackNameCharacteristic){
                snapTrackNameCharacteristic.value = [_name dataUsingEncoding:NSUTF8StringEncoding];
                [manager stopAdvertising];
                [self advertise];
                NSLog(@"Setting characteristic value %@", [[NSString alloc]initWithData:snapTrackNameCharacteristic.value encoding: NSUTF8StringEncoding]);
                NSLog(@"Does the service's characteristic value change? %@", [[NSString alloc]initWithData:((CBMutableCharacteristic *) snapTrackService.characteristics[0]).value encoding: NSUTF8StringEncoding]);
            }

        }
    }
}

- (void)setupService
{
    NSLog(@"Setting up service");
    cbuuidService = [CBUUID UUIDWithString:SNAPTRACK_SERVICE_UUID_STRING];
    
    cbuuidName = [CBUUID UUIDWithString:CHARACTERISTIC_NAME_UUID_STRING];
    
    NSData *data = [self.name dataUsingEncoding:NSUTF8StringEncoding];
    
    snapTrackNameCharacteristic = [[CBMutableCharacteristic alloc]
                                   initWithType:cbuuidName
                                   properties:CBCharacteristicPropertyRead
                                   value:data
                                   permissions:CBAttributePermissionsReadable];
    
    snapTrackService = [[CBMutableService alloc] initWithType:cbuuidService primary:YES];
    
    snapTrackService.characteristics = [NSArray arrayWithObject:snapTrackNameCharacteristic];
    
    [manager addService:snapTrackService];
    NSLog(@"Characteristic's value is: %@", snapTrackService.characteristics[0]);
}


- (void)advertise
{
    NSArray *services = [NSArray arrayWithObject:cbuuidService];
    NSLog(@"Starting to advertise");
    [manager startAdvertising:[NSDictionary dictionaryWithObject:services forKey:CBAdvertisementDataServiceUUIDsKey]];
}


@end
