//
//  MenuLayer.m
//  Cocos2DSimpleGame
//
//  Created by Paige Garratt on 5/29/13.
//  Copyright 2013 Paige Garratt. All rights reserved.
//

#import "MenuLayer.h"
#import "HelloWorldLayer.h"


@implementation MenuLayer

+(CCScene*) scene{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite* background = [[CCSprite alloc] initWithFile:@"monstersBackground.png"];
        background.position = ccp(winSize.width/2.0, winSize.height/2.0);
        [self addChild:background];
        
        [CCMenuItemFont setFontName:@"Arial"];
        [CCMenuItemFont setFontSize:36];
        CCMenuItem* title = [CCMenuItemFont itemWithString:@"Welcome to"];
        [title setColor:ccc3(0, 0, 0)];
        CCMenuItem* titleCont = [CCMenuItemFont itemWithString:@"Pew-Pew Ninjas"];
        [titleCont setColor:ccc3(0, 0, 0)];
        CCMenuItem* play = [CCMenuItemFont itemWithString:@"PLAY" target:self selector:@selector(goToGame:)];
        [play setColor:ccc3(255, 0, 0)];
        
        CCMenu *menu = [CCMenu menuWithItems:title, titleCont, play, nil];
        menu.position = ccp(240, 160);
        [menu alignItemsVerticallyWithPadding:15];
        [self addChild:menu];
    }
    return self;
}

-(void) goToGame:(id) sender{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[HelloWorldLayer node]]];
}

@end
