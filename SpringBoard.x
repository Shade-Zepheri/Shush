#import <UIKit/UIKit.h>
#import <Flipswitch/Flipswitch.h>
#import <SpringBoard/SBPocketStateMonitor.h>
// Needs these cuz Kirb won't merge my headers
#import <SpringBoard/SBBacklightController.h>
#import <SpringBoard/SpringBoard+Private.h>

static FSSwitchState oldState;
static BOOL shouldDeactivate;

%hook SBBacklightController

- (void)pocketStateMonitor:(SBPocketStateMonitor *)stateMonitor pocketStateDidChangeFrom:(SBPocketState)fromState to:(SBPocketState)toState {
    %orig;

    BOOL screenIsOn = self.screenIsOn;
    SpringBoard *app = (SpringBoard *)[UIApplication sharedApplication];

    FSSwitchPanel *switchPanel = [FSSwitchPanel sharedPanel];
    oldState = [switchPanel stateForSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb"];

    switch (toState) {
        case SBPocketStateOutOfPocket: {
            if (!screenIsOn) {
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
            if (screenIsOn) {
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
