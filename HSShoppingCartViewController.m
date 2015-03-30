//
//  HSShoppingCartViewController.m
//  honestShopping
//
//  Created by 张国俗 on 15-3-16.
//  Copyright (c) 2015年 张国俗. All rights reserved.
//

#import "HSShoppingCartViewController.h"
#import "PKYStepper.h"

@interface HSShoppingCartViewController ()

//@property (strong, nonatomic) PKYStepper *noneStepper;

@end

@implementation HSShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.noneStepper = [[PKYStepper alloc] initWithFrame:CGRectMake(100, 200, 200, 44)];
//    [self.noneStepper setCornerRadius:0.0f];
//    [self.noneStepper setBorderColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
//    UIColor *noneStepperColor = [UIColor colorWithRed:0.91 green:0.55 blue:0.22 alpha:1.0];
//    [self.noneStepper setLabelTextColor:noneStepperColor];
//    [self.noneStepper setButtonTextColor:noneStepperColor forState:UIControlStateNormal];
//    [self.noneStepper.decrementButton setBackgroundImage:[public ImageWithColor:[UIColor blueColor]] forState:UIControlStateNormal ];
//    self.noneStepper.value = 1.0f;
//    self.noneStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
//        stepper.countLabel.text = count == stepper.minimum ? @"None" : [NSString stringWithFormat:@"Cats: %@", @(count)];
//    };
//    [self.noneStepper setup];
//    [self.view addSubview:self.noneStepper];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
