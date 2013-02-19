#import "NSString+Extensions.h"

@implementation NSString (Extensions)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding
    (NULL,
     (__bridge CFStringRef) self,
     CFSTR("!*'();:@&=+$,/?%#[]"),
   encoding
   );
}

@end
