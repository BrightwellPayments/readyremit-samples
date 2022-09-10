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
  return @[@"READYREMIT_AUTH_TOKEN_REQUESTED", @"READYREMIT_TRANSFER_SUBMITTED"];
}

RCT_EXPORT_METHOD(setAuthToken: (NSString *)token :(NSString *)errorCode) {
  _authSuccessCallback(token);
}

RCT_EXPORT_METHOD(setTransferId: (NSString *)transferId :(NSString *)errorCode) {
  _transferSuccessCallback(transferId);
}

RCT_EXPORT_METHOD(launch: (NSString *)environment :(NSString *)language :(NSDictionary*)styles) {
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    ReadyRemitViewController *readyRemitViewController = [[ReadyRemitViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:readyRemitViewController];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:styles
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    ReadyRemitAppearance *appearance = [[ReadyRemitAppearance alloc] init];
    ReadyRemitFonts *fonts = [[ReadyRemitFonts alloc] init];
    ReadyRemitColorScheme *colors = [[ReadyRemitColorScheme alloc] init];
    
    // colors..titleColor = colorFromHexString("#123456");
    // appearance.titleFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0]
    
    appearance.fonts = fonts;
    appearance.colors = colors;
    
    if ([environment isEqual:@"PRODUCTION"]) {
      readyRemitViewController.environment = ReadyRemitApiEnvironmentProduction;
    } else {
      readyRemitViewController.environment = ReadyRemitApiEnvironmentSandbox;
    }
    
    readyRemitViewController.delegate = self;
    // readyRemitViewController.appearance = appearance;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController presentViewController:navigationController animated:YES completion:nil];
  });
}

- (void) onAuthTokenRequestWithSuccess:(void (^)(NSString * _Nonnull))success failure:(void (^)(void))failure {
  _authSuccessCallback = [success copy];
  [self sendEventWithName:@"READYREMIT_AUTH_TOKEN_REQUESTED" body:@{ }];
}

- (void) onSubmitTransferWithTransferRequest:(TransferRequest *)transferRequest success:(void (^)(NSString * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure {
  
  _transferSuccessCallback = [success copy];
  
  NSError* error;
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:transferRequest options:NSJSONWritingPrettyPrinted error:&error];
  
  [self sendEventWithName:@"READYREMIT_TRANSFER_SUBMITTED" body:jsonData];
}

@end
