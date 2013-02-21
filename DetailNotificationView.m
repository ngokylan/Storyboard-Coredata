//
//  DetailNotificationView.m
//  Storyboard Coredata
//
//  Created by Ngo Ky on 8/11/12.
//  Copyright (c) 2012 Ngo Ky. All rights reserved.
//

#import "DetailNotificationView.h"
#import "UIScrollView_PagingViewController.h"

@interface DetailNotificationView ()

@end

@implementation DetailNotificationView
@synthesize date;
@synthesize title;
@synthesize desc;
@synthesize attachFileLink;
@synthesize staff_id;
@synthesize tvTitle;
@synthesize tvDescription;
@synthesize tvDate;
@synthesize webViewAttachFile;
@synthesize mainView;
@synthesize uiWindow;
@synthesize viewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    tvTitle.text = title;
    tvDate.text = date;
    tvDescription.text = desc;
    
    //call function to load pdf file
    [self loadRemotePdf];
    
    UIScrollView_PagingViewController *paController = [[UIScrollView_PagingViewController alloc] initWithNibName:@"UIScrollView_PagingViewController" bundle:nil];
    [self.view addSubview:paController.view];
}

//load remote pdf file from local storage
- (void) loadRemotePdf
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = rect.size;
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenSize.width-20,screenSize.height-5)];
    webview.autoresizesSubviews = YES;
    webview.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    NSString *dowloadPath =
    [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"test.pdf"];
    
    NSURL *myUrl = [NSURL fileURLWithPath:dowloadPath];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
    
    [webview loadRequest:myRequest];
    [self.webViewAttachFile addSubview:webview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Dealloc method declared in DetailViewController.m
- (void)dealloc {
    [date release];
    [title release];
    [desc release];
    [attachFileLink release];
    [staff_id release];
    [_tableView release];
    [_vController release];
    [tvTitle release];
    [tvDescription release];
    [tvDate release];
    [webViewAttachFile release];
    [mainView release];
    [UIWindow release];
    [super dealloc];
}



- (IBAction)btnDone:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)changePage:(id)sender {
}
- (IBAction)IBActionchangePage:(UIPageControl *)sender {
}
@end