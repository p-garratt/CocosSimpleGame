//
//  LevelManager.h
//  Cocos2DSimpleGame
//
//  Created by Paige Garratt on 5/28/13.
//  Copyright (c) 2013 Paige Garratt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"

@interface LevelManager : NSObject

+ (LevelManager *)sharedInstance;
- (Level *)curLevel;
- (void)nextLevel;
- (void)reset;

@end
