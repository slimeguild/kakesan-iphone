#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "ODRefreshControl.h"
#import "ErrorView.h"

@class WebViewController;

@protocol WebViewControllerDelegate <NSObject>
@optional
- (void) loginFinished: (WebViewController*) webViewController;
- (void) logoutFinished: (WebViewController*) webViewController;
@end

@interface WebViewController : UIViewController <UIWebViewDelegate,ErrorViewDelegate,ADBannerViewDelegate>
{
  __unsafe_unretained id <WebViewControllerDelegate> _webViewControllerDelegate;
}
@property (unsafe_unretained, nonatomic) id<WebViewControllerDelegate> delegate;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) ODRefreshControl *refreshControl;
@property (strong, nonatomic) NSString *httpMethod;
@property (strong, nonatomic) ADBannerView *adView;
@property (assign, nonatomic) BOOL bannerIsVisible;

- (id)initRootView;
- (id)initWithTitle:(NSString *)title withURL: (NSString *)url;

@end