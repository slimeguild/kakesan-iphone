#import "KakesanAppDelegate.h"
#import "WebViewController.h"
#import "KSConst.h"
#import "KSKit.h"
#import "ErrorView.h"
#import "SBJson.h"
#import "NSString+Extensions.h"
#import "PrettyKit.h"

@implementation WebViewController
@synthesize delegate = _webViewControllerDelegate;
@synthesize webView = _webView;
@synthesize indicator = _indicator;
@synthesize refreshControl = _refreshControl;
@synthesize httpMethod = _httpMethod;

/******************************************
 Init Methods
******************************************/
- (id)initRootView
{
  self = [super init];
  self.title = kKSTitle;
  [self commonInit: [kRootURL stringByAppendingString:kIndexEventPath]];
  KSBarButtonItem *myEventButton = [[KSBarButtonItem alloc] initWithTitle:kMyEventTitle
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(myEventButtonDidPushed:)
                                                                jsAction:nil];
  KSBarButtonItem *createEventButton = [[KSBarButtonItem alloc] initWithTitle:kCreateEventTitle
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(createEventButtonDidPushed:)
                                                                     jsAction:nil];
  self.navigationItem.rightBarButtonItem = myEventButton;
  self.navigationItem.leftBarButtonItem = createEventButton;
  return self;
}

- (id)initWithTitle:(NSString *)title withURL: (NSString *)url
{
  self = [super init];
  if (self) {
    self.title = title;
    [self commonInit:url];
  }
  return self;
}

- (void)commonInit: (NSString *)url
{
  self.webView = [[UIWebView alloc] init];
  [self.webView setDelegate:self];
  [self.view addSubview:self.webView];
  NSURLRequest* urlReq = [NSURLRequest requestWithURL: [NSURL URLWithString: url]];
  [self.webView loadRequest:urlReq];
  self.webView.exclusiveTouch = YES;
  [self showRefreshControl];
}

/******************************************
 View Frame Setting
 ******************************************/
- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self resizeViewFrame];
  [self showBackButton];
}

- (void) resizeViewFrame {
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screenRect.size.height;
  CGFloat screenWidth = screenRect.size.width;
  CGFloat extraHeight = kStatusbarHeight;
  if (self.navigationController) {
    extraHeight = extraHeight + kToolbarHeight;
  }
  if (self.tabBarController) {
    extraHeight = extraHeight + kTabbarHeight;
  }
  self.webView.frame = CGRectMake(0, 0, screenWidth, (screenHeight - extraHeight));
  if (self.indicator) {
    self.indicator.center = self.webView.center;
  }
}

/******************************************
 Indicator View
 ******************************************/
- (void) showIndicatorView
{
  if (!self.indicator) {
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.center = self.webView.center;
    self.indicator.color = [UIColor grayColor];
    [self.indicator startAnimating];
  }
  [self.view addSubview: self.indicator];
}

- (void) hideIndicatorView
{
  if (self.indicator) {
    [self.indicator removeFromSuperview];
  }
}

/******************************************
 Alert
 ******************************************/
- (void) showRetryAlert
{
  [[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"connectionErrorTitle", nil)
                              message: NSLocalizedString(@"retryMessage", nil)
                             delegate: nil
                    cancelButtonTitle: NSLocalizedString(@"okButtonTitle", nil)
                    otherButtonTitles: nil] show];
}
/******************************************
 User Agent Setting
 ******************************************/
- (NSURLRequest*)uiWebView:(id)webView
                  resource:(id)identifier
           willSendRequest:(NSURLRequest *)request
          redirectResponse:(NSURLResponse *)redirectResponse
            fromDataSource:(id)dataSource
{
  NSString *userAgent = [[request allHTTPHeaderFields] objectForKey: kUserAgentKey];
  NSString *version  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
  userAgent = [NSString stringWithFormat:@"%@ %@%@",userAgent, kKSAgent, version];
  NSMutableURLRequest *req = (NSMutableURLRequest*)request;
  [req setValue:userAgent forHTTPHeaderField: kUserAgentKey];
  return req;
}

/******************************************
 WebView Handling
******************************************/
- (void) webViewDidStartLoad:(UIWebView *) webView
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  [self showIndicatorView];
  if (self.refreshControl) {self.refreshControl.hidden = NO;}
}

- (void) webViewDidFinishLoad:(UIWebView*) webView
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  [self.webView stringByEvaluatingJavaScriptFromString: kJSStopLongTouch];
  [self hideIndicatorView];
  if (self.refreshControl) {[self.refreshControl endRefreshing];}
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
  [self hideIndicatorView];
  if (self.refreshControl) {[self.refreshControl endRefreshing];}
  
  if ([self.httpMethod isEqualToString: @"GET"]) {
    NSString* urlStr = [[error userInfo] objectForKey: @"NSErrorFailingURLStringKey"];
    if (self.refreshControl) {
      self.refreshControl.hidden = true;
    }

    ErrorView *errorView = [[ErrorView alloc] initWithFrame:self.webView.frame withUrlStr:urlStr];
    errorView.delegate = self;
    [self.webView addSubview:errorView];
  
  } else if ([self.httpMethod isEqualToString: @"POST"]) {
    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
      [self showRetryAlert];
    }
  }
}

- (void) reloadButtonDidPushed:(ErrorView *)errorView
{
  [errorView removeFromSuperview];
  NSURLRequest* urlReq = [NSURLRequest requestWithURL: [NSURL URLWithString: errorView.urlStr]];
  [self.webView loadRequest:urlReq];
}

/******************************************
 Native Handling
 ******************************************/
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
  
  NSURL *url = [request URL];
  
  if(![[url scheme] isEqualToString:kKSApiProtocol]){
    self.httpMethod = [request HTTPMethod];
    return YES;
  }
  
  NSString *method = [url host];
  NSString *query = [url query];
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  if (query != nil) {
    query = [query urlEncodeUsingEncoding:kCFStringEncodingUTF8];
    for (NSString *param in [query componentsSeparatedByString:@"&"]) {
      NSArray *elements = [param componentsSeparatedByString:@"="];
      [params setObject:[elements objectAtIndex:1] forKey:[elements objectAtIndex:0]];
    }
  }
  [self invokeNativeMethod: params method:method];
  return NO;
}

-(void)invokeNativeMethod: (NSMutableDictionary*)params method:(NSString*)method
{
  if ([method isEqualToString:kLoginMethod]) {
    [self loginFinished];
  
  } else if ([method isEqualToString: kButtonMethod]) {
    NSString* buttonAction = [params objectForKey:kButtonActionKey];
    NSString* buttonTitle = [params objectForKey:kButtonTitleKey];
    NSString* buttonPosition = [params objectForKey:kButtonPositionKey];
    [self showButtonWithTitle: buttonTitle withAction: buttonAction withPosition:buttonPosition];
  
  } else if ([method isEqualToString: kCloseMethod]) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  
  if ([method isEqualToString: kLoadMethod]) {
    NSString* path    = [params objectForKey:kPathKey];
    NSString* title   = [params objectForKey:kTitleKey];
    WebViewController* next = [[WebViewController alloc] initWithTitle:title withURL: [kRootURL stringByAppendingString: path]];
    [self.navigationController pushViewController:next animated:YES];
  }
}


/******************************************
 Button
 ******************************************/
- (void) showBackButton
{
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:kBackTitle
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
  self.navigationItem.backBarButtonItem = backButton;
}

- (void) showButtonWithTitle: (NSString *)title
                  withAction: (NSString *)action
                withPosition: (NSString *)position
{

  KSBarButtonItem *button = [[KSBarButtonItem alloc] initWithTitle:title
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(buttonAction:)
                                                              jsAction:action];
  
  if([position isEqualToString:kButtonPositionRight]) {
    self.navigationItem.rightBarButtonItem = button;
    
  } else if([position isEqualToString:kButtonPositionLeft]){
    self.navigationItem.leftBarButtonItem = button;
    
  }
}

- (void) buttonAction:(KSBarButtonItem *)sender
{
  [self.webView stringByEvaluatingJavaScriptFromString: [sender.jsAction stringByAppendingString:kBracketsString]];
}

- (void)createEventButtonDidPushed:(KSBarButtonItem *)sender
{
  WebViewController *createEventController = [[WebViewController alloc] initWithTitle: kCreateEventTitle withURL: [kRootURL stringByAppendingString:kCreateEventPath]];
    KSNavigationController *createEventNavController = [[KSNavigationController alloc] initWithRootViewController: createEventController];
  [self presentViewController:createEventNavController animated:YES completion:nil];
}

- (void)myEventButtonDidPushed:(KSBarButtonItem *)sender
{
  WebViewController *myEventController = [[WebViewController alloc] initWithTitle: kMyEventTitle withURL: [kRootURL stringByAppendingString:kMyEventPath]];
  [self.navigationController pushViewController: myEventController animated:YES];
}

/******************************************
 Refresh Control
 ******************************************/
-(void)showRefreshControl
{
  if (self.refreshControl) {return;};
  
  UIScrollView* scrollView;
  
  if ([[[UIDevice currentDevice] systemVersion] floatValue] < kIOS5Version) {
    for (UIView *subview in [self.webView subviews]) {
      if ([[subview.class description] isEqualToString: @"UIScrollView"]) {
        scrollView = (UIScrollView *)subview;
      }
    }
  } else {
    scrollView = (UIScrollView *)[self.webView scrollView];
  }
  
  self.refreshControl = [[ODRefreshControl alloc] initInScrollView: scrollView];
  self.refreshControl.backgroundColor = [UIColor colorWithHex:kResfreshBackground];
  [self.refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
  [self.webView reload];
  double delayInSeconds = kRefreshDelay;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
  });
}



/******************************************
 Login / Logout
 ******************************************/
- (void)loginFinished
{
  if ([self.delegate respondsToSelector:@selector(loginFinished:)]) {
    [self.delegate loginFinished:self];
  }
}
@end
