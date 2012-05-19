//
//  StatusItemController.m
//  D3Status
//
//  Created by Chris Ledet on 5/18/12.
//  Copyright (c) 2012 Chris Ledet. All rights reserved.
//

#import "StatusItemController.h"
#import "D3StatusParser.h"

#define STATUS_UP_IMAGE_NAME @"up.png"
#define STATUS_DOWN_IMAGE_NAME @"down.png"

@interface StatusItemController()
-(void)assignImageToStatusBar;
-(NSString*)fetchAppropriateImageName;
@end

@implementation StatusItemController

-(void)awakeFromNib
{
    if (statusItem == nil) {
        statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
    }

    [self assignImageToStatusBar];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        while (true) {
            sleep(5);
            [self assignImageToStatusBar];
#if DEBUG
            NSLog(@"Checking server status");
#endif
        }
    });
}

-(void)assignImageToStatusBar
{
    NSString *imageName = [self fetchAppropriateImageName];
    NSImage *menuImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForImageResource:imageName]];
    menuImage.scalesWhenResized = YES;
    menuImage.size = NSMakeSize(NSStatusBar.systemStatusBar.thickness - 1, NSStatusBar.systemStatusBar.thickness - 1);
    statusItem.image = menuImage;
}

-(NSString*)fetchAppropriateImageName
{
    D3StatusParser *parser = [[D3StatusParser alloc] init];
    if ([[parser gameServerStatusForUS] isEqualToString:@"Available"]) {
        return STATUS_UP_IMAGE_NAME;
    }

    return STATUS_DOWN_IMAGE_NAME;
}

@end
