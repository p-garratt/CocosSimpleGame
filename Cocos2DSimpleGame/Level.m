//
//  Level.m
//  Cocos2DSimpleGame
//
//  Created by Paige Garratt on 5/28/13.
//  Copyright (c) 2013 Paige Garratt. All rights reserved.
//

#import "Level.h"

@implementation Level

- (id)initWithLevelNum:(int)levelNum secsPerSpawn:(float)secsPerSpawn
                        bColor1:(int)b1 bColor2:(int) b2 bColor3:(int) b3  bColor4: (int) b4{
    if ((self = [super init])) {
        self.levelNum = levelNum;
        self.secsPerSpawn = secsPerSpawn;
        self.b1 = b1;
        self.b2 = b2;
        self.b3 = b3;
        self.b4 = b4;
    }
    return self;
}

@end