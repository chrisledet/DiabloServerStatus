//
//  D3StatusParser.m
//  D3Status
//
//  Created by Chris Ledet on 5/16/12.
//  Copyright (c) 2012 Chris Ledet. All rights reserved.
//

#define STATUS_UP @"UP"
#define STATUS_DOWN @"DOWN"
#define STATUS_UNKNOWN @"UNKNOWN"
#define D3_STATUS_WEBSITE @"http://us.battle.net/d3/en/status"

#define US_GAME_SERVER_STATUS_INDEX   0
#define EURO_GAME_SERVER_STATUS_INDEX 17
#define ASIA_GAME_SERVER_STATUS_INDEX 26

#import "D3StatusParser.h"
#import "HTMLParser.h"

@interface D3StatusParser()
-(NSArray*)fetchServerStatuses;
@end

@implementation D3StatusParser

-(id)init
{
    self = [super init];
    
    if (self) {
        statuses = [self fetchServerStatuses];
    }
    
    return self;
}

-(NSString*)gameServerStatusForUS
{
    return [statuses objectAtIndex:US_GAME_SERVER_STATUS_INDEX];
}

-(NSString*)gameServerStatusForEurope
{
    return [statuses objectAtIndex:EURO_GAME_SERVER_STATUS_INDEX];
}

-(NSString*)gameServerStatusForAsia
{
    return [statuses objectAtIndex:ASIA_GAME_SERVER_STATUS_INDEX];
}

/* private methods */

-(NSArray*)fetchServerStatuses
{
    NSMutableArray *statusNodes = [[NSMutableArray alloc] init];
    NSError *error = nil;    
    NSString *htmlFromBattleNet = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:D3_STATUS_WEBSITE] encoding:NSUTF8StringEncoding error:&error];

    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlFromBattleNet error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        HTMLNode *bodyNode = [parser body];
        
        NSArray *inputNodes = [bodyNode findChildTags:@"div"];
        
        for (HTMLNode *inputNode in inputNodes) {
            if ([[inputNode getAttributeNamed:@"class"] rangeOfString:@"status-icon"].location != NSNotFound) {
                NSString *status = [inputNode getAttributeNamed:@"data-tooltip"];
                if (status) {
                    NSLog(@"Status: %@", [inputNode getAttributeNamed:@"data-tooltip"]);
                    [statusNodes addObject:status];
                }
            }
        }
        
        NSLog(@"There are %lu statuses", [statusNodes count]);   
    }
    
    return statusNodes;
}

@end
