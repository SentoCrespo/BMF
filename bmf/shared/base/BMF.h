

#import "BMFTypes.h"


#import "BMFBase.h"

#import <BMF/BMFArrayProxy.h>

#define BMFLocalized(string,comment) NSLocalizedStringFromTableInBundle(string,@"BMFLocalizable",[BMFBase sharedInstance].bundle,comment)

#pragma mark Utils
#import "BMFAutoLayoutUtils.h"
#import "BMFUtils.h"

#pragma mark Protocols
#import "BMFParserProtocol.h"
#import "BMFTaskProtocol.h"

#pragma mark Categories
#import "NSBundle+BMF.h"
#import "NSArray+BMF.h"
#import "NSDictionary+BMF.h"
#import "NSString+BMF.h"
#import "NSURL+BMF.h"
#import "NSSet+BMF.h"
#import "NSDate+BMF.h"
#import "NSMutableArray+BMF.h"
#import "NSMutableDictionary+BMF.h"
#import "NSMutableSet+BMF.h"
#import "NSOrderedSet+BMF.h"
#import "NSMutableOrderedSet+BMF.h"
#import "BMFIXFont+BMF.h"

#import "BMFDataReadProtocol.h"
#import "BMFDataStoreProtocol.h"
#import "BMFValueProtocol.h"

#import "BMFUserMessagesPresenterProtocol.h"
#import "BMFObjectControllerProtocol.h"

#if TARGET_OS_IPHONE

#import "BMFKeyboardManager.h"
#import "BMFBehaviorsViewControllerProtocol.h"
#import "UIView+BMF.h"
#import "UITableView+BMF.h"
#import "UIBarButtonItem+BMF.h"
#import "UIWebView+BMF.h"
#import "UIButton+BMF.h"

#else

#import "NSWindow+BMF.h"
#import "NSTextView+BMF.h"

#endif

