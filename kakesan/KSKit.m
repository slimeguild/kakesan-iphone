#import "KSKit.h"
#import "KSConst.h"
#import "PrettyKit.h"

@implementation KSNavigationController
- (void) loadView {
  [super loadView];
  PrettyNavigationBar *navBar = [[PrettyNavigationBar alloc] init];
  navBar.gradientStartColor = gradient_start_color;
  navBar.gradientEndColor = gradient_end_color;
  navBar.topLineColor = top_line_color;
  navBar.bottomLineColor = bottom_line_color;
  navBar.tintColor = navBar.gradientEndColor;
  navBar.roundedCornerRadius = rounded_corner_radius;
  [self setValue:navBar forKeyPath:@"navigationBar"];
}
@end

@implementation KSToolBar
- (id)init
{
  self = [super init];
  if (self) {
    self.gradientStartColor = gradient_start_color;
    self.gradientEndColor = gradient_end_color;
    self.topLineColor = top_line_color;
    self.bottomLineColor = bottom_line_color;
    self.tintColor = self.gradientEndColor;
  }
  return self;
}
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.gradientStartColor = gradient_start_color;
    self.gradientEndColor = gradient_end_color;
    self.topLineColor = top_line_color;
    self.bottomLineColor = bottom_line_color;
    self.tintColor = self.gradientEndColor;
  }
  return self;
}


@end

@implementation KSBarButtonItem
@synthesize jsAction = _jsAction;
-(id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action jsAction:(NSString *)jsAction
{
  self = [super initWithTitle:title style:style target:target action:action];
  if (self) {
    self.jsAction = jsAction;
  }
  return self;
}
@end

