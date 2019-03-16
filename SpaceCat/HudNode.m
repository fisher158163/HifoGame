//
//  HudNode.m
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//

#import "HudNode.h"
#import "Util.h"

@implementation HudNode

// create scene (convenience contructor)
+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame {
    HudNode *hud = [self node];
    hud.position = position;
    hud.zPosition = 10; // so it appears in front of the other nodes
    hud.name = @"HUD";
    
    // cat image
    SKSpriteNode *catHead = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_cat_1"];
    catHead.position = CGPointMake(30,-10);
    [hud addChild:catHead];
    hud.lives = MAXLIVES;
    
    // life bar
    SKSpriteNode *lastLifeBar;
    for (int i=0; i < hud.lives; i++) {
        SKSpriteNode *lifeBar = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_life_1"];
        lifeBar.name = [NSString stringWithFormat:@"Life%d",i+1];
        
        [hud addChild:lifeBar];
        
        if (lastLifeBar == nil) {
            lifeBar.position = CGPointMake(catHead.position.x+30, catHead.position.y);
        } else {
            lifeBar.position = CGPointMake(lastLifeBar.position.x+10, catHead.position.y);
        }
        
        lastLifeBar = lifeBar;
    }
    
    // score counter
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    scoreLabel.name = @"Score";
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 24;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(frame.size.width-20, -10);
    [hud addChild:scoreLabel];
    
    return hud;
}

// add points (called by playscene)
- (void) addPoints:(NSInteger)points {
    self.score += points;
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:@"Score"]; // grab the label
    scoreLabel.text = [NSString stringWithFormat:@"%li", (long)self.score];
    
}

// lose life (called by playscene)
- (BOOL) loseLife {
    if (self.lives > 0) {
        NSString *lifeNodeName = [NSString stringWithFormat:@"Life%li", (long)self.lives];
        SKNode *lifeToRemove = [self childNodeWithName:lifeNodeName];
        [lifeToRemove removeFromParent];
        self.lives--;
    }
    return self.lives == 0; // yes or no
}

@end
