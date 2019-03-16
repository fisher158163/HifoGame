//
//  GamePlayScene.m
//  HifoGame
//
//  Created by Muhammed Hanifi Alma on 12/03/16.
//  Copyright (c) 2016 Muhammed Hanifi Alma. All rights reserved.
//

#import "PlayScene.h"
#import "GunNode.h"
#import "HifaGameNode.h"
#import "ProjectileNode.h"
#import "BaloonNode.h"
#import "GroundNode.h"
#import "Util.h"
#import "HudNode.h"
#import "GameOverNode.h"
#import <AVFoundation/AVFoundation.h>

// private class instance variables
@interface PlayScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;
@property (nonatomic) AVAudioPlayer *backgoundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL restart;
@property (nonatomic) BOOL gameOverDisplay;

@end

@implementation PlayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.addEnemyTimeInterval = 1.5;
        self.totalGameTime = 0;
        self.minSpeed = SPACEDOGMINSPEED;
        self.gameOver = NO;
        self.restart = NO;
        self.gameOverDisplay = NO;

        
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        //creates an instance of gun (calls the the GunNode conviecnce constructor)
        GunNode *gun = [GunNode gunAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:gun];
        // create an instance of hifagame infront of the gun
        HifaGameNode *hifaGame = [HifaGameNode hifaGameAtPosition:CGPointMake(gun.position.x, gun.position.y-2)];
        [self addChild:hifaGame];
        
        [self addBaloon];
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8); // world gravity
        self.physicsWorld.contactDelegate = self; // impliment the delegate, the scene is the delegate for the contact delegate
        
        GroundNode *ground = [GroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        
        [self setupSounds];
        
        HudNode *hud = [HudNode hudAtPosition:CGPointMake(0, self.frame.size.height-20) inFrame:self.frame]; // top of screen
        [self addChild:hud];
        
    }
    return self;
}

- (void) setupSounds {
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
    
    NSURL *backgroundURL = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@".mp3"];  // file url within app package
    self.backgoundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundURL error:nil];
    self.backgoundMusic.numberOfLoops = -1; // infinite
    [self.backgoundMusic prepareToPlay]; // get ready
    
    NSURL *gameOverURL = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@".mp3"];  // file url within app package
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverURL error:nil];
    self.gameOverMusic.numberOfLoops = 1; // infinite
    [self.gameOverMusic prepareToPlay]; // get ready
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.gameOver) { // first run
        for (UITouch *touch in touches) { // handles multiple touches
            CGPoint position = [touch locationInNode:self]; // pass the x,y of scene
            [self shootProjectileTowardsPosition:position];
        }
    } else if (self.restart) { // restart mode
        // destory all the old nodes and scene
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        // run a new scene
        PlayScene *scene = [PlayScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

- (void) didMoveToView:(SKView *)view {
    [self.backgoundMusic play];
}

- (void) shootProjectileTowardsPosition:(CGPoint)position {
    HifaGameNode *hifaGame = (HifaGameNode *)[self childNodeWithName:@"HifaGame"]; // grab the right node
    [hifaGame performTap]; // run the function within that correct node
    
    GunNode *gun = (GunNode *)[self childNodeWithName:@"Gun"];
    
    // create projectile at the machine
    ProjectileNode *projectile = [ProjectileNode projectileAtPosition:CGPointMake(gun.position.x, gun.position.y+gun.frame.size.height-15)];
    // animate the projectile with the touch position
    [self addChild:projectile];
    [projectile moveTowardsPosition:position];
    
    [self runAction:self.laserSFX]; // play sound
}

- (void) addBaloon {
    NSUInteger randomBaloon = [Util randomWithMin:0 max:2]; // max is not inclusive (picks the image)
    
    BaloonNode *baloon = [BaloonNode baloonOfType:randomBaloon];
    // speed down
    float dy = [Util randomWithMin:SPACEDOGMINSPEED max:SPACEDOGMAXSPEED];
   baloon.physicsBody.velocity = CGVectorMake(0, dy);
    
    float y = self.frame.size.height + baloon.size.height; // above the frame
    float x = [Util randomWithMin:0 max:self.frame.size.width-baloon.size.width]; // 10 point margin
    baloon.anchorPoint = CGPointMake(0,0);
    baloon.position = CGPointMake(x,y);

    [self addChild:baloon];
    
}

// game loop. progresses the game by changing variables with time
- (void) update:(NSTimeInterval)currentTime {
    if (self.lastUpdateTimeInterval) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    
    if (self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver) { // cannot add a dog more than 1 second
        [self addBaloon];
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    if (self.totalGameTime > 40) { // 8mins
        self.addEnemyTimeInterval = 0.50;
        self.minSpeed = -160;
        
    } else if (self.totalGameTime > 30) { // 4mins
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    } else if (self.totalGameTime > 20) { // 2mins
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
    } else if (self.totalGameTime > 10) {  // 0.5mins
        self.addEnemyTimeInterval = 1.00;
        self.minSpeed = -100;
    }
    
    if (self.gameOver && !self.gameOverDisplay) {
        [self performGameOver];
    }
}

- (void) didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    // indistinguish between a = projectile or b = projectile
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // projectile hit
    if (firstBody.categoryBitMask == collisionCategoryEnemy &&
        secondBody.categoryBitMask == collisionCategoryProjectile) {
        
        HifaGameNode *baloon
    = (HifaGameNode *)firstBody.node;
        ProjectileNode *projectile = (ProjectileNode *)secondBody.node;
        
        [projectile removeFromParent];
//        if ([spaceDog isDamaged]) {
            [baloon removeFromParent];
            
            [self createDebrisAtPosition:contact.contactPoint];
            [self runAction:self.explodeSFX]; // play sound
            [self addPoints:POINTSPERHIT];
//        }
    // ground hit
    } else if (firstBody.categoryBitMask == collisionCategoryEnemy &&
               secondBody.categoryBitMask == collisionCategoryGround) {

        HifaGameNode *baloon = (HifaGameNode *)firstBody.node;
        [baloon removeFromParent];
        [self createDebrisAtPosition:contact.contactPoint];
        [self runAction:self.damageSFX]; // play sound
        
        [self loseLife];
    }
}

- (void) addPoints:(NSInteger)points {
    HudNode *hud = (HudNode *)[self childNodeWithName:@"HUD"];
    [hud addPoints:points];
}

- (void) loseLife {
    HudNode *hud = (HudNode *)[self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
}

- (void) performGameOver {
    GameOverNode *gameOver = [GameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self addChild:gameOver];
    self.restart = YES;
    self.gameOverDisplay = YES;
    [gameOver performAnimation];
    [self.backgoundMusic stop];
    [self.gameOverMusic play];
}

- (void) createDebrisAtPosition:(CGPoint)position {
    // random the number of images
    NSInteger numberOfPieces = [Util randomWithMin:5 max:25];
    
    // random the image
    for (int i=0; i < numberOfPieces; i++) {
        NSInteger randomPieces = [Util randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%li", (long)randomPieces];
        
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        debris.name = @"debris";
        [self addChild:debris];
        
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = collisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = collisionCategoryGround | collisionCategoryDebris;
        debris.physicsBody.velocity = CGVectorMake([Util randomWithMin:-150 max:150],
                                                   [Util randomWithMin:150 max:350]);
        
        // after 2 seconds, run the block to remove the debris
        [debris runAction:[SKAction waitForDuration:2.0] completion:^{[debris removeFromParent];}];
    }
    
    // emitter node for the sks file
    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    [self addChild:explosion];
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{[explosion removeFromParent];}];
}
@end
