//
//  SpaceDogNode.m
//  SpaceCat
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Treehouse. All rights reserved.
//

#import "BaloonNode.h"
#import "Util.h"

@implementation BaloonNode

// create scene (convenience contructor)
+ (instancetype) baloonOfType:(baloonType)type {
    BaloonNode *baloon; // local variable
    baloon.damaged = NO;

    NSArray *textures;
    if (type == baloonTypeA) {
        baloon = [self spriteNodeWithImageNamed:@"baloon_a_1"];
        textures = @[[SKTexture textureWithImageNamed:@"baloon_a_1"],
                     [SKTexture textureWithImageNamed:@"baloon_a_2"]];
        baloon.type = baloonTypeA;
    } else {
        baloon = [self spriteNodeWithImageNamed:@"baloon_b_1"];
        textures = @[[SKTexture textureWithImageNamed:@"baloon_b_1"],
                     [SKTexture textureWithImageNamed:@"baloon_b_2"],
                     [SKTexture textureWithImageNamed:@"baloon_b_3"]];
        baloon.type = baloonTypeB;
    }
    // random the size
    float scale = [Util randomWithMin:85 max:100] / 100.0f;
    baloon.xScale = scale;
    baloon.yScale = scale;
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [baloon runAction:[SKAction repeatActionForever:animation]];
    
    [baloon setupPhysicsBody];
    
    return baloon;
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO; // no freefall
    self.physicsBody.categoryBitMask = collisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0; // doest not collide with anything
    self.physicsBody.contactTestBitMask = collisionCategoryProjectile | collisionCategoryGround; // projectile or ground   == 0010 | 1000 = 1010
}

- (BOOL) isDamaged {
    NSArray *textures;
    
    if (!_damaged) { // the node instance is not damaged, then make it damanged
        [self removeActionForKey:@"animation"]; // remove the texture change animation
        if (self.type == baloonTypeA) {
            textures = @[[SKTexture textureWithImageNamed:@"baloon_a_3"]];
        } else {
            textures = @[[SKTexture textureWithImageNamed:@"baloon_b_4"]];
        }
        
        SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
        [self runAction:[SKAction repeatActionForever:animation] withKey:@"damange_animation"];
        
        _damaged = YES;
        return NO;
    }
    return _damaged;
}

@end
