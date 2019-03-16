//
//  ProjectileNode.m
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//

#import "ProjectileNode.h"
#import "Util.h"

@implementation ProjectileNode

// convience constructor
+ (instancetype) projectileAtPosition:(CGPoint)position {
    ProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.position = position;
    projectile.name = @"Projectile";
    
    [projectile setupAnimation];  // causes the projectile to be animated (look like fire)
    [projectile setupPhysicsBody];
    
    return projectile;
}

- (void) setupAnimation {
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"projectile_1"],
                          [SKTexture textureWithImageNamed:@"projectile_2"],
                          [SKTexture textureWithImageNamed:@"projectile_3"]];
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *repeatAction = [SKAction repeatActionForever:animation];
    [self runAction:repeatAction];
}

- (void) moveTowardsPosition:(CGPoint)position {
    // passing the tap location     (self.position is the gun location)
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    
    float offscreenX;
    if (position.x <= self.position.x) { // if on the left side of the screen
        offscreenX = -10; // off the screen
    } else {
        offscreenX = self.parent.frame.size.width + 10;
    }
    // y = mx + b
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    
    CGPoint pointOffscreen = CGPointMake(offscreenX, offscreenY);
    
    // a2 + b2 = c2
    float distanceA = pointOffscreen.y - self.position.y;
    float distanceB = pointOffscreen.x - self.position.x;
    float distanceC = sqrtf(powf(distanceA,2) + powf(distanceB,2));
    
    // distance = speed * time
    // time = distance / speed;
    float time = distanceC / PROJECTILESPEED;
    float waitToFade = time * 0.75;
    float fadeTime = time - waitToFade;
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffscreen duration:time];
    [self runAction:moveProjectile];
    
    NSArray *sequence = @[[SKAction waitForDuration:waitToFade],
                          [SKAction fadeOutWithDuration:fadeTime],
                          [SKAction removeFromParent]];
                          
    
    [self runAction:[SKAction sequence:sequence]];
}


- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO; // no freefall
    self.physicsBody.categoryBitMask = collisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = collisionCategoryEnemy;
}



@end
