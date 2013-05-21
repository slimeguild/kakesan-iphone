#import "kakesanAppDelegate.h"
#import "KSConst.h"
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
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
    [self setPushNotificationSettings];
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

- (void) sendProviderDeviceToken: (NSString *)token
{
  NSString *urlStr = [kRootURL stringByAppendingString: kPostTokenPath];
  NSURL *url = [NSURL URLWithString:urlStr];
  ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
  [request setPostValue:token forKey:@"token"];
  [request startSynchronous];
  NSError *error = [request error];
  if (error) {
  }
}

- (void) setPushNotificationSettings
{
  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}


/******************************************
 Login/Logout Delegate
 ******************************************/
- (void) loginFinished:(WebViewController *)webViewController
{
  [self createAfterLoginView];
  [self setPushNotificationSettings];
}

/******************************************
 RemoteNotification Delegate
 ******************************************/
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
  application.applicationIconBadgeNumber = 0;
  [self sendProviderDeviceToken: deviceTokenString];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  UIApplicationState state = [application applicationState];
  NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
  
  NSString *alertString = [apsInfo objectForKey:@"alert"];
  if (state == UIApplicationStateActive) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:alertString
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
  }
  //NSString *sound = [apsInfo objectForKey:@"sound"];
  //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  
  NSString *badge = [apsInfo objectForKey:@"badge"];
  application.applicationIconBadgeNumber = [[apsInfo objectForKey:badge] integerValue];
}


/******************************************
 Application Delegate
 ******************************************/
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
