//
//  ViewController.m
//  LJFont
//
//  Created by nero on 2017/3/20.
//  Copyright © 2017年 nero. All rights reserved.
//

#import "ViewController.h"
#import "TBCityIconFont.h"
#import "UIImage+TBCityIconFont.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    &#xe889;
    self.imageView.image = [UIImage iconWithInfo:TBCityIconInfoMake(@"\U0000e889", 80, [UIColor redColor])];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
