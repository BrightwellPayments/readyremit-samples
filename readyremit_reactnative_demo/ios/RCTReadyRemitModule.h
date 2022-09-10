#import <React/RCTBridgeModule.h>
#import "ReadyRemitSDK/ReadyRemitSDK.h"
#import <React/RCTEventEmitter.h>

@interface RCTReadyRemitModule : RCTEventEmitter <RCTBridgeModule, ReadyRemitDelegate> {
  void (^_authSuccessCallback)(NSString *token);
  void (^_transferSuccessCallback)(NSString *token);
}

@end
