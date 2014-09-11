//
//  CreditsScene.m
//  BrickBreak
//
//  Created by Christopher Rockwell on 8/28/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "CreditsScene.h"
#import "IntroScene.h"

@implementation CreditsScene

+ (CreditsScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Brick Break label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Brick Break Credits" fontName:@"American Typewriter" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.8f);
    [self addChild:label];
    
    // credits back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ back ]" fontName:@"Verdana-Bold" fontSize:16.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.10f, 0.9f);
    [backButton setTarget:self selector:@selector(back:)];
    [self addChild:backButton];
    
    // credits label
    CCLabelTTF *creditsLabel = [CCLabelTTF labelWithString:@"UI/UX                   Christopher Rockwell \n\nProgramming    Christopher Rockwell \n\nSound Effects     https://www.freesound.org" fontName:@"American Typewriter" fontSize:20.0f];
    creditsLabel.positionType = CCPositionTypeNormalized;
    creditsLabel.color = [CCColor whiteColor];
    creditsLabel.position = ccp(0.5f, 0.4f);
    [self addChild:creditsLabel];
    
    return self;
}

// back button method to go back to the main menu
- (void)back:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]];
}

@end
