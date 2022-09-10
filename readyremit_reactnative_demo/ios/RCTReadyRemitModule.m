#import "RCTReadyRemitModule.h"
#import "AppDelegate.h"
#import "ReadyRemitViewController.h"
#import "ReadyRemitSDK/ReadyRemitSDK.h"

@implementation RCTReadyRemitModule

RCT_EXPORT_MODULE();

const NSInteger kConditionLockWaiting = 0;
const NSInteger kConditionLockShouldProceed = 1;

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"auth", @"transfer"];
}

RCT_EXPORT_METHOD(setAuthToken: (NSString *)token) {
  _authSuccessCallback(token);
}

RCT_EXPORT_METHOD(setTransferId: (NSString *)transferId) {
  _transferSuccessCallback(transferId);
}

RCT_EXPORT_METHOD(launch) {
  NSLog(@"RN binding - Native View - Loading MyViewController.swift");
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    ReadyRemitViewController *readyRemitViewController = [[ReadyRemitViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:readyRemitViewController];
    readyRemitViewController.delegate = self;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController presentViewController:navigationController animated:YES completion:nil];
    //window.rootViewController = readyRemitViewController;
  });
}

- (void) onAuthTokenRequestWithSuccess:(void (^)(NSString * _Nonnull))success failure:(void (^)(void))failure {
  _authSuccessCallback = [success copy];
  [self sendEventWithName:@"auth" body:@{ }];
}

- (void) onSubmitTransferWithTransferRequest:(TransferRequest *)transferRequest success:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure {
  
  _transferSuccessCallback = [success copy];
  
  NSError* error;
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:transferRequest options:NSJSONWritingPrettyPrinted error:&error];
  
  [self sendEventWithName:@"transfer" body:jsonData];
}

@end
