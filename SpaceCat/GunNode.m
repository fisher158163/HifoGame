//
//  MachineNode.m
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//

#import "GunNode.h"

@implementation GunNode

// create gun object (convenience contructor)
+ (instancetype) gunAtPosition:(CGPoint)position {
    GunNode *gun = [self spriteNodeWithImageNamed:@"sniper_1"]; // create instance of gun (variable of the class to return later)
    
    // characteristics
    gun.position = position;
    gun.zPosition = 8;
    gun.anchorPoint = CGPointMake(0.5,0);
    gun.name = @"Gun";
    
    // want animation repeated forever (constantly animating)
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"sniper_1"],
                          [SKTexture textureWithImageNamed:@"sniper_2"]];
    
    SKAction *gunAnimation = [SKAction animateWithTextures:textures timePerFrame:0.3];
    SKAction *gunRepeat = [SKAction repeatActionForever:gunAnimation];
    [gun runAction:gunRepeat];
    
    return gun; // return the instance
}

@end
