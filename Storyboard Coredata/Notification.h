//
//  Notification.h
//  Storyboard Coredata
//
//  Created by Ngo Ky on 8/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (strong, nonatomic)NSString *date;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *description;
@property (strong, nonatomic)NSString *attach;
@property (strong, nonatomic)NSString *staff_id;
@property (strong, nonatomic)NSString *staff_name;
@end
