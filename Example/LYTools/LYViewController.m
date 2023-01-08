//
//  LYViewController.m
//  LYTools
//
//  Created by zhuzi55 on 01/06/2023.
//  Copyright (c) 2023 zhuzi55. All rights reserved.
//

#import "LYViewController.h"
#import "NSString+LYCommon.h"


@interface LYViewController ()

@property (nonatomic, strong) UIImageView *v;

@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor yellowColor];
        
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan");
        
//    NSString *str = [@"test" ly_utf8String];
//    NSLog(@"字符串 == %@", str);
}

@end
