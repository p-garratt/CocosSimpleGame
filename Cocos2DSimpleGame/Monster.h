//
//  Monster.h
//  Cocos2DSimpleGame
//
//  Created by Paige Garratt on 5/28/13.
//  Copyright 2013 Paige Garratt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Monster : CCSprite

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;

- (id)initWithFile:(NSString *)file hp:(int)hp minMoveDuration:(int)minMoveDuration maxMoveDuration:(int)maxMoveDuration;

@end

@interface WeakAndFastMonster : Monster
@end

@interface StrongAndSlowMonster : Monster
@end

