//
//  ViewController.m
//  TMapsSample
//
//  Created by Shady Sayed on 12/15/16.
//  Copyright © 2016 Tagipedia. All rights reserved.
//

#import "ViewController.h"
#define CLIENT_ID @"client_id"
#define CLIENT_SECRET @"client_secret"
#define MAPBOX_ACCESS_TOKEN @"mapbox_access_token"

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "TMapsSample-Swift.h"
@interface ViewController () <NavigationMapDelegate>

@end

@implementation ViewController

CBCentralManager *bluetoothManager;
CLLocationManager* locationManager;
TGMapViewController *tgController;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.txtMapId.text = @"3";
}

- (void)mapViewController:(TGMapViewController *)controller indoorLocationManager:(EILIndoorLocationManager *)manager
didFailToUpdatePositionWithError:(NSError *)error {
    NSLog(@"failed to update position: %@", error);
}

- (void)mapViewController:(TGMapViewController *)controller indoorLocationManager:(EILIndoorLocationManager *)manager
        didUpdatePosition:(EILOrientedPoint *)position
             withAccuracy:(EILPositionAccuracy)positionAccuracy
               inLocation:(EILLocation *)location {
    NSString *accuracy;
    switch (positionAccuracy) {
        case EILPositionAccuracyVeryHigh: accuracy = @"+/- 1.00m"; break;
        case EILPositionAccuracyHigh:     accuracy = @"+/- 1.62m"; break;
        case EILPositionAccuracyMedium:   accuracy = @"+/- 2.62m"; break;
        case EILPositionAccuracyLow:      accuracy = @"+/- 4.24m"; break;
        case EILPositionAccuracyVeryLow:  accuracy = @"+/- ? :-("; break;
        case EILPositionAccuracyUnknown:  accuracy = @"unknown"; break;
    }
    NSLog(@"x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
          position.x, position.y, position.orientation, accuracy);
    NSDictionary *ll = location;
    [controller dispatch:@{
                           @"type": @"SET_USER_BEACON_LOCATION",
                           @"x": [NSNumber numberWithDouble:position.x],
                           @"y": [NSNumber numberWithDouble:position.y],
                           @"origin_lat": [ll valueForKey:@"latitude"],
                           @"origin_lng": [ll valueForKey:@"longitude"]
                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getTenantsJSON
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tenants" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
-(void) navigationEndWithTGMapViewController:(TGMapViewController *)tGMapViewController origin:(CLLocationCoordinate2D)origin destination:(CLLocationCoordinate2D)destination profile:(NSString *)profile isCanceld:(BOOL)isCanceld{
    if(isCanceld){
        NSMutableDictionary* originDictionary = [[NSMutableDictionary alloc] init];
        [originDictionary setObject:[NSNumber numberWithDouble:origin.latitude] forKey:@"lat"];
        [originDictionary setObject:[NSNumber numberWithDouble:origin.longitude] forKey:@"lng"];
        NSMutableDictionary* destinationDictionary = [[NSMutableDictionary alloc] init];
        [destinationDictionary setObject:[NSNumber numberWithDouble:destination.latitude] forKey:@"lat"];
        [destinationDictionary setObject:[NSNumber numberWithDouble:destination.longitude] forKey:@"lng"];
        
        [tGMapViewController dispatch:@{
                                        @"type": @"NAVIGATION_END",
                                        @"origin": originDictionary,
                                        @"destination": destinationDictionary,
                                        @"profile": profile
                                        }];
    }
    else {
        [tGMapViewController dispatch:@{
                                        @"type": @"NAVIGATION_CANCELED"
                                        }];
    }
    
    
}

-(void) mapViewController:(TGMapViewController *)controller didReceiveDispatchWithCommand:(NSDictionary *)command {
    NSLog(@"received dispatch %@", command);
    // You can dispatch whatever command
    NSString* type = (NSString*)[command valueForKey:@"type"];
    if ([type isEqualToString:@"READY"]) {
//        // you can set your app tenants json array here
//        [controller dispatch:@{
//                               @"type": @"SET_TENANT_DATA",
//                               @"payload": [self getTenantsJSON]
//                               }];

//        // you can customize popup templete using angular code
//        NSDictionary *haveProfileDict = @{
//                                          @"w22972": @YES,
//                                          @"w22986": @YES
//                                          }
//        NSDictionary *templateCustomData = @{
//                                             @"id": @1,
//                                             @"command": @"HELLLO_FROM_THE_OTHER_SIDE",
//                                             @"value": @3,
//                                             @"haveProfileDict": haveProfileDict,
//                                             @"func": @"function(){return 4;}",
//                                             }
//
//
//        [controller dispatch:@{
//                               @"type": @"SET_DEFAULT_FEATURE_POPUP_TEMPLATE",
//                               @"template_custom_data": templateCustomData,
//                               @"template": @" \
//                                             <md-card id=\"{{poi.id}}\" class=\"feature-popup display-none slide-up\"  > \
//                                             <div layout=\"row\" layout-align=\"end start\" > \
//                                             <md-card-title class=\"padding-bottom-overide\" layout=\"row\" layout-align=\"center center\"> \
//                                             <md-card-title-media> \
//                                             <div class=\"circle\" layout=\"row\" layout-align=\"center center\"> \
//                                             <md-icon ng-if=\"!poi.getIcon()\" md-font-set=\"material-icons\" class=\"camera-icon\">camera_alt</md-icon> \
//                                             <img ng-if=\"poi.getIcon()\" src=\"{{poi.getIcon()}}\" /> \
//                                             </div> \
//                                             </md-card-title-media> \
//                                             <md-card-title-text > \
//                                             <div class=\"md-subline\">{{poi.getDisplayName()}}</div> \
//                                             <div ng-if=\"poi.getBoothId()\" layout=\"row\"> \
//                                             <div class=\"categoryline\" > \
//                                             <div class=\"margin-right-margin-left\">{{poi.getBoothId()}}</div> \
//                                             </div> \
//                                             </div> \
//                                             <div ng-if=\"poi.category\" layout=\"row\"> \
//                                             <div class=\"categoryline\" > \
//                                             <div class=\"margin-right-margin-left\">{{poi.category}}</div> \
//                                             </div> \
//                                             </div> \
//                                             </md-card-title-text> \
//                                             </md-card-title> \
//                                             <md-button id=\"close-info\" class=\"md-icon-button\" ng-click=\"closeInfo()\"> \
//                                             <md-icon md-font-set=\"material-icons\" aria-label=\"close info\">close</md-icon> \
//                                             </md-button> \
//                                             </div> \
//                                             <md-card-actions layout=\"row\" layout-align=\"center center\" > \
//                                             <div ng-if=\"poi.category === 'wheelchair-bathroom'\" layout=\"row\" layout-align=\"center center\"> \
//                                             <i class=\"fa fa-3x fa-wheelchair\"></i> \
//                                             </div> \
//                                             <h1>{{customData.func()}} {{customData.command}} {{customData.id}}</h1><br />\
//                                             \
//                                             <br ng-if=\"poi.category === 'wheelchair-bathroom'\"  /> \
//                                             <br ng-if=\"poi.category === 'wheelchair-bathroom'\"  /> \
//                                             <div flex ng-if=\"enableRouting\" class=\"feature-routing-buttons\" layout=\"row\" layout-align=\"center center\"> \
//                                             <md-button layout=\"row\" class=\"md-raised md-primary\" ng-click=\"showRoutingDialog($event, {from: poi})\"> \
//                                             <div class=\"margin-right-margin-left\"> Route From</div> \
//                                             <md-icon md-font-set=\"material-icons\" >adjust</md-icon> \
//                                             </md-button> \
//                                             <md-button layout=\"row\" class=\"md-raised md-primary\" ng-click=\"showRoutingDialog($event, {to:poi})\"> \
//                                             <div class=\"margin-right-margin-left\"> Route To</div> \
//                                             <md-icon md-font-set=\"material-icons\" >flag</md-icon> \
//                                             </md-button> \
//                                             <md-button ng-if=\"customData.haveProfileDict[poi.id]\" layout=\"row\" class=\"md-raised md-primary\" ng-click=\"dispatchToContainer({type: 'PROFILE_BUTTON_CLICKED', feature_id: poi.id, type2:poi.getTenant().type})\"> \
//                                             <div class=\"margin-right-margin-left\"> GO Profile</div> \
//                                             <md-icon md-font-set=\"material-icons\" >flag</md-icon> \
//                                             </md-button> \
//                                             </div> \
//                                             </md-card-actions> \
//                                             </md-card> \
//                                             \
//                                             "}];
        
//        // change app theme
//        [controller dispatch:@{
//                               @"type": @"SET_THEME",
//                               @"theme": @{
//                                       @"primary":@"brown",
//                                       }
//                               }];
        [controller dispatch:@{
                              @"type": @"SET_APPLICATION_SECRETS",
                              @"client_id": [TGMapViewController getAppSecretInfoValueForKey:CLIENT_ID],
                              @"client_secret": [TGMapViewController getAppSecretInfoValueForKey:CLIENT_SECRET]
                              }];
        [controller dispatch:@{
                               @"type": @"SET_DEVICE_DATA",
                               @"device_id": [NSString stringWithFormat:@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]],
                               @"device_type": @"IOS"
                               }];        
        [controller dispatch:@{
                               @"type": @"SET_MAPBOX_ACCESS_TOKEN",
                               @"access_token": [TGMapViewController getAppSecretInfoValueForKey:MAPBOX_ACCESS_TOKEN],
                               }];
        // load map
        [controller dispatch:@{
                               @"type": @"LOAD_MAP",
                               @"map_id": self.txtMapId.text,
                               @"theme": @{
                                       @"primary":@"brown",
                                       }
                               }];
    } else if ([type isEqualToString:@"MAP_LOADED"]) {
//        [controller dispatch:@{
//                               @"type": @"CHANGE_RENDER_MODE",
//                               @"modeToRender": @"2D"
//                               }];
//        [controller dispatch:@{
//                               @"type": @"SET_ZOOM",
//                               @"zoom": @20,
////                               @"zoom_type": @"FLY_TO",
//                               }];
//        [controller dispatch:@{
//                               @"type": @"SET_CENTER",
//                               @"center": @[lng, lat],
//                               }];
//        // highlight initial feature here if you don't SET_ZOOM or SET_CENTER
//        // if you use SET_ZOOM or SET_CENTER so please highlight initial feature when ZOOM_ENDED or CENTER_ENDED
//        [controller dispatch:@{
//                               @"type": @"HIGHLIGHT_FEATURE",
//                               @"feature_id": @"w22972"
//                               }];
//     [controller dispatch:@{@"type": @"ENABLE_GPS_BUTTON"}];
//        [controller enableBeaconLocationButton];
    } else if ([type isEqualToString:@"FEATURES_TAPPED"]) {
//        // mark feature
//        [controller dispatch:@{
//                               @"type": @"MARK_FEATURE",
//                               @"feature_id": [(NSDictionary*)[(NSArray*)command[@"features"] objectAtIndex:0] valueForKey:@"id"]
//                               }];
        // highlight feature
        [controller dispatch:@{
                               @"type": @"HIGHLIGHT_FEATURE",
                               @"feature_id": [(NSDictionary*)[(NSArray*)command[@"features"] objectAtIndex:0] valueForKey:@"id"]
                               }];
    } else if ([type isEqualToString:@"ASSOCIATED_FEATURE_TAPPED"]) {
        
    } else if ([type isEqualToString:@"FEATURE_MARKED"]) {
        
    } else if ([type isEqualToString:@"FEATURE_HIGHLIGHTED"]) {
        
    } else if ([type isEqualToString:@"ZOOM_ENDED"]) {
        
    } else if ([type isEqualToString:@"CENTER_ENDED"]) {
        
    } else if ([type isEqualToString:@"CATEGORY_MARKED"]) {
        
    } else if ([type isEqualToString:@"ERROR"]) {
        
    }
    else if([type isEqualToString:@"START_NAVIGATION"]){
        NSString* profile = [command valueForKey:@"profile"];
        CLLocationDegrees lat = [[[command valueForKey:@"origin"] valueForKey:@"lat"] doubleValue];
        CLLocationDegrees lng = [[[command valueForKey:@"origin"] valueForKey:@"lng"] doubleValue];
        CLLocationCoordinate2D origin = CLLocationCoordinate2DMake(lat, lng);
        lat = [[[command valueForKey:@"destination"] valueForKey:@"lat"] doubleValue];
        lng = [[[command valueForKey:@"destination"] valueForKey:@"lng"] doubleValue];
        CLLocationCoordinate2D destination = CLLocationCoordinate2DMake(lat, lng);
                NavigationMapOutDoorViewController *navigationMapOutDoorViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationMapOutDoor"];
                [navigationMapOutDoorViewController setControllerWithController:controller];
                [navigationMapOutDoorViewController setNeededNavigationDetailsWithOrigin:origin destination:destination profile:profile];
                navigationMapOutDoorViewController.delegate = self;
                [self.navigationController pushViewController:navigationMapOutDoorViewController animated:NO];
        
    } else if ([type isEqualToString:@"PROFILE_BUTTON_CLICKED"]) {
        // this is example for custom dispatch type that you dispatched in your custom templete when custom profile button clicked
    } else if ([type isEqualToString:@"CHECK_GPS_AVAILABILITY"]) {
        if(![CLLocationManager locationServicesEnabled]){
            [self checkLocationServicesAndStartUpdates:controller];
        }
        else {
            [controller dispatch:@{@"type": @"START_UPDATING_LOCATION", @"is_gps_activated": @true }];
        }
    } else if ([type isEqualToString:@"CHECK_BEACON_LOCATION_AVAILABILITY"]) {
        bluetoothManager = [[CBCentralManager alloc]
                            initWithDelegate:controller
                            queue:dispatch_get_main_queue()
                            options:@{CBCentralManagerOptionShowPowerAlertKey: @(YES)}];
    }else if ([type isEqualToString:@"START_POSITION_UPDATES_FOR_BEACON_LOCATION"]) {
        BOOL start_beacon_manager = [[command valueForKey:@"start_beacon_manager"] intValue];
        if(start_beacon_manager){
            [controller startPositionUpdatesForLocation];
        }
        else {
            [controller stopPositionUpdates];
        }
    }
}


-(void) mapViewController:(TGMapViewController*) controller centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *stateString = nil;
    switch(bluetoothManager.state)
    {
        case CBCentralManagerStatePoweredOff: [controller dispatch:@{@"type": @"START_UPDATING_BEACON_LOCATION", @"is_beacon_location_activated": @false }];
            break;
        case CBCentralManagerStatePoweredOn: [controller dispatch:@{@"type": @"START_UPDATING_BEACON_LOCATION", @"is_beacon_location_activated": @true }]; break;
        default: stateString = @"State unknown, update imminent.";
            break;
    }
}


-(void) checkLocationServicesAndStartUpdates:(TGMapViewController *)controller {
    tgController = controller;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    if (![CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Need Location Services"
                                                            message:@"We would like to use your location. Please enable location services from Settings > Location Services"
                                                           delegate:self
                                                  cancelButtonTitle:@"Settings"
                                                  otherButtonTitles:@"Later", nil];
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)//Settings button pressed
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (![CLLocationManager locationServicesEnabled]) {
        [tgController dispatch:@{@"type": @"START_UPDATING_LOCATION", @"is_gps_activated": @false }];
    }
    else {
        [tgController dispatch:@{@"type": @"START_UPDATING_LOCATION", @"is_gps_activated": @true }];
    }
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMap"]) {
        TGMapViewController* mapViewController = (TGMapViewController*)segue.destinationViewController;
        //mapViewController.mapId = self.txtMapId.text;
        mapViewController.delegate = self;
    }
}

@end
