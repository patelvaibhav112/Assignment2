//
//  CalculatorViewController.h
//  Calculator
//
//  Created by vaibhav patel on 8/31/12.
//  Copyright (c) 2012 vaibhav patel inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *historyDisplay;
//Assignment 2 Part 3
@property (weak, nonatomic) IBOutlet UILabel *variableDisplay;

@end
