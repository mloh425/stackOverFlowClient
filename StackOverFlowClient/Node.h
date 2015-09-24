//
//  Node.h
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/20/15.
//  Copyright © 2015 CodeFellows. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

@property (nonatomic) NSInteger value;
@property (retain, nonatomic) Node *left;
@property (retain, nonatomic) Node *right;

-(BOOL)addValue:(NSInteger)value;

@end
