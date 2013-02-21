//
//  DetailNotificationView.h
//  Storyboard Coredata
//
//  Created by Ngo Ky on 8/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIScrollView_PagingViewController;

@interface DetailNotificationView : UIViewController<UIScrollViewDelegate> {
    NSString *date;
    NSString *title;
    NSString *desc;
    NSString *attachFileLink;
    NSString *staff_id;
    
    UIWindow *window;
    UIScrollView_PagingViewController *viewController;

}
- (IBAction)btnDone:(id)sender;

@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *attachFileLink;
@property (nonatomic, retain) NSString *staff_id;
@property (retain, nonatomic) IBOutlet UIWindow *uiWindow;

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UINavigationBar *vController;
@property (retain, nonatomic) IBOutlet UIView *mainView;

@property (retain, nonatomic) IBOutlet UITextView *tvTitle;
@property (retain, nonatomic) IBOutlet UITextView *tvDescription;
@property (retain, nonatomic) IBOutlet UITextView *tvDate;
@property (retain, nonatomic) IBOutlet UIWebView *webViewAttachFile;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIScrollView_PagingViewController *viewController;



@end
