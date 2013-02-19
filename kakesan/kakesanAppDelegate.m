#import "kakesanAppDelegate.h"
#import "KSConst.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "KSKit.h"

@implementation kakesanAppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  //[self deleteCookie];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  if ([self isLogin]) {
    [self createAfterLoginView];
  } else {
    [self createBeforeLoginView];
  }
  [self.window makeKeyAndVisible];
  return YES;
}

- (BOOL) isLogin
{
  NSString *urlStr = [kRootURL stringByAppendingString: kSessionCheckPath];
  NSURL *url = [NSURL URLWithString:urlStr];
  ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
  [request startSynchronous];
  NSError *error = [request error];
  
  if (error) {
    return NO;
  } else {
    NSString *response = [request responseString];    
    NSDictionary *dic = [response JSONValue];
    BOOL status = [[dic objectForKey:kStatusKey] boolValue];
    return  status;
  }
}

- (void) createBeforeLoginView
{
  WebViewController *loginViewController = [[WebViewController alloc] initWithTitle:nil withURL: kRootURL];
  [loginViewController setDelegate: self];
  self.window.rootViewController = loginViewController;
}

- (void) createAfterLoginView
{
  WebViewController *indexEventViewController = [[WebViewController alloc] initRootView];
  KSNavigationController *rootNavigationController = [[KSNavigationController alloc] initWithRootViewController: indexEventViewController];
  self.window.rootViewController = rootNavigationController;

}

- (void) deleteCookie
{
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  NSArray *cookies = [storage cookies];
  for (NSHTTPCookie *cookie in cookies) {
    [storage deleteCookie:cookie];
  }
}

/******************************************
 Login/Logout Delegate
 ******************************************/
- (void) loginFinished:(WebViewController *)webViewController
{
  [self createAfterLoginView];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
 
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
