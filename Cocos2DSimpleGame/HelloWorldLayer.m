//
//  HelloWorldLayer.m
//  Cocos2DSimpleGame
//
//  Created by Paige Garratt on 5/28/13.
//  Copyright Paige Garratt 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

//To play sound effects
#import "SimpleAudioEngine.h"

//To get information about Monsters
#import "Monster.h"

//To implement Levels
#import "LevelManager.h"

#pragma mark - HelloWorldLayer

#define playerObject @"player.png"
#define projectileObject @"projectile.png"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
    if ((self = [super init])) {
        glClearColor([LevelManager sharedInstance].curLevel.b1, [LevelManager sharedInstance].curLevel.b2,
                     [LevelManager sharedInstance].curLevel.b3, [LevelManager sharedInstance].curLevel.b4);
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _player = [CCSprite spriteWithFile:playerObject];
        _player.position = ccp(_player.contentSize.width/2, winSize.height/2);
        [self addChild:_player];
    }
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];

    _monsters = [[NSMutableArray alloc] init];
    _projectiles = [[NSMutableArray alloc] init];
    
    [self schedule:@selector(gameLogic:) interval:[LevelManager sharedInstance].curLevel.secsPerSpawn];
    self.touchEnabled = YES;
    
    [self schedule:@selector(update:)];
    
    return self;
}

- (void) addMonster {
    
    //CCSprite * monster = [CCSprite spriteWithFile:@"monster.png"];
    
    Monster * monster = nil;
    if (arc4random() % 2 == 0) {
        monster = [[[WeakAndFastMonster alloc] init] autorelease];
    } else {
        monster = [[[StrongAndSlowMonster alloc] init] autorelease];
    }
    
    monster.tag = 1;
    [_monsters addObject:monster];
    
    // Determine where to spawn the monster along the Y axis
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = monster.minMoveDuration; // was 2.0
    int maxDuration = monster.maxMoveDuration; //was 4.0
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:actualDuration
                                                position:ccp(-monster.contentSize.width/2, actualY)];
    CCCallBlockN * actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [_monsters removeObject:node];
        [node removeFromParentAndCleanup:YES];
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }];
    [monster runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    [_monsters release];
    _monsters = nil;
    [_projectiles release];
    _projectiles = nil;
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void)gameLogic:(ccTime)dt {
    [self addMonster];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_nextProjectile != nil) return;
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _nextProjectile = [[CCSprite spriteWithFile:projectileObject] retain];
    _nextProjectile.position = ccp(20, winSize.height/2);
    
    //_nextProjectile.tag = 2;
    //[_projectiles addObject:_nextProjectile];
    
    // Determine offset of location to projectile
    CGPoint offset = ccpSub(location, _nextProjectile.position);
    
    // Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    // Ok to add now - we've double checked position
    //[self addChild:projectile];
    
    int realX = winSize.width + (_nextProjectile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + _nextProjectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far you're shooting
    int offRealX = realX - _nextProjectile.position.x;
    int offRealY = realY - _nextProjectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    // Determine angle to face
    float angleRadians = atanf((float)offRealY / (float)offRealX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * angleDegrees;
    float rotateDegreesPerSecond = 180 / 0.5; // Would take 0.5 seconds to rotate 180 degrees, or half a circle
    float degreesDiff = _player.rotation - cocosAngle;
    float rotateDuration = fabs(degreesDiff / rotateDegreesPerSecond);
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    
    
    [_player runAction:
     [CCSequence actions:
      [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
      [CCCallBlock actionWithBlock:^{
         // OK to add now - rotation is finished!
         [self addChild:_nextProjectile];
         [_projectiles addObject:_nextProjectile];
         
         // Release
         [_nextProjectile release];
         _nextProjectile = nil;
     }],
      nil]];
    
    // Move projectile to actual endpoint
    [_nextProjectile runAction:
     [CCSequence actions:
      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [_projectiles removeObject:node];
         [node removeFromParentAndCleanup:YES];
     }],
      nil]];
    
    _nextProjectile.tag = 2;
    
}

- (void)update:(ccTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        BOOL monsterHit = FALSE;
        NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
        for (Monster *monster in _monsters) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {
                monsterHit = TRUE;
                monster.hp --;
                if (monster.hp <= 0) {
                    [monstersToDelete addObject:monster];
                }
                break;
            }
        }
        for (CCSprite *monster in monstersToDelete) {
            [_monsters removeObject:monster];
            [self removeChild:monster cleanup:YES];
            _monstersDestroyed++;
            if (_monstersDestroyed > 30) {
                CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
                [[CCDirector sharedDirector] replaceScene:gameOverScene];
            }
        }
        
        if (monsterHit) {
            [projectilesToDelete addObject:projectile];
            [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.caf"];
        }
        [monstersToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
}

@end
