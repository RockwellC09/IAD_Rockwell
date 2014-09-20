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
#import "HighScoreScene.h"

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
    
    _leaderboardIdentifier = @"highscores";
    _gameCenterEnabled = NO;
    [self authenticateLocalPlayer];
    
    // Brick Break label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Brick Break" fontName:@"American Typewriter" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.8f);
    [self addChild:label];
    
    // play button
    CCButton *playButton = [CCButton buttonWithTitle:@"[ Play ]" fontName:@"Verdana-Bold" fontSize:20.0f];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.5f, 0.65f);
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
    
    // how to scene button
    CCButton *highScores = [CCButton buttonWithTitle:@"[ High Scores ]" fontName:@"Verdana-Bold" fontSize:16.0f];
    highScores.positionType = CCPositionTypeNormalized;
    highScores.position = ccp(0.5f, 0.50f);
    [highScores setTarget:self selector:@selector(highScores:)];
    [self addChild:highScores];
    
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

-(void)authenticateLocalPlayer{
    // Instantiate a GKLocalPlayer object to use for authenticating a player.
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            // If it's needed display the login view controller.
            [[[CCDirector sharedDirector] navigationController] presentViewController:viewController animated:true completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                // If the player is already authenticated then indicate that the Game Center features can be used.
                _gameCenterEnabled = YES;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:[NSString stringWithFormat:@"YES"] forKey:@"gc"];
                [defaults synchronize];
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:[NSString stringWithFormat:@"NO"] forKey:@"gc"];
                [defaults synchronize];
            }
        }
    };
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
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

// send to proper highscore scene based on game center availablity
- (void)highScores:(id)sender {
    
    if (_gameCenterEnabled) {
        // Init the following view controller object.
        GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
        
        // Set self as its delegate.
        gcViewController.gameCenterDelegate = self;
        
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        //gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
        
        // Finally present the view controller.
        [[[CCDirector sharedDirector] navigationController] presentViewController:gcViewController animated:true completion:nil];
    } else {
        [[CCDirector sharedDirector] replaceScene:[HighScoreScene scene]];
    }
}

// -----------------------------------------------------------------------
@end
