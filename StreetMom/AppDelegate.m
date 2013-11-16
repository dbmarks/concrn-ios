#import "AppDelegate.h"
#import "ChooseLocationViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIViewController *chooseLocationViewController = [[ChooseLocationViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:chooseLocationViewController];
    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
