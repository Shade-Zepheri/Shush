#import "SHURootListController.h"
#import <CepheiPrefs/HBSupportController.h>
#import <TechSupport/TSContactViewController.h>

@implementation SHURootListController

#pragma mark - HBListController

+ (NSString *)hb_specifierPlist {
    return @"Root";
}

#pragma mark - Support

- (void)showSupportEmailController {
	TSContactViewController *supportController = [HBSupportController supportViewControllerForBundle:[NSBundle bundleForClass:self.class] preferencesIdentifier:@"com.shade.shush"];
	[self.navigationController pushViewController:supportController animated:YES];
}

@end
