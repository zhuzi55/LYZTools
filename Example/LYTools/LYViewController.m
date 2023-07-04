//
//  LYViewController.m
//  LYTools
//
//  Created by zhuzi55 on 01/06/2023.
//  Copyright (c) 2023 zhuzi55. All rights reserved.
//

#import "LYViewController.h"
#import "LYZTool.h"

@interface LYViewController ()


@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor yellowColor];
        
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        
//    [[LYZTool sharedInstance] getLocationWithCallback:^(NSDictionary * _Nonnull dict) {
//
//        NSLog(@"定位信息 == %@", dict);
//
//    }];

//    [[LYZTool sharedInstance] getAddressWithCallback:^(NSDictionary * _Nonnull dict) {
//
//        NSLog(@"位置信息 == %@", dict);
//
//    }];

}



@end
