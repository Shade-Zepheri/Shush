#import <UIKit/UIKit.h>
#import "SHUSettings.h"

#import <Flipswitch/Flipswitch.h>
#import <SpringBoard/SBPocketStateMonitor.h>
// Needs these cuz Kirb won't merge my headers
#import <SpringBoard/SBBacklightController.h>
#import <SpringBoard/SpringBoard+Private.h>

FSSwitchState oldState;
BOOL shouldDeactivate;

SHUSettings *settings;

#pragma mark - Hooks

%hook SBBacklightController

- (void)pocketStateMonitor:(SBPocketStateMonitor *)stateMonitor pocketStateDidChangeFrom:(SBPocketState)fromState to:(SBPocketState)toState {
    %orig;

    // Only proceed if enabled
    if (!settings.enabled) {
        return;
    }

    SpringBoard *app = (SpringBoard *)[UIApplication sharedApplication];

    // Check if DND is already enabled
    FSSwitchPanel *switchPanel = [FSSwitchPanel sharedPanel];
    oldState = [switchPanel stateForSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb"];

    switch (toState) {
        case SBPocketStateOutOfPocket: {
            if (!self.screenIsOn && settings.lockDevice) {
                [app _simulateHomeButtonPress];
            }

            if (oldState == FSSwitchStateOn && !shouldDeactivate) {
                return;
            }

            shouldDeactivate = NO;
            [switchPanel setState:FSSwitchStateOff forSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb"];
            return;
        }
        case SBPocketStateFaceDown:
        case SBPocketStateFaceDownOnTable: {
            if (self.screenIsOn && settings.lockDevice) {
                [app _simulateLockButtonPress];
            }

            if (oldState == FSSwitchStateOn && !shouldDeactivate) {
                return;
            }

            shouldDeactivate = YES;
            [switchPanel setState:FSSwitchStateOn forSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb"];
            return;
        }
        case SBPocketStateInPocket:
        case SBPocketStateUnknown:
            return;
    }
}

%end

#pragma mark - Constructor

%ctor {
    // Create singleton
    settings = [SHUSettings sharedSettings];
}