//
//  TGMapViewController.h
//  TMapsSample
//
//  Created by Shady Sayed on 12/15/16.
//  Copyright © 2016 Tagipedia. All rights reserved.
//

#import <WebKit/WKScriptMessageHandler.h>
#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>

#import <EstimoteSDK/ESTConfig.h>
#import <EstimoteIndoorSDK/EILIndoorLocationManager.h>
#import <EstimoteIndoorSDK/EILRequestFetchLocation.h>
#import <EstimoteIndoorSDK/EILOrientedPoint.h>
#import <EstimoteIndoorSDK/EILLocationBuilder.h>
@class TGMapViewController;

@protocol TGMapViewControllerDelegate<NSObject>
-(void) mapViewController:(TGMapViewController*) controller didReceiveDispatchWithCommand:(NSDictionary*) command;
-(void) mapViewController:(TGMapViewController*) controller centralManagerDidUpdateState:(CBCentralManager *)central;
- (void) mapViewController:(TGMapViewController*) controller indoorLocationManager:(EILIndoorLocationManager *)manager
         didUpdatePosition:(EILOrientedPoint *)position
              withAccuracy:(EILPositionAccuracy)positionAccuracy
                inLocation:(EILLocation *)location;

- (void) mapViewController:(TGMapViewController*) controller   indoorLocationManager:(EILIndoorLocationManager *)manager
didFailToUpdatePositionWithError:(NSError *)error;
@end

@interface TGMapViewController : UIViewController

//@property (nonatomic, copy) NSString* mapId;
@property (nonatomic, weak) id<TGMapViewControllerDelegate> delegate;

-(void) dispatch:(NSDictionary*) command;
-(void) enableBeaconLocationButton;
-(void) startPositionUpdatesForLocation;
-(void) stopPositionUpdates;
@end
