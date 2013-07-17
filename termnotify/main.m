//
//  main.m
//  termnotify
//
//    (The WTFPL)
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    Version 2, December 2004
//
//    Copyright (C) 2013 Derek Wang
//
//    Everyone is permitted to copy and distribute verbatim or modified
//    copies of this license document, and changing it is allowed as long
//    as the name is changed.
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
//
//    0. You just DO WHAT THE FUCK YOU WANT TO.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


#pragma mark - Swizzle NSBundle

NSString *fakeBundleIdentifier = nil;

@implementation NSBundle(swizle)

// Overriding bundleIdentifier works, but overriding NSUserNotificationAlertStyle does not work.

- (NSString *)__bundleIdentifier
{
    if (self == [NSBundle mainBundle]) {
        return fakeBundleIdentifier ? fakeBundleIdentifier : @"com.apple.terminal";
    } else {
        return [self __bundleIdentifier];
    }
}

@end

BOOL installNSBundleHook()
{
    Class class = objc_getClass("NSBundle");
    if (class) {
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(bundleIdentifier)),
                                       class_getInstanceMethod(class, @selector(__bundleIdentifier)));
        return YES;
    }
	return NO;
}


#pragma mark - NotificationCenterDelegate

@interface NotificationCenterDelegate : NSObject<NSUserNotificationCenterDelegate>

@property (nonatomic, assign) BOOL keepRunning;

@end

@implementation NotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    printf("Notification delivered!\n");
    self.keepRunning = NO;
}

@end


#pragma mark -

void printHelp();

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (installNSBundleHook()) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

            (fakeBundleIdentifier = [defaults stringForKey:@"i"]) || (fakeBundleIdentifier = [defaults stringForKey:@"-identifier"]);

            NSUserNotificationCenter *nc = [NSUserNotificationCenter defaultUserNotificationCenter];
            NotificationCenterDelegate *ncDelegate = [[NotificationCenterDelegate alloc]init];
            ncDelegate.keepRunning = YES;
            nc.delegate = ncDelegate;

            NSUserNotification *note = [[NSUserNotification alloc] init];
            (note.title = [defaults stringForKey:@"t"]) || (note.title == [defaults stringForKey:@"-title"]);
            (note.subtitle = [defaults stringForKey:@"s"]) || (note.subtitle = [defaults stringForKey:@"-subtitle"]);
            (note.informativeText = [defaults stringForKey:@"m"]) || (note.informativeText = [defaults stringForKey:@"-message"]);

            if (!(note.title || note.subtitle || note.informativeText)) {
                printHelp();
                return 0;
            }

            [nc deliverNotification:note];
            while (ncDelegate.keepRunning) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
            }
        }
    }
    return 0;
}

void printHelp() {
    printf("Usage: termnotify [--title <title>] [--subtitle <subtitle>] [--message <text>] [--identifier <identifier>]\n" \
           "\n" \
           "Options:\n" \
           "-i, --identifier NAME        some existing app identifier(default: com.apple.terminal)\n" \
           "-t, --title TEXT             title text\n" \
           "-s, --subtitle TEXT          subtitle text\n" \
           "-m, --message TEXT           informative text\n" \
           "\n" \
           );
}
