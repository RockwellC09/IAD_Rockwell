//
//  IntroScene.h
//  Brick Break
//
//  Created by Christopher Rockwell on 8/12/14.
//  Copyright Christopher Rockwell 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Importing cocos2d.h and cocos2d-ui.h, will import anything you need to start using cocos2d-v3
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import <GameKit/GameKit.h>

// -----------------------------------------------------------------------

/**
 *  The intro scene
 *  Note, that scenes should now be based on CCScene, and not CCLayer, as previous versions
 *  Main usage for CCLayer now, is to make colored backgrounds (rectangles)
 *
 */
@interface IntroScene : CCScene <GKGameCenterControllerDelegate, GKLocalPlayerListener>

// -----------------------------------------------------------------------

+ (IntroScene *)scene;
- (id)init;

// It's used to authenticate a player, and display the login view controller if not authenticated.
-(void)authenticateLocalPlayer;

// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;

// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;

// -----------------------------------------------------------------------
@end