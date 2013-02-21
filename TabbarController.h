//
//  TabbarController.h
//  Storyboard Coredata
//
//  Created by Ngo Ky on 7/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TabbarController : UITabBarController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (retain, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (retain, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (retain, nonatomic) IBOutlet UILabel *displayLabel;
@end
