#import <UIKit/UIKit.h>

@class ErrorView;
@protocol ErrorViewDelegate <NSObject>
@optional
- (void) reloadButtonDidPushed: (ErrorView *) errorView;
@end

@interface ErrorView : UIView
{
  __unsafe_unretained id <ErrorViewDelegate> _errorViewDelegate;
}
@property (unsafe_unretained, nonatomic) id<ErrorViewDelegate> delegate;
@property (strong, nonatomic) NSString* urlStr;
- (id)initWithFrame:(CGRect)frame withUrlStr:(NSString *)urlStr;
@end
