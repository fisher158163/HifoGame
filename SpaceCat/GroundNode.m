//
//  GroundNode.m
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//
#import "GroundNode.h"
#import "Util.h"

@implementation GroundNode

// create scene (convenience contructor)
+ (instancetype) groundWithSize:(CGSize)size {
    GroundNode *ground = [self spriteNodeWithColor:[SKColor colorWithWhite:255 alpha:0] size:size];
    ground.name = @"Ground'";
    ground.position = CGPointMake(size.width/2, size.height/2);
    ground.zPosition = 7;
    [ground setupPhysicsBody];
    
    return ground; // create ground
}

// scene additional characteristics
- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO; // not effected by the physics
    self.physicsBody.categoryBitMask = collisionCategoryGround; // which category does the ground belong to?
    self.physicsBody.collisionBitMask = collisionCategoryDebris;
    self.physicsBody.contactTestBitMask = collisionCategoryEnemy;
}

@end
