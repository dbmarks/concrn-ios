#import "AppDelegate.h"
#import "ReportCrisisViewController.h"
#import "HTTPClient.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    HTTPClient *httpClient = [[HTTPClient alloc] init];
    UIViewController *reportCrisisViewController = [[ReportCrisisViewController alloc] initWithHTTPClient:httpClient];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:reportCrisisViewController];
    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
