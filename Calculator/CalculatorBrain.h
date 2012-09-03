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

@end
