//
//  HelloWorldLayer.h
//  Cocos2DSimpleGame
//
//  Created by Paige Garratt on 5/28/13.
//  Copyright Paige Garratt 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "GameOverLayer.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    NSMutableArray * _monsters;
    NSMutableArray * _projectiles;
    int _monstersDestroyed;
    CCSprite* _player;
    CCSprite *_nextProjectile;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
