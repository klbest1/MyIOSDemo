//
//  ViewController.m
//  Wave
//
//  Created by lin kang on 17/12/18.
//  Copyright © 2018 lin kang. All rights reserved.
//

#import "ViewController.h"
#import "SKWaveView.h"

@interface ViewController ()
{
    SKWaveView *_waveView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _waveView = [SKWaveView addToView:self.view withFrame:CGRectMake(0, 0, 200, 200)] ;
    _waveView.center = [self.view center];
    [_waveView wave];
}


@end
