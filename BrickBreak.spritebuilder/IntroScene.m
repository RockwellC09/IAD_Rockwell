//
//  IntroScene.m
//  Brick Break
//
//  Created by Christopher Rockwell on 8/12/14.
//  Copyright Christopher Rockwell 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "MainScene.h"
#import "CreditsScene.h"
#import "HowToScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene
int gamesPlayed;
CCLabelTTF *gamesGoldLabel;

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
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
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Brick Break" fontName:@"American Typewriter" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.8f);
    [self addChild:label];
    
    // play button
    CCButton *playButton = [CCButton buttonWithTitle:@"[ Play ]" fontName:@"Verdana-Bold" fontSize:20.0f];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.5f, 0.55f);
    [playButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:playButton];
    
    // credits scene button
    CCButton *credits = [CCButton buttonWithTitle:@"[ Credits ]" fontName:@"Verdana-Bold" fontSize:16.0f];
    credits.positionType = CCPositionTypeNormalized;
    credits.position = ccp(0.15f, 0.1f);
    [credits setTarget:self selector:@selector(credits:)];
    [self addChild:credits];
    
    // how to scene button
    CCButton *howTo = [CCButton buttonWithTitle:@"[ How To Play ]" fontName:@"Verdana-Bold" fontSize:16.0f];
    howTo.positionType = CCPositionTypeNormalized;
    howTo.position = ccp(0.8f, 0.1f);
    [howTo setTarget:self selector:@selector(howTo:)];
    [self addChild:howTo];
    
    // get games played
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"games"]) {
        [defaults setValue:[NSString stringWithFormat:@"0"] forKey:@"games"];
        [defaults synchronize];
    }
    gamesPlayed = [[defaults valueForKey:@"games"] intValue];
    
    // games label
    CCLabelTTF *gamesLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Games Played: %i", gamesPlayed] fontName:@"American Typewriter" fontSize:18.0f];
    gamesLabel.positionType = CCPositionTypeNormalized;
    gamesLabel.color = [CCColor whiteColor];
    gamesLabel.position = ccp(0.5f, 0.40);
    [self addChild:gamesLabel];
    
    // output gold cannon message
    if (gamesPlayed < 20) {
        gamesGoldLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Games Until Gold Cannon Unlocked: %i", 20 - gamesPlayed] fontName:@"American Typewriter" fontSize:18.0f];
    } else {
        gamesGoldLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Gold Cannon Unlocked!"] fontName:@"American Typewriter" fontSize:18.0f];
    }
    gamesGoldLabel.positionType = CCPositionTypeNormalized;
    gamesGoldLabel.color = [CCColor whiteColor];
    gamesGoldLabel.position = ccp(0.5f, 0.30);
    [self addChild:gamesGoldLabel];

    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender {
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// send to credits scene
- (void)credits:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CreditsScene scene]];
}

// send to how to scene
- (void)howTo:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[HowToScene scene]];
}

// -----------------------------------------------------------------------
@end
