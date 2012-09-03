//
//  CalculatorViewController.m
//  Calculator
//
//  Created by vaibhav patel on 8/31/12.
//  Copyright (c) 2012 vaibhav patel inc. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;


- (CalculatorBrain *)brain
{
    if(!_brain)
        _brain = [[CalculatorBrain alloc]init];
    return _brain;
}
- (IBAction)digitPressed:(UIButton *)sender
{
    if(self.userIsInTheMiddleOfEnteringNumber)
    {
        NSString *digit = sender.currentTitle;
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else
    {
        self.display.text = sender.currentTitle;
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}

//Assignment 2: Part 2
//call model's description of program everytime operator is pressed.
- (IBAction)operatorPressed:(UIButton *)sender {
    
    //[self updateHistory: sender.currentTitle];
    double result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

//Assignment 2: Part 2
//no need to updateHistory when enter is pressed anymore.
- (IBAction)enterPressed {
    
    //[self updateHistory:self.display.text];
    //[self updateHistory: @"Enter"];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringNumber = NO;
    
}

//Assignment 1: Part 2.
- (IBAction)decimalPressed {
    
    //Check if "." is already entered before appending it.
    if([self.display.text rangeOfString:@"."].length == 0)
    {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}

//Assignment 1: Part 4
- (void)updateHistory: (NSString *) newText
{
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:newText];
    
}

//Assignment 1: Part 5
- (IBAction)clearPressed {
    [self.brain clearStack];
    self.historyDisplay.text = @" C";
    self.display.text = @"0";
}

@end
