//
//  Util.h
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//

#import <Foundation/Foundation.h>


// constants
static const int PROJECTILESPEED = 400;
static const int SPACEDOGMINSPEED = -150;
static const int SPACEDOGMAXSPEED = -50;
static const int MAXLIVES = 4;
static const int POINTSPERHIT = 64;

// different then enum (this is specifically for bitmap masks)
typedef NS_OPTIONS(uint32_t, collisionCategory) {
    collisionCategoryEnemy      = 1 << 0, // shift operator template (shifts the 1 bit left) 0001
    collisionCategoryProjectile = 1 << 1, // move bit 1 over 1  0010
    collisionCategoryDebris     = 1 << 2, // move bit 1 over 2  0100
    collisionCategoryGround     = 1 << 3, // move bit 1 over 3  1000
};


@interface Util : NSObject

// class method +
+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
