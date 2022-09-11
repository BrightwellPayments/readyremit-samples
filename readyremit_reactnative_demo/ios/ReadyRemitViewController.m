#import "ReadyRemitViewController.h"
#import "ReadyRemitSDK/ReadyRemitSDK.h"

@interface ReadyRemitViewController ()

@property (weak, nonatomic) ReadyRemit* readyRemit;
@property (nonatomic, copy) void (^launchCompletion)(void);


@end

@implementation ReadyRemitViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  
  _launchCompletion = ^{ NSLog(@"ObjC: ReadyRemit launched."); };
  
  _readyRemit = [ReadyRemit shared];
    
  _readyRemit.appearance = _appearance;
  _readyRemit.environment = _environment;
  [_readyRemit languageSelected:_language];
  
  [_readyRemit launchObjcInNavigation:[self navigationController]
                             delegate: _delegate
                             onLaunch: _launchCompletion];
}

@end
