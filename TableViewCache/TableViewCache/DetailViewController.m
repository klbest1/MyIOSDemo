//
//  DetailViewController.m
//  TableViewCache
//
//  Created by lin kang on 19/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>

@interface DetailViewController ()<WKNavigationDelegate>
{
    WKWebView *_webView;
    UIActivityIndicatorView *_progressView;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_webView == nil) {
        _webView = [WKWebView new];
        _webView.navigationDelegate = self;
    }
    _webView.frame = self.view.bounds;
    
    if (_progressView == nil) {
        _progressView = [UIActivityIndicatorView new];
        _progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    _progressView.center = self.view.center;
    
    [self.view addSubview:_webView];
    [self.view addSubview:_progressView];

    NSURLRequest *requst = [NSURLRequest requestWithURL:self.detailURL];
    [_webView loadRequest:requst];
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    [_progressView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [_progressView stopAnimating];

}
@end
