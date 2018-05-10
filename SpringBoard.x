#import <UIKit/UIKit.h>
#import <Flipswitch/Flipswitch.h>

typedef NS_ENUM(NSUInteger, SBPocketState) {
    SBPocketStateOutOfPocket,
    SBPocketStateInPocket,
    SBPocketStateFaceDown,
    SBPocketStateFaceDownOnTable,
    SBPocketStateUnknown
};

static FSSwitchState oldState;
static BOOL shouldDeactivate;

%hook SBPocketStateMonitor

- (void)pocketStateManager:(id)pocketStateManager didUpdateState:(SBPocketState)pocketState {
    %orig;

    FSSwitchPanel *switchPanel = [FSSwitchPanel sharedPanel];
    oldState = [switchPanel stateForSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb"];

    if (oldState == FSSwitchStateOn && !shouldDeactivate) {
        return;
    }

    switch (pocketState) {
        case SBPocketStateOutOfPocket: {
            shouldDeactivate = NO;
            [switchPanel setState:FSSwitchStateOff forSwitchIdentifier:@"com.a3tweaks.switch.do-not-disturb"];
            break;
        }
        case SBPocketStateFaceDown:
        case SBPocketStateFaceDownOnTable: {
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
