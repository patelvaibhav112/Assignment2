//
//  CalculatorBrain.h
//  Calculator
//
//  Created by vaibhav patel on 9/1/12.
//  Copyright (c) 2012 vaibhav patel inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearStack;

@property (readonly)id program;
+(double) runProgram: (id)program;

//Assignment 2 Part 1
+(double) runProgram: (id)program usingVariableValues:(NSDictionary *) variableValues;
+(BOOL)isOperation: (NSString *)operation;
+(NSSet *)variablesUsedInProgram: (id)program;

//Assignment 2 Part 2
+(NSString *)descriptionOfProgram: (id)program;
@end
