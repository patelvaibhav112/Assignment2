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
//Assignment 2 Part 3
@property (nonatomic,strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize variableDisplay = _variableDisplay;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;
@synthesize testVariableValues =_testVariableValues;

- (CalculatorBrain *)brain
{
    if(!_brain)
        _brain = [[CalculatorBrain alloc]init];
    return _brain;
}

- (NSDictionary *)testVariableValues
{
    if(!_testVariableValues)
        _testVariableValues = [[NSDictionary alloc]init];
    return _testVariableValues;
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
//Assignment 2: Part 3
//pushing variables in the model as soon as they are pressed.
- (IBAction)enterPressed:(UIButton *)sender {
    
    //[self updateHistory:self.display.text];
    //[self updateHistory: @"Enter"];
    if([sender.currentTitle isEqualToString:@"a"] ||
       [sender.currentTitle isEqualToString:@"b"] ||
       [sender.currentTitle isEqualToString:@"x"])
        [self.brain pushVariable:sender.currentTitle];
    else
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringNumber = NO;
    
}
//Assignment 2: Part 3
//Adding method to test variable values
- (IBAction)testPressed:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:@"Test1"])
    {
        self.testVariableValues = [[NSDictionary alloc]initWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:2.0],@"x",
                                   [NSNumber numberWithDouble:3.0],@"a",
                                   [NSNumber numberWithDouble:4.0],@"b",
                                    nil];
        double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
        self.display.text = [NSString stringWithFormat:@"%g",result];
        self.variableDisplay.text = @"x = 2, a = 3, b = 4";
    }
    else if([sender.currentTitle isEqualToString:@"Test2"])
    {
        self.testVariableValues = [[NSDictionary alloc]initWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:-2.0],@"x",
                                   [NSNumber numberWithDouble:3.0],@"a",
                                   nil];
        double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
        self.display.text = [NSString stringWithFormat:@"%g",result];
        self.variableDisplay.text = @"x = -2, a = 3";
    }
    else if([sender.currentTitle isEqualToString:@"Test3"])
    {
        self.testVariableValues = [[NSDictionary alloc]initWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:0],@"a",
                                   [NSNumber numberWithDouble:4.0],@"b",
                                   nil];
        double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
        self.display.text = [NSString stringWithFormat:@"%g",result];
        self.variableDisplay.text = @"a = 0, b = 4";
    }
}


//Assignment 2 Part 4
- (IBAction)undoPressed
{
 
    //if user is in middle of entering number, delete the last digit entered
    if(self.userIsInTheMiddleOfEnteringNumber)
    {
        //if there is no more digits to delete while useris in middle of entering number
        NSString *currentDisplayContent = self.display.text;
        
        if ( [currentDisplayContent length] > 0)
            self.display.text = [currentDisplayContent substringToIndex:[currentDisplayContent length] - 1];
        
        //the user is not in middle of entering a number anymore
        else
            self.userIsInTheMiddleOfEnteringNumber = NO;
        
    }
    //if user is not in middle of entering number, remove the last item from the model
    else
    {
        //remove the last item from model
        [self.brain removeLastObjectFromStack];
        //the user is not in middle of entering a number anymore
        //run the program on model and update display
        double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
        self.display.text = [NSString stringWithFormat:@"%g",result];
        self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
        
    }
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
    self.historyDisplay.text = @"";
    self.display.text = @"0";
    self.variableDisplay.text = @"";
}

- (void)viewDidUnload {
    [self setVariableDisplay:nil];
    [super viewDidUnload];
}
@end
