//
//  TGMapViewController.m
//  TMapsSample
//
//  Created by Shady Sayed on 12/15/16.
//  Copyright © 2016 Tagipedia. All rights reserved.
//

#import "TGMapViewController.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKScriptMessageHandler.h>



@interface TGMapViewController () <WKScriptMessageHandler, WKNavigationDelegate>
@property (nonatomic, weak) WKWebView* webView;
@end


@implementation TGMapViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setTagipediaObjectAndLoadMap];
    
}

-(void) loadView {
    [super loadView];
    [self loadWebView];
}

-(void) loadWebView {
    WKWebView* webView = [[WKWebView alloc] init];
    self.webView = webView;
    self.webView.navigationDelegate = self;
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:webView];
    
    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:webView
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:self.view
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:webView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:self.view
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:webView
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:self.view
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0.f];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:webView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:self.view
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    [self.view addConstraint:width];
    [self.view addConstraint:height];
    [self.view addConstraint:top];
    [self.view addConstraint:leading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) setTagipediaObjectAndLoadMap {
    NSString* __tbString = @"window.__tb__ = {dispatch: function(action) {webkit.messageHandlers.__tb__.postMessage(action); } }";
    
    //[self injectScript:__tbString atTime:WKUserScriptInjectionTimeAtDocumentStart];
    [self injectScript:__tbString atTime:WKUserScriptInjectionTimeAtDocumentEnd];
    
    
    WKWebView* webview = (WKWebView*) self.webView;
    [webview.configuration.userContentController addScriptMessageHandler:self name:@"__tb__"];
    
    [self navigateWebView];
    
}

-(void) injectScript:(NSString*) script atTime:(WKUserScriptInjectionTime) time {
    WKWebView* webview = (WKWebView*) self.webView;
    WKUserScript* userScript = [[WKUserScript alloc] initWithSource:script injectionTime:time forMainFrameOnly:YES];
    [webview.configuration.userContentController addUserScript:userScript];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        [self.delegate mapViewController:self didReceiveDispatchWithCommand:(NSDictionary *)message.body];
    }
}


-(void) navigateWebView {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"tmapswww/index" ofType:@"html"];
    NSError* error;
    NSString* htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    htmlString = [self transformHtmlStringForTMaps:htmlString];
    
    if (!error) {
        NSURL* baseUrl = [[NSBundle mainBundle] URLForResource:@"tmapswww/index" withExtension:@"html"];
        [self.webView loadHTMLString:htmlString baseURL:baseUrl];
    }
}

-(NSString*) transformHtmlStringForTMaps:(NSString*) htmlString {
    NSMutableString* result = [NSMutableString stringWithString:htmlString];
    
//    NSRegularExpression *baseRegex = [NSRegularExpression regularExpressionWithPattern:
//                                  @"\\<base[ \\t][^\\>]*\\>" options:NSRegularExpressionCaseInsensitive error:nil];
//    
//    //Remove old base
//    [baseRegex replaceMatchesInString:result options:NSMatchingReportProgress range:NSMakeRange(0, [htmlString length]) withTemplate:@""];
//    
//    NSString* rootPath = [[NSBundle mainBundle] pathForResource:@"tmapswww/index" ofType:@"html"];
//    rootPath = [rootPath stringByReplacingOccurrencesOfString:@"index.html" withString:@""];
//    NSString *replaceString= [NSString stringWithFormat:@"</title><base href=\"%@\">", rootPath];
//    
//    [result replaceOccurrencesOfString:@"</title>" withString:replaceString options:NSCaseInsensitiveSearch range:NSMakeRange(0, [result length])];
//
    
    [result replaceOccurrencesOfString:@"embed-class-placeholder" withString:@"embed-class-placeholder ios-embed" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [result length])];
    
    return [result copy];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) dispatch:(NSDictionary *)command {
    
    [self performSelectorOnMainThread:@selector(dispatchInternal:) withObject:command waitUntilDone:NO];
}

-(void) dispatchInternal:(NSDictionary *)command {
    
    NSError*error;
    NSData *commandJsonData = [NSJSONSerialization dataWithJSONObject:command options:0 error:&error];
    NSString* commandJson = [[NSString alloc] initWithData:commandJsonData encoding:NSUTF8StringEncoding];
    NSString* commandString = [NSString stringWithFormat:@"Tagipedia.dispatch(%@)", commandJson];
    //NSLog(@"%@", commandString);
    [self.webView evaluateJavaScript:commandString completionHandler:^(id result, NSError* error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
     NSLog(@"%s",__FUNCTION__);
}

@end
