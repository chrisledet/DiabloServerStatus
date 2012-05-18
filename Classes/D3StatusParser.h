//
//  D3StatusParser.h
//  D3Status
//
//  Created by Chris Ledet on 5/16/12.
//  Copyright (c) 2012 Chris Ledet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface D3StatusParser : NSObject {
    NSArray *statuses;
}

-(NSString*)gameServerStatusForUS;
-(NSString*)gameServerStatusForEurope;
-(NSString*)gameServerStatusForAsia;

@end
