#import "SHUSettings.h"
#import <Cephei/HBPreferences.h>

// Settings keys
static NSString *const SHUPreferencesEnabledKey = @"enabled";
static NSString *const SHUPreferencesLockDeviceKey = @"lockDevice";

@implementation SHUSettings {
    HBPreferences *_preferences;
}

+ (instancetype)sharedSettings {
    static SHUSettings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[self alloc] init];
    });

    return sharedSettings;
}

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create prefs
        _preferences = [HBPreferences preferencesForIdentifier:@"com.shade.shush"];

        // Register defaults
        [_preferences registerBool:&_enabled default:NO forKey:SHUPreferencesEnabledKey];
        [_preferences registerBool:&_lockDevice default:NO forKey:SHUPreferencesLockDeviceKey];
    }

    return self;
}

@end