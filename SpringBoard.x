#import <UIKit/UIKit.h>
#import <Flipswitch/Flipswitch.h>
#import <CoreMotion/CMPocketStateManager.h>
#import <SpringBoard/SBPocketStateMonitor.h>
// Needs these cuz Kirb won't merge my headers
#import <SpringBoard/SBBacklightController.h>
#import <SpringBoard/SpringBoard+Private.h>

static FSSwitchState oldState;
static BOOL shouldDeactivate;

%hook SBPocketStateMonitor

- (void)pocketStateManager:(CMPocketStateManager *)pocketStateManager didUpdateState:(SBPocketState)pocketState {
    %orig;

    BOOL screenIsOn = ((SBBacklightController *)[%c(SBBacklightController) sharedInstance]).screenIsOn;
    SpringBoard *app = (SpringBoard *)[UIApplication sharedApplication];

    FSSwitchPanel *switchPanel = [FSSwitchPanel sharedPanel];
    oldState = [switchPanel stateForSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb"];

    switch (pocketState) {
        case SBPocketStateOutOfPocket: {
            if (!screenIsOn) {
                [app _simulateHomeButtonPress];
            }

            if (oldState == FSSwitchStateOn && !shouldDeactivate) {
                return;
            }

            shouldDeactivate = NO;
            [switchPanel setState:FSSwitchStateOff forSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb"];
            break;
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
            break;
        }
        case SBPocketStateInPocket:
        case SBPocketStateUnknown:
            break;
    }    
}

%end
