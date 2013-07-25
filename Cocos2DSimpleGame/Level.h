//
//  Level.h
//  Cocos2DSimpleGame
//
//  Created by Paige Garratt on 5/28/13.
//  Copyright (c) 2013 Paige Garratt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Level : NSObject

@property (nonatomic, assign) int levelNum;
@property (nonatomic, assign) float secsPerSpawn;
@property (nonatomic, assign) int b1;
@property (nonatomic, assign) int b2;
@property (nonatomic, assign) int b3;
@property (nonatomic, assign) int b4;

- (id)initWithLevelNum:(int)levelNum secsPerSpawn:(float)secsPerSpawn
               bColor1:(int)b1 bColor2:(int) b2 bColor3:(int) b3  bColor4: (int) b4;

@end