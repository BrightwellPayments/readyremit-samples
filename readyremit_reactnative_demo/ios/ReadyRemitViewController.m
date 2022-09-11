#import "ReadyRemitViewController.h"
#import "ReadyRemitSDK/ReadyRemitSDK.h"

@interface ReadyRemitViewController ()

@property (weak, nonatomic) ReadyRemit* readyRemit;
@property (nonatomic, copy) void (^launchCompletion)(void);


@end

@implementation ReadyRemitViewController

// Ripped from https://stackoverflow.com/a/12397366
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void) viewDidLoad {
  [super viewDidLoad];
  
  _launchCompletion = ^{ NSLog(@"ObjC: ReadyRemit launched."); };
  
  _readyRemit = [ReadyRemit shared];
  
  //_readyRemit.environment = ReadyRemitApiEnvironmentProduction;
  //_readyRemit.appearance = _appearance;
  //_readyRemit.environment = _environment;
  //_readyRemit.setLanguage(_language);
  
  [_readyRemit launchObjcInNavigation:[self navigationController]
                             delegate: _delegate
                             onLaunch: _launchCompletion];
}

@end
