//
//  LevelManager.m
//  Cocos2DSimpleGame
//
//  Created by Paige Garratt on 5/28/13.
//  Copyright (c) 2013 Paige Garratt. All rights reserved.
//

#import "LevelManager.h"

@implementation LevelManager {
    NSArray * _levels;
    int _curLevelIdx;
}

+ (LevelManager *)sharedInstance {
    static dispatch_once_t once;
    static LevelManager * sharedInstance; dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        _curLevelIdx = 0;
        Level * level1 = [[[Level alloc] initWithLevelNum:1 secsPerSpawn:2
                                                  bColor1:255 bColor2:255 bColor3:255 bColor4:255] autorelease];
        Level * level2 = [[[Level alloc] initWithLevelNum:2 secsPerSpawn:1
                                                  bColor1:100 bColor2:150 bColor3:20 bColor4:255] autorelease];
        _levels = [@[level1, level2] retain];
    }
    return self;
}

- (Level *)curLevel {
    if (_curLevelIdx >= _levels.count) {
        return nil;
    }
    return _levels[_curLevelIdx];
}

- (void)nextLevel {
    _curLevelIdx++;
}

- (void)reset {
    _curLevelIdx = 0;
}

- (void)dealloc {
    [_levels release];
    _levels = nil;
    [super dealloc];
}

@end