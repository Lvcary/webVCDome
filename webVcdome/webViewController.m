//
//  webViewController.m
//  webVCDome
//
//  Created by 刘康蕤 on 16/1/25.
//  Copyright © 2016年 Lvcary. All rights reserved.
//
/**
    关于iOS9请求https的问题
    在info.plist里添加 NSAppTransportSecurity(dictionary)设置 NSAllowsArbitraryLoads=YES
 */

#import "webViewController.h"
#import "PopoverView.h"
#import "NJKWebViewProgress.h"
#include "NJKWebViewProgressView.h"
@interface webViewController ()<NJKWebViewProgressDelegate,UIWebViewDelegate>

@property (nonatomic,weak) UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;

@property (nonatomic, strong) UIButton *backButon;  //返回
@property (nonatomic, strong) UIButton *closeButton;  //关闭

@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64)];
    web.scalesPageToFit = YES;
    web.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:web];
    self.webView = web;
    
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    
    @autoreleasepool
    {
        NSURL *url = [NSURL URLWithString:self.webUrlStr];
        NSURLRequest *rq = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:rq];
        
        NSString *absurl = [url.host stringByReplacingOccurrencesOfString:@"www." withString:@""];
        UILabel *tipLabel = [[ UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 24)];
        tipLabel.text = [NSString stringWithFormat:@"网页由 %@ 提供", absurl];
        tipLabel.font = [UIFont systemFontOfSize:12];
        tipLabel.textColor = [UIColor blackColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.webView addSubview:tipLabel];
        [self.webView bringSubviewToFront:self.webView.scrollView];
    }
    
    [self setLeftItem];
    [self setRightItem];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    [_progressView removeFromSuperview];
}

- (void)backItemAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLeftItem{
    if ([_webView canGoBack]) {
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButon];
        UIBarButtonItem * closeItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem,closeItem, nil];
    }else{
        UIBarButtonItem * backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButon];
        
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backItem, nil];
    }
}

- (UIButton *)backButon{
    if (!_backButon) {
        _backButon = [UIButton buttonWithType:UIButtonTypeSystem];
        _backButon.frame = CGRectMake(0, 0, 45, 30);
        [_backButon setImage:[UIImage imageNamed:@"arrow_nav"] forState:0];
        [_backButon setTitle:@"返回" forState:0];
        
        [_backButon setTitleEdgeInsets:UIEdgeInsetsMake(5, -15, 5, 0)];
        [_backButon setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 33)];
        
        [_backButon addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButon;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeButton.frame = CGRectMake(0, 0, 35, 25);
        [_closeButton setTitle:@"关闭" forState:0];
        
        [_closeButton addTarget:self action:@selector(closeBtnActon:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (void)setRightItem{
    switch (self.itemType) {
        case webRightItemShare:
        {
            UIButton* ilogin = [UIButton buttonWithType:UIButtonTypeCustom];
            [ilogin setFrame:CGRectMake(0, 0, 22, 22)];
            [ilogin setShowsTouchWhenHighlighted:YES];
            [ilogin setBackgroundImage:[UIImage imageNamed:@"share_prss.png"] forState:UIControlStateNormal];
            [ilogin addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ilogin];
            
        }
            break;
        case webrightItemCare:
        {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关注"
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(careAction:)];
        }
            break;
        case webRightItemCustom:
        {
            
        }
            break;
            
        default:
            break;
    }

}



#pragma mark ---Action---
- (void)shareAction:(id)sender{
    NSArray *array = [NSArray arrayWithObjects:@"新浪微博",@"朋友圈",@"QQ空间",@"邮件", nil];
    NSArray *arrayImage = [NSArray arrayWithObjects:@"sina_on@2x",@"wechat_icon@2x",@"qzone_on@2x",@"email_on@2x", nil];
    CGPoint point = CGPointMake(CGRectGetWidth(self.view.frame) - 30, 64);
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:array images:arrayImage];
    pop.selectRowAtIndex = ^(NSInteger index){
        
    };
    [pop show];
}

- (void)careAction:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"关注" message:@"关注开始" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSLog(@"已经关注");
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)backBtnAction:(UIButton *)sender{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeBtnActon:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  ----webvieDelegate---
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setLeftItem];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *rulStr = [NSString stringWithFormat:@"%@",request.URL];
    NSLog(@"rulStr = %@",rulStr);
    return YES;
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title)
    {
        self.title = title;
    }
}

- (void)dealloc{
    [_webView stopLoading];
    _webView.delegate = nil;
    self.webView = nil;
}

@end
