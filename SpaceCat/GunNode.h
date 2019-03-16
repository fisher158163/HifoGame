//
//  MachineNode.h
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GunNode : SKSpriteNode

// convience constructor (class method +)
+ (instancetype) gunAtPosition:(CGPoint)position;

@end
