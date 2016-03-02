//
//  CCNewsDetailController.m
//  News
//
//  Created by 陈锦聪 on 16/3/1.
//  Copyright © 2016年 Cong. All rights reserved.
//

#import "CCNewsDetailController.h"
#import "CCApiManager.h"

@interface CCNewsDetailController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,copy) NSString *body;
@property (nonatomic,copy) NSString *newsTitle;
@property (nonatomic,copy) NSString *time;

@end

@implementation CCNewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.view = self.webView;
    // 解决跳转卡顿问题
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}

- (void)loadData {
    [[CCApiManager sharedApi] requestDataWithURLString:self.newsURL success:^(NSDictionary * responseObject) {
        
        NSString *key = responseObject.keyEnumerator.nextObject;
        NSDictionary *data = responseObject[key];
       
        __block NSString *body = data[@"body"];
        NSArray *images = data[@"img"];
  
        [images enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *ref = obj[@"ref"];
            // 替换图片
            body = [body stringByReplacingOccurrencesOfString:ref withString:[self htmlHTMLWithDict:obj]];
        }];
        
        NSArray *videos = data[@"video"];
        [videos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *ref = obj[@"ref"];
            body = [body stringByReplacingOccurrencesOfString:ref withString:[self videoHTMLWithDict:obj]];
        }];
        self.body = body;
        self.newsTitle = data[@"title"];
        self.time = [NSString stringWithFormat:@"%@  %@",data[@"ptime"],data[@"source"]];

        // 加载本地html
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"detail.html" withExtension:nil];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
//        [self.webView loadHTMLString:body baseURL:nil];
        
    } error:^(NSError *errorInfo) {
        
    }];
}

- (NSString *)htmlHTMLWithDict:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"<img src=\"%@\" width=\"100%%\"  alt=\"%@\"/><span style=\"font-size: 13px;color: dimgrey\">%@</span>",dict[@"src"],dict[@"alt"],dict[@"alt"]];
}

- (NSString *)videoHTMLWithDict:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"<video width=\"100%%\" controls>"
            "<source src=\"%@\""
            " type=\"video/mp4\">"
            "您的浏览器不支持 HTML5 video 标签。"
            "</video><span style=\"font-size: 13px;color: dimgrey\">%@</span>",dict[@"url_mp4"],dict[@"alt"]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *code = [NSString stringWithFormat:@"changeContent('%@','%@','%@')",self.newsTitle,self.time,self.body];
    [webView stringByEvaluatingJavaScriptFromString:code];
}
@end
