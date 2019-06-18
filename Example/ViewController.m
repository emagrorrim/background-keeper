//
//  ViewController.m
//  PLBackgroundKeeper
//
//  Created by Xin Guo  on 2019/6/18.
//  Copyright © 2019 org.emagrorrim. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

#import "Logger.h"

@interface ViewController ()

@property(nonatomic, strong) AFHTTPSessionManager *networkClient;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.networkClient = [[AFHTTPSessionManager alloc] init];
  [self requestData];
  UITextView *loggerDisplayer = Logger.displayer;
  loggerDisplayer.translatesAutoresizingMaskIntoConstraints = NO;
  loggerDisplayer.editable = NO;
  [self.view addSubview:loggerDisplayer];
  [NSLayoutConstraint activateConstraints:@[
    [loggerDisplayer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [loggerDisplayer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [loggerDisplayer.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor],
    [loggerDisplayer.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor],
  ]];
}

- (void)requestData {
  [self.networkClient GET:@"https://device-library-api.herokuapp.com/devices/3d1c2339-7a1d-4806-9848-9171f42320cf"
               parameters:nil
                 progress:^(NSProgress * _Nonnull downloadProgress) {}
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSDictionary *json = responseObject;
                    [Logger info:json[@"name"]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [self requestData];
                    });
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [Logger error:[error localizedDescription]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [self requestData];
                    });
                  }];
}

@end
