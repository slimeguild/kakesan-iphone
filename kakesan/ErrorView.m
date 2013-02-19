#import "ErrorView.h"
#import "KSConst.h"

@implementation ErrorView
@synthesize delegate = _errorViewDelegate;

- (id)initWithFrame:(CGRect)frame withUrlStr:(NSString *)urlStr;
{
  self = [super initWithFrame:frame];
  if (self) {
    self.urlStr = urlStr;
    
    UIButton *reloadButton = [[UIButton alloc] initWithFrame:frame];
    [reloadButton addTarget:self action:@selector(reloadButtonDidPushed:) forControlEvents:UIControlEventTouchDown];
    reloadButton.backgroundColor = [UIColor clearColor];
    
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:frame];
    errorLabel.numberOfLines = 2;
    errorLabel.text = kReloadMessage;
    errorLabel.font = [UIFont fontWithName:kBasicFont size:kBaseFontSize];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:errorLabel];
    [self addSubview:reloadButton];
  }
  return self;
}

- (void)reloadButtonDidPushed:(id)sender
{
  if ([self.delegate respondsToSelector:@selector(reloadButtonDidPushed:)]) {
    [self.delegate reloadButtonDidPushed: self];
  }
}

@end