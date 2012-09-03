//
//  CalculatorBrain.m
//  Calculator
//
//  Created by vaibhav patel on 9/1/12.
//  Copyright (c) 2012 vaibhav patel inc. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic,strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if(_programStack == nil)
        _programStack = [[NSMutableArray alloc]init];
    return _programStack;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (id)program
{
    return [self.programStack copy];
}


- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]])
        stack = [program mutableCopy];
    return [CalculatorBrain popOperandOffStack: stack];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack)[stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    
    if([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack: stack] + [self popOperandOffStack: stack];
        } else if([operation isEqualToString:@"*"]){
            result = [self popOperandOffStack: stack] * [self popOperandOffStack: stack];
        } else if([operation isEqualToString:@"-"]){
            result = [self popOperandOffStack: stack] - [self popOperandOffStack: stack];
        }
        //Assignment 1 Part 6
        else if([operation isEqualToString:@"/"]){
            double operand1  = [self popOperandOffStack: stack];
            double operand2 = [self popOperandOffStack: stack];
            if(operand2 == 0)
                result = 0;
            else
                result = operand1 / operand2;
        }
        //Assignment 1 Part 3
        else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffStack: stack]);
        } else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffStack: stack]);
        } else if([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffStack: stack]);
        } else if([operation isEqualToString:@"log"]){
            result = log([self popOperandOffStack: stack]);
        } else if([operation isEqualToString:@"pi"]){
            result = M_PI;
        }
    }
    return result;
}




-(void)clearStack
{
    [self.programStack removeAllObjects];
    
}

@end
