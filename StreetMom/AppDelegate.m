#import "AppDelegate.h"
#import "ChooseLocationViewController.h"
#import "HTTPClient.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    HTTPClient *httpClient = [[HTTPClient alloc] init];
    UIViewController *chooseLocationViewController = [[ChooseLocationViewController alloc] initWithHTTPClient:httpClient];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chooseLocationViewController];
    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
