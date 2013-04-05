static float const kStatusbarHeight = 20.0f;
static float const kToolbarHeight = 44.0f;
static float const kTabbarHeight = 49.0f;

static float const kRefreshDelay = 3.0;
static int const kResfreshBackground = 0xEEEEEE;
static float const kIOS5Version = 5.0;

static NSString* const kBasicFont = @"AppleGothic";
static int const kBaseFontSize = 13;

static NSString* const kKSTitle = @"×3トーク";
static NSString* const kKSAgent = @"Kakesan-iOS/";
static NSString* const kKSApiProtocol = @"ksapi";
static NSString* const kKSPattern = @"(.+)\\((.+)\\)";
static NSString* const kBracketsString = @"()";
static NSString* const kBlankString = @"";
static NSString* const kMyEventTitle = @"マイトーク";
static NSString* const kCreateEventTitle = @"テーマ作成";
static NSString* const kBackTitle = @"戻る";

//static NSString* const kRootURL = @"http://kakesan.dev";
//static NSString* const kRootURL = @"http://kakesan-staging.herokuapp.com";
static NSString* const kRootURL = @"http://kakesan.herokuapp.com";
static NSString* const kSessionCheckPath = @"/sessions/check.json";
static NSString* const kIndexEventPath = @"/themes";
static NSString* const kMyEventPath = @"/private/talks";
static NSString* const kCreateEventPath = @"/themes/new";
static NSString* const kJSStopLongTouch = @"document.documentElement.style.webkitTouchCallout = 'none';";
;
static NSString* const kUserAgentKey = @"User-Agent";
static NSString* const kStatusKey = @"status";
static NSString* const kPathKey = @"path";
static NSString* const kTitleKey = @"title";
static NSString* const kButtonActionKey = @"buttonAction";
static NSString* const kButtonTitleKey = @"buttonTitle";
static NSString* const kButtonPositionKey = @"buttonPosition";
static NSString* const kButtonPositionRight = @"right";
static NSString* const kButtonPositionLeft = @"left";

static NSString* const kLoginMethod = @"login";
static NSString* const kButtonMethod = @"button";
static NSString* const kCloseMethod = @"close";
static NSString* const kLoadMethod = @"load";

static NSString* const kReloadMessage = @"エラーが発生しました。\n画面をタップして再読み込みしてください。";