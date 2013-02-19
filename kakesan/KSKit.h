#import <UIKit/UIKit.h>
#import "PrettyKit.h"

#define gradient_start_color      [UIColor colorWithHex:0xFF8C00]
#define gradient_end_color        [UIColor colorWithHex:0xFF8C00]
#define top_line_color            [UIColor colorWithHex:0xFF8C00]
#define bottom_line_color         [UIColor colorWithHex:0xFF8C00]
#define rounded_corner_radius     4
#define alpha                     0.1

@interface KSNavigationController : UINavigationController
@end

@interface KSToolBar : PrettyToolbar
@end

@interface KSBarButtonItem : UIBarButtonItem
@property (strong, nonatomic) NSString *jsAction;
-(id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action jsAction:(NSString *)jsAction;
@end