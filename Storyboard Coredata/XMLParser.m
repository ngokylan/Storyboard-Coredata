//
//  XMLParser.m
//  ParsingXMLTutorial
//
//  Created by kent franks on 3/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLParser.h"
#import "Notification.h"

@implementation XMLParser 
@synthesize notifications = _notifications;


NSMutableString	*currentNodeContent;
NSXMLParser		*parser;
Notification	*currentNotification;
bool            isStatus;

-(id) loadXMLByURL:(NSString *)urlString
{
	_notifications			= [[NSMutableArray alloc] init];
	NSURL *url		= [NSURL URLWithString:urlString];
	NSData	*data   = [[NSData alloc] initWithContentsOfURL:url];
	parser			= [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	[parser parse];
	return self;
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if ([elementname isEqualToString:@"notification"]) 
	{
		currentNotification = [Notification alloc];
        isStatus = YES;
	}
	if ([elementname isEqualToString:@"user"]) 
	{
        isStatus = NO;
	}
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isStatus) 
    {
        if ([elementname isEqualToString:@"title"]) 
        {
            currentNotification.title = currentNodeContent;
        }
        if ([elementname isEqualToString:@"description"]) 
        {
            currentNotification.description = currentNodeContent;
        }
        if ([elementname isEqualToString:@"attach"])
        {
            currentNotification.attach = currentNodeContent;
        }
        if ([elementname isEqualToString:@"created_at"])
        {
            currentNotification.date = currentNodeContent;
        }
        if ([elementname isEqualToString:@"id"])
        {
            currentNotification.staff_id = currentNodeContent;
        }
    }
	if ([elementname isEqualToString:@"notification"]) 
	{
		[self.notifications addObject:currentNotification];
		currentNotification = nil;
		currentNodeContent = nil;
	}
}

@end

