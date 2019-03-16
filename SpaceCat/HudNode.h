//
//  HudNode.h
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HudNode : SKNode

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;

+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;
- (void) addPoints:(NSInteger)points;
- (BOOL) loseLife;
@end
