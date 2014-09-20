//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import <GameKit/GameKit.h>

@interface MainScene : CCScene <CCPhysicsCollisionDelegate, UIAlertViewDelegate>

+ (MainScene *)scene;
@property (nonatomic, strong) CCSprite *shoot;
@property (nonatomic, strong) CCAction *shootAction;

// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;

// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;

// It updates the default leaderboard by reporting the player's score when a game ends.
-(void)reportScore;
@end
