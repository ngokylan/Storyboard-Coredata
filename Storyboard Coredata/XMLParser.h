//
//  XMLParser.h
//  ParsingXMLTutorial
//
//  Created by kent franks on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"

@interface XMLParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *notifications;

-(id) loadXMLByURL:(NSString *)urlString;

@end
