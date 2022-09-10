//
//  ReadyRemitViewController.h
//  readyremit_reactnative_demo
//
//  Created by Dan Chimento on 9/10/22.
//

#import <UIKit/UIkit.h>
#import "ReadyRemitSDK/ReadyRemitSDK.h"

@interface ReadyRemitViewController : UIViewController
@property (nonatomic, assign) id<ReadyRemitDelegate> delegate;

@end
