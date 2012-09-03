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

//Assignment 2: Part 1
//modifying this method so that it now calls the new runprogram:usingVariableValues method for further processing.
+ (double)runProgram:(id)program
{
    NSDictionary *variableValues = [[NSDictionary alloc]init];
    return [CalculatorBrain runProgram:program usingVariableValues:variableValues];
}

//Assignment 2: part 1
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    [CalculatorBrain variablesUsedInProgram:program];
    //TODO: replace the variables in the programstack with the values supplied from dictionary.
    if([program isKindOfClass:[NSArray class]])
    {
        //Convert program to NSMutableArray object because we want to modify this array by replacing the string variables with their numeric values
        NSMutableArray *mutableCopyOfProgram = [program mutableCopy];
        
        //Iterate through programStack
        for(int i=0; i <[mutableCopyOfProgram count]; i++)
        {
            
            id programObject = [mutableCopyOfProgram objectAtIndex:i];
            
            //If the object in program stack is a Number, there's no need for replacement.
            if([programObject isKindOfClass:[NSNumber class]])
                continue;
            
            //If the object in program stack is a String, we need to replace it with a value from dictionary or 0.
            if([programObject isKindOfClass:[NSString class]])
            {
                NSString *variable = programObject;
                
                //We cannot assume that every string object in the stack will be a variable since operators are also string objects.
                //Make sure the string object we are replacing is not an operator.
                if([CalculatorBrain isOperation:variable])
                {
                    continue;
                }
                
                //Search for a possible value in the variableValues for each element in the program
                NSNumber *variableValue = [variableValues valueForKey:variable];
                
                //if value not found then replace that variable with 0.
                if(!variableValue)
                {
                    [mutableCopyOfProgram replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:0.0]];
                }
                //if value found then replace that variable with the value.
                else
                {
                    [mutableCopyOfProgram replaceObjectAtIndex:i withObject:variableValue];
                }
            }
        }
        return [CalculatorBrain popOperandOffStack: mutableCopyOfProgram];
    }
    //The program cookie is not of the type NSArray, hence we cannot run this program
    else
        return 0.0;
}

//Assignment 2 Part 1
+ (BOOL)isOperation:(NSString *)operation
{
    if([operation isEqualToString:@"+"] ||
       [operation isEqualToString:@"-"] ||
       [operation isEqualToString:@"*"] ||
       [operation isEqualToString:@"/"] ||
       [operation isEqualToString:@"sin"] ||
       [operation isEqualToString:@"pie"] ||
       [operation isEqualToString:@"cos"] ||
       [operation isEqualToString:@"log"] ||
       [operation isEqualToString:@"sqrt"])
        return YES;
        else
            return NO;
}

//Assignment 2 Part 1
+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableArray *variablesFound = [[NSMutableArray alloc]init];
    
    //TODO: find the variables in the programstack and return a NSSet.
    if([program isKindOfClass:[NSArray class]])
    {
        
        //Iterate through programStack
        for(int i=0; i <[program count]; i++)
        {
            
            id programObject = [program objectAtIndex:i];
            
            //Skip the Number object in program stack
            if([programObject isKindOfClass:[NSNumber class]])
                continue;
            
            //If the object in program stack is a String, we are interested.
            if([programObject isKindOfClass:[NSString class]])
            {
                NSString *variable = programObject;
                
                //We cannot assume that every string object in the stack will be a variable since operators are also string objects.
                //Make sure the string object we want is not an operator.
                if([CalculatorBrain isOperation:variable])
                    continue;
                
                //add the variable in the set
                [variablesFound addObject:variable];
            }
        }
        
        //Assignment states we should not return an empty set if there are no variables found.
        if([variablesFound count] <=0)
            return nil;
        else
            return [NSSet setWithArray:variablesFound];
    }
    //The program cookie is not of the type NSArray, hence we cannot run this program
    else
        return nil;
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
