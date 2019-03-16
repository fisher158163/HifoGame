//
//  SpaceCatNode.m
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//

#import "HifaGameNode.h"

// class extension (private variables to the class)
@interface HifaGameNode () // empty parentheses to symbolize private varibles of the class

@property (nonatomic) SKAction *tapAction;

@end

@implementation HifaGameNode

// convience constructor
+ (instancetype) hifaGameAtPosition:(CGPoint)position {
    HifaGameNode *hifaGame = [self spriteNodeWithImageNamed:@"arm_1"]; // create instance of gun
    hifaGame.position = position;
    hifaGame.zPosition = 9;
    hifaGame.anchorPoint = CGPointMake(0.5,0);
    hifaGame.name = @"Arm"; // each node can have a unique name
    
    return hifaGame; // return the instance
}

// override getter of the property
- (SKAction *) tapAction {
    if( _tapAction != nil ) { // the private instance variable
        return _tapAction;
    }
    // if not already initalized, then initalize it
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"arm_2"],
                          [SKTexture textureWithImageNamed:@"arm_1"]];
    
    
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];
    return _tapAction;
}

- (void) performTap {
    [self runAction:self.tapAction]; // run the property
}

@end
