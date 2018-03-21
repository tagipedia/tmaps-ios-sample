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

@class TGMapViewController;

@protocol TGMapViewControllerDelegate<NSObject>
-(void) mapViewController:(TGMapViewController*) controller didReceiveDispatchWithCommand:(NSDictionary*) command;
@end

@interface TGMapViewController : UIViewController

//@property (nonatomic, copy) NSString* mapId;
@property (nonatomic, weak) id<TGMapViewControllerDelegate> delegate;

-(void) dispatch:(NSDictionary*) command;
@end
