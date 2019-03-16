//
//  SpaceDogNode.h
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>

// create the parameter input for the convience constructor
typedef NS_ENUM(NSUInteger, baloonType) {
    baloonTypeA = 0,
    baloonTypeB = 1,
};

@interface BaloonNode : SKSpriteNode

@property (nonatomic, getter = isDamaged) BOOL damaged;
@property (nonatomic) baloonType type;

// convience class constructor
+ (instancetype) baloonOfType:(baloonType)type;

@end
