#import "RCTReadyRemitModule.h"
#import "AppDelegate.h"
#import "ReadyRemitViewController.h"
#import "ReadyRemitSDK/ReadyRemitSDK.h"

@implementation RCTReadyRemitModule

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"READYREMIT_AUTH_TOKEN_REQUESTED", @"READYREMIT_TRANSFER_SUBMITTED"];
}

// Ripped from https://stackoverflow.com/a/12397366
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

RCT_EXPORT_MODULE();

const NSInteger kConditionLockWaiting = 0;
const NSInteger kConditionLockShouldProceed = 1;

- (void) setColorFromPath: (UIColor *)color: (NSDictionary*)styles :(NSString*)path
{
    NSString* hex = [styles valueForKeyPath: path];
    if (hex == nil)
    {
      return;
    }
  
    color = [self colorFromHexString: hex];
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
    
    ReadyRemitAppearance *appearance = [[ReadyRemitAppearance alloc] init];
    
    FontSpec.defaultFamily = [styles valueForKeyPath:@"fonts.default.family"];

    [self setColorFromPath:appearance.colors.primaryShade1 :styles :@"colors.primaryShade1.lightHex"];
    [self setColorFromPath:appearance.colors.primaryShade2 :styles :@"colors.primaryShade2.lightHex"];
    [self setColorFromPath:appearance.colors.secondaryShade1 :styles :@"colors.secondaryShade1.lightHex"];
    [self setColorFromPath:appearance.colors.secondaryShade2 :styles :@"colors.secondaryShade2.lightHex"];
    [self setColorFromPath:appearance.colors.secondaryShade3 :styles :@"colors.secondaryShade3.lightHex"];

    [self setColorFromPath:appearance.colors.textPrimaryShade1 :styles :@"colors.textPrimaryShade1.lightHex"];
    [self setColorFromPath:appearance.colors.textPrimaryShade2 :styles :@"colors.textPrimaryShade2.lightHex"];
    [self setColorFromPath:appearance.colors.textPrimaryShade3 :styles :@"colors.textPrimaryShade3.lightHex"];
    [self setColorFromPath:appearance.colors.textPrimaryShade4 :styles :@"colors.textPrimaryShade4.lightHex"];
    [self setColorFromPath:appearance.colors.textPrimaryShade5 :styles :@"colors.textPrimaryShade5.lightHex"];

    [self setColorFromPath:appearance.colors.backgroundColorPrimary :styles :@"colors.backgroundColorPrimary.lightHex"];
    [self setColorFromPath:appearance.colors.backgroundColorSecondary :styles :@"colors.backgroundColorSecondary.lightHex"];
    [self setColorFromPath:appearance.colors.backgroundColorTertiary :styles :@"colors.backgroundColorTertiary.lightHex"];

    [self setColorFromPath:appearance.colors.error :styles :@"colors.error.lightHex"];
    [self setColorFromPath:appearance.colors.success :styles :@"colors.success.lightHex"];

    [self setColorFromPath:appearance.colors.controlShade1 :styles :@"colors.controlShade1.lightHex"];
    [self setColorFromPath:appearance.colors.controlShade2 :styles :@"colors.controlShade2.lightHex"];
    [self setColorFromPath:appearance.colors.controlAccessoryShade1 :styles :@"colors.controlAccessoryShade1.lightHex"];
    [self setColorFromPath:appearance.colors.controlAccessoryShade2 :styles :@"colors.controlAccessoryShade2.lightHex"];

    if ([environment isEqual:@"PRODUCTION"]) {
      readyRemitViewController.environment = ReadyRemitApiEnvironmentProduction;
    } else {
      readyRemitViewController.environment = ReadyRemitApiEnvironmentSandbox;
    }
    
    readyRemitViewController.language = language;
    readyRemitViewController.delegate = self;
    readyRemitViewController.appearance = appearance;
    
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
  
  [self sendEventWithName:@"READYREMIT_TRANSFER_SUBMITTED" body:@{
    @"dstCountryIso3Code": transferRequest.dstCountryIso3Code,
    @"dstCurrencyIso3Code": transferRequest.dstCurrencyIso3Code,
    @"srcCurrencyIso3Code": transferRequest.srcCurrencyIso3Code,
    @"transferMethod": transferRequest.transferMethod,
    @"quoteBy": transferRequest.quoteBy,
    @"amount": [NSNumber numberWithInt: transferRequest.amount],
    @"fee": transferRequest.fee,
    @"recipientId": transferRequest.recipientId,
    @"recipientAccountId": transferRequest.recipientAccountId,
    @"purposeOfRemittance": transferRequest.purposeOfRemittance
  }];
}

@end
