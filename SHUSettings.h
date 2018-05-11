#import <UIKit/UIKit.h>

@interface SHUSettings : NSObject

+ (instancetype)sharedSettings;

@property (readonly, nonatomic) BOOL enabled;
@property (readonly, nonatomic) BOOL lockDevice;

@end