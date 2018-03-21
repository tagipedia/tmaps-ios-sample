//
//  ViewController.h
//  TMapsSample
//
//  Created by Shady Sayed on 12/15/16.
//  Copyright © 2016 Tagipedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGMapViewController.h"

@interface ViewController : UIViewController<TGMapViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtMapId;

@end

