//
//  Node.m
//  StackOverFlowClient
//
//  Created by Sau Chung Loh on 9/20/15.
//  Copyright © 2015 CodeFellows. All rights reserved.
//

#import "Node.h"

@implementation Node

-(BOOL)addValue:(NSInteger)value {
  if(value == self.value) {
    return false;
  } else if (value > self.value) {
    if(!self.right) {
      Node *node = [[Node alloc] init];
      node.value = value;
      self.right = node;
      [node release];
      return true;
    } else {
      return [self.right addValue:value];
    }
  } else {
    if (!self.left) {
      Node *node = [[Node alloc] init];
      node.value = value;
      self.left = node;
      [node release];
      return true;
    } else {
      return [self.left addValue:value];
    }
  }
}

//-(BOOL)removeValue:(NSInteger)value {
//  
//}

@end
