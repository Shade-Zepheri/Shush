@interface SBBacklightController : NSObject

+ (instancetype)sharedInstance;

@property (readonly, nonatomic) BOOL screenIsOn;

@end