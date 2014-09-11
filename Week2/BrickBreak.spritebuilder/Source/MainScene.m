//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "IntroScene.h"
#import "cocos2d.h"
#import "CCSpriteFrame.h"
#import "CCSpriteFrameCache.h"
#import "CCAnimation.h"

@implementation MainScene

CCSprite *_player;
CCSprite *_cannonBase;
CCSprite *_brick;
CCSprite *_brick2;
CCSprite *_ball;
CCSprite *_brickDestroyed;
CCPhysicsNode *_physicsWorld;
int height;
int width;
bool collided;
CCSprite *_bound1;
CCSprite *_bound2;
CCSprite *_ground;
bool first;
CCSprite *_destroy;
bool moveBack;
CCLabelTTF *scoreLabel;
CCLabelTTF *highScoreLabel;
CCLabelTTF *missLabel;
int score;
int misses;
CCButton *pauseBtn;
bool isPaused;
CCLabelTTF *pauseLabel;
CCLabelTTF *gameOver;
CCSprite *heart1;
CCSprite *heart2;
CCSprite *heart3;
CCSprite *heart4;
CCSprite *heart5;
CCLabelTTF *playAgain;
CCButton *noButton;
CCButton *yesButton;
int highScore;
bool gameIsOver;
float posVal;
int streak;
float multiplier;
CCLabelTTF *streakLabel;
CCLabelTTF *multiplierLabel;
int gamesPlayed;

+ (MainScene *)scene
{
	return [[self alloc] init];
}

- (id)init
{
    collided = true;
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    score = 0;
    misses = 0;
    first = true;
    gameIsOver = false;
    posVal = 250.0f;
    streak = 0;
    multiplier = 1.0f;
    
    // get screen size
    CGSize s = [[CCDirector sharedDirector] viewSize];
    width = s.width;
    height = s.height;
    
    // create a colored background (Dark Grey)
    CCPhysicsNode *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    _physicsWorld = [CCPhysicsNode node];
    _physicsWorld.gravity = ccp(0,0);
    _physicsWorld.debugDraw = NO;
    _physicsWorld.collisionDelegate = self;
    [self addChild:background];
    [background addChild:_physicsWorld];
    
    // add score label
    scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", score] fontName:@"American Typewriter" fontSize:20.0f];
    scoreLabel.color = [CCColor whiteColor];
    scoreLabel.position = ccp(130.0f, 20.0f);
    [scoreLabel setHorizontalAlignment:CCTextAlignmentLeft];
    [scoreLabel setDimensions:CGSizeMake(225,25)];
    [_physicsWorld addChild:scoreLabel];
    
    // add hearts for lives
    [self addHearts];
    
    // retrieve high score and games played
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    highScore = [[defaults valueForKey:@"HighScore"] intValue];
    gamesPlayed = [[defaults valueForKey:@"games"] intValue];
    
    // add player sprites and check for gold cannon
    if (gamesPlayed >= 20) {
        _player = [CCSprite spriteWithImageNamed:@"gold_cannon_barrel.png"];
    } else {
        _player = [CCSprite spriteWithImageNamed:@"cannon_barrel.png"];
    }
    _player.position  = ccp(width/2,50);
    _player.rotation = -90.0f;
    _player.scale = 0.6f;
    [_physicsWorld addChild:_player];
    [self rotateRight];
    
    // create a dummy brick to get the location to launch the ball(s)
    _brick2 = [CCSprite spriteWithImageNamed:@"brick.png"];
    _brick2.position  = ccp(width / 2, -20);
    [_physicsWorld addChild:_brick2];
    [self moveRight];
    
    // add cannon base and check for gold cannon base
    if (gamesPlayed >= 20) {
        _cannonBase = [CCSprite spriteWithImageNamed:@"gold_cannon_base.png"];
    } else {
        _cannonBase = [CCSprite spriteWithImageNamed:@"cannon_base.png"];
    }
    _cannonBase.position = ccp(width/2 + 7,20);
    _cannonBase.scale = 0.6;
    [_physicsWorld addChild:_cannonBase];
    
    // add brick
    _brick = [CCSprite spriteWithImageNamed:@"brick.png"];
    _brick.position  = ccp(35, height - 20);
    _brick.scale = 0.7f;
    _brick.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _brick.contentSize} cornerRadius:0];
    _brick.physicsBody.collisionGroup = @"brickGroup";
    _brick.physicsBody.collisionType  = @"brickCollision";
    [_physicsWorld addChild:_brick];
    
    // trigger the tick method to move the brick
    [self schedule: @selector(tick:) interval: 1.0f/90.0f];
    
    // add ground
    _ground = [CCSprite spriteWithImageNamed:@"ground.png"];
    _ground.position  = ccp(width/2, height);
    _ground.scale = .5f;
    _ground.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ground.contentSize} cornerRadius:0];
    _ground.physicsBody.collisionGroup = @"groundGroup";
    _ground.physicsBody.collisionType  = @"groundCollision";
    _ground.physicsBody.type = CCPhysicsBodyTypeStatic;
    [_physicsWorld addChild:_ground];
    
    // pause button
    CCSpriteFrame *spriteFrame = [CCSpriteFrame frameWithImageNamed:@"pause.png"];
    pauseBtn = [CCButton buttonWithTitle:@"" spriteFrame:spriteFrame];
    pauseBtn.position = ccp(width - 40.0f, height/2);
    pauseBtn.scale = 0.4f;
    [pauseBtn setTarget:self selector:@selector(pause)];
    [_physicsWorld addChild:pauseBtn];
    
    // add high score label
    highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score: %i", highScore] fontName:@"American Typewriter" fontSize:20.0f];
    highScoreLabel.color = [CCColor whiteColor];
    highScoreLabel.position = ccp(130.0f, 40.0f);
    [highScoreLabel setHorizontalAlignment:CCTextAlignmentLeft];
    [highScoreLabel setDimensions:CGSizeMake(225,25)];
    [_physicsWorld addChild:highScoreLabel];
    
    // add streak score label
    streakLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Streak: %i", streak] fontName:@"American Typewriter" fontSize:20.0f];
    streakLabel.color = [CCColor whiteColor];
    streakLabel.position = ccp(130.0f, 60.0f);
    [streakLabel setHorizontalAlignment:CCTextAlignmentLeft];
    [streakLabel setDimensions:CGSizeMake(225,25)];
    [_physicsWorld addChild:streakLabel];
    
    // add multiplier score label
    multiplierLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Multiplier: %.01f", multiplier] fontName:@"American Typewriter" fontSize:20.0f];
    multiplierLabel.color = [CCColor whiteColor];
    multiplierLabel.position = ccp(130.0f, 80.0f);
    [multiplierLabel setHorizontalAlignment:CCTextAlignmentLeft];
    [multiplierLabel setDimensions:CGSizeMake(225,25)];
    [_physicsWorld addChild:multiplierLabel];
    
    // preload sound effects
    [[OALSimpleAudio sharedInstance] preloadEffect:@"cannon.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"ground.wav"];
    [[OALSimpleAudio sharedInstance] preloadEffect:@"break.wav"];
    
    // done
	return self;
}

// pause and resume game
-(void)pause {
    // quit button
    CCButton *quitButton = [CCButton buttonWithTitle:@"[ Quit ]" fontName:@"Verdana-Bold" fontSize:16.0f];
    quitButton.position = ccp(width/2, height/2-35.0f);
    [quitButton setTarget:self selector:@selector(quit:)];
    
    if (isPaused) {
        [[CCDirector sharedDirector] resume];
        isPaused = false;
        [pauseLabel removeFromParent];
        [quitButton removeFromParent];
    } else {
        [[CCDirector sharedDirector] pause];
        // add pause label
        pauseLabel = [CCLabelTTF labelWithString:@"Paused" fontName:@"American Typewriter" fontSize:24.0f];
        pauseLabel.color = [CCColor whiteColor];
        pauseLabel.position = ccp(width/2, height/2);
        [_physicsWorld addChild:pauseLabel];
        [_physicsWorld addChild:quitButton];
        isPaused = true;
    }
}

- (void)quit:(id)sender {
    isPaused = false;
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]];
    [[CCDirector sharedDirector] resume];
}

// linear interpolation
-(void)tick:(CCTime)deltaTime {
    if (_brick.position.x < 25) {
        moveBack = false;
    }
    if (_brick.position.x > width - 25) {
        _brick.position = ccp(_brick.position.x - posVal * deltaTime, _brick.position.y);
        moveBack = true;
    } else {
        if (moveBack) {
            _brick.position = ccp(_brick.position.x - posVal * deltaTime, _brick.position.y);
        } else {
            _brick.position = ccp(_brick.position.x + posVal * deltaTime, _brick.position.y);
        }
    }
    
    
}

// handle screen tap
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (collided && isPaused == false && gameIsOver == false) {
        // add ball sprite
        _ball = [CCSprite spriteWithImageNamed:@"ball.png"];
        _ball.scale = .5f;
        _ball.position  = ccp(width / 2, _player.position.y + 40);
        _ball.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _ball.contentSize} cornerRadius:0];
        _ball.physicsBody.collisionGroup = @"ballGroup";
        _ball.physicsBody.collisionType  = @"ballCollision";
        [_physicsWorld addChild:_ball];
        
        
        // animate canon shot graphic
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"shoot-0001-default.plist"];
        
        NSMutableArray *shootAnimFrames = [NSMutableArray array];
        for (int i=3; i>=1; i--) {
            [shootAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"shoot%d.png",i]]];
        }
        
        CCAnimation *shootAnim = [CCAnimation animationWithSpriteFrames:shootAnimFrames delay:0.075f];
        
        self.shoot = [CCSprite spriteWithSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"shoot3.png"]];
        self.shoot.scale = 0.1f;
        int postion = _brick2.position.x;
        if (postion > width / 2 + 20) {
            self.shoot.position  = ccp(width / 2 + 22, _player.position.y + 30);
        } else if (postion > width / 2 + 20) {
            self.shoot.position  = ccp(width / 2 - 22, _player.position.y + 30);
        } else {
            self.shoot.position  = ccp(width / 2, _player.position.y + 30);
        }
        self.shootAction = [CCActionRepeat actionWithAction:[CCActionAnimate actionWithAnimation:shootAnim] times:1];
        [self.shoot runAction:self.shootAction];
        [_physicsWorld addChild:self.shoot];
        
        // access audio object
        OALSimpleAudio *audioObj = [OALSimpleAudio sharedInstance];
        // play sound
        [audioObj playEffect:@"cannon.wav"];
        
        // Move our sprite to proper location
        CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:ccp(_brick2.position.x, height)];
        [_ball runAction:actionMove];
        [_ball runAction:[CCActionRotateBy actionWithDuration:1.0f angle:360]];
        collided = false;
        [self performSelector:@selector(removeShoot) withObject:nil afterDelay:0.3];
    } else {
        // do nothing
    }
}

// ran when the ball collides with the brick
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair brickCollision:(CCNode *)brick ballCollision:(CCNode *)ball {
    collided = true;
    [self updateScore];
    [_ball removeFromParent];
    
    // access audio object
    OALSimpleAudio *audioObj = [OALSimpleAudio sharedInstance];
    // play sound
    [audioObj playEffect:@"break.wav"];
    
    // add brick destroyed graphic/sprite
    _brickDestroyed = [CCSprite spriteWithImageNamed:@"brick_destroy.png"];
    _brickDestroyed.position = ccp(_brick.position.x, _brick.position.y);
    _brickDestroyed.scale = 0.7f;
    [_physicsWorld addChild:_brickDestroyed];
    [_brick removeFromParent];
    [self performSelector:@selector(removeDestroyedBrick) withObject:nil afterDelay:0.3];
    
    // random brick position
    int randNum = arc4random() % (width / 2 + 200) + (width / 2 - 200);
    
    // add brick back
    _brick = [CCSprite spriteWithImageNamed:@"brick.png"];
    _brick.position  = ccp(randNum, height - 20);
    _brick.scale = 0.7f;
    _brick.physicsBody = [CCPhysicsBody bodyWithRect:(CGRect){CGPointZero, _brick.contentSize} cornerRadius:0];
    _brick.physicsBody.collisionGroup = @"brickGroup";
    _brick.physicsBody.collisionType  = @"brickCollision";
    [_physicsWorld addChild:_brick];
    return YES;
}

// ran when the ball collides with the ground
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ballCollision:(CCNode *)ball groundCollision:(CCNode *)ground {
    [self updateLives];
    collided = true;
    // access audio object
    OALSimpleAudio *audioObj = [OALSimpleAudio sharedInstance];
    // play sound
    [audioObj playEffect:@"ground.wav"];
    
    _destroy = [CCSprite spriteWithImageNamed:@"explosion.png"];
    _destroy.position = _ball.position;
    _destroy.scale = .2f;
    [_ball removeFromParent];
    [_physicsWorld addChild:_destroy];
    streak = 0;
    multiplier = 1.0f;
    [multiplierLabel setString:[NSString stringWithFormat:@"Multiplier: %.01f", multiplier]];
    [streakLabel setString:[NSString stringWithFormat:@"Streak: %i", streak]];
    [self performSelector:@selector(removeDestroy) withObject:nil afterDelay:0.3];
    return YES;
}

// remove explosion
- (void) removeDestroy {
    [_destroy removeFromParent];
}

// remove shoot graphic/sprite
- (void) removeShoot {
    [self.shoot removeFromParent];
}

// remove shoot graphic/sprite
- (void) removeDestroyedBrick {
    [_brickDestroyed removeFromParent];
}

// move the dummy brick to the left
-(void)moveLeft {
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:0.8f position:ccp(width/2 - 280,_brick2.position.y)];
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self moveRight];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[actionMove, actionAfterMove]];
    [_brick2 runAction:seq];
}

// move the dummy brick to the right
-(void)moveRight {
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:0.8f position:ccp(width/2 + 280, _brick2.position.y)];
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self moveLeft];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[actionMove, actionAfterMove]];
    [_brick2 runAction:seq];
}

// rotate the arrow to the right
-(void)rotateRight {
    CCActionRotateBy *rotatePlayer;
    if (first) {
        rotatePlayer = [CCActionRotateBy actionWithDuration:0.8f angle:45];
        first = false;
    } else {
        rotatePlayer = [CCActionRotateBy actionWithDuration:0.8f angle:90];
    }
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self rotateLeft];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[rotatePlayer, actionAfterMove]];
    [_player runAction:seq];
}

// rotate the arrow to the left
-(void)rotateLeft {
    CCActionRotateBy *rotatePlayer = [CCActionRotateBy actionWithDuration:0.8f angle:-90];
    CCActionCallBlock *actionAfterMove = [CCActionCallBlock actionWithBlock:^{
        [self rotateRight];
    }];
    CCActionSequence *seq = [CCActionSequence actionWithArray:@[rotatePlayer, actionAfterMove]];
    [_player runAction:seq];
}

// update player score
- (void)updateScore {
    score = score + multiplier;
    streak++;
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %i", score]];
    
    if (score > highScore) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSString stringWithFormat:@"%i", score] forKey:@"HighScore"];
        [defaults synchronize];
        [highScoreLabel setString:[NSString stringWithFormat:@"High Score: %i", score]];
    }
    
    // check streak and change mulitiplier if needed
    if (streak >= 5 && streak < 10) {
        multiplier = 2.0f;
    } else if (streak >= 10) {
        multiplier = 3.0f;
    } else {
        multiplier = 1.0f;
    }
    
    [multiplierLabel setString:[NSString stringWithFormat:@"Multiplier: %.01f", multiplier]];
    [streakLabel setString:[NSString stringWithFormat:@"Streak: %i", streak]];
    
    // increase brick speed based on the score
    if (score >= 10 && score < 25) {
        posVal = 350;
    } else if (score >= 25 && score < 50) {
        posVal = 400;
    } else if (score >= 50) {
        posVal = 450;
    } else {
        posVal = 250;
    }
}

// add hearts for lives
- (void) addHearts {
    heart1 = [CCSprite spriteWithImageNamed:@"heart.png"];
    heart1.position = ccp(width - 20.0f, 20.0f);
    heart1.scale = 0.6f;
    [_physicsWorld addChild:heart1];
    
    heart2 = [CCSprite spriteWithImageNamed:@"heart.png"];
    heart2.position = ccp(heart1.position.x - 33.0f, 20.0f);
    heart2.scale = 0.6f;
    [_physicsWorld addChild:heart2];
    
    heart3 = [CCSprite spriteWithImageNamed:@"heart.png"];
    heart3.position = ccp(heart2.position.x - 33.0f, 20.0f);
    heart3.scale = 0.6f;
    [_physicsWorld addChild:heart3];
    
    heart4 = [CCSprite spriteWithImageNamed:@"heart.png"];
    heart4.position = ccp(heart3.position.x - 33.0f, 20.0f);
    heart4.scale = 0.6f;
    [_physicsWorld addChild:heart4];
    
    heart5 = [CCSprite spriteWithImageNamed:@"heart.png"];
    heart5.position = ccp(heart4.position.x - 33.0f, 20.0f);
    heart5.scale = 0.6f;
    [_physicsWorld addChild:heart5];
}

// update player misses
- (void)updateLives {
    misses++;
    switch (misses) {
        case 1:
            [heart5 removeFromParent];
            break;
        case 2:
            [heart4 removeFromParent];
            break;
        case 3:
            [heart3 removeFromParent];
            break;
        case 4:
            [heart2 removeFromParent];
            break;
        case 5:
            [heart1 removeFromParent];
            // pause game and display Game Over message
            [[CCDirector sharedDirector] pause];
            gameOver = [CCLabelTTF labelWithString:@"Game Over" fontName:@"American Typewriter" fontSize:24.0f];
            gameOver.color = [CCColor whiteColor];
            gameOver.position = ccp(width/2, height/2 + 20);
            [_physicsWorld addChild:gameOver];
            gameIsOver = true;
            [self playAgain];
            break;
        default:
            break;
    }
}

// ask the user the play again
- (void)playAgain {
    // update games played
    gamesPlayed++;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSString stringWithFormat:@"%i", gamesPlayed] forKey:@"games"];
    
    playAgain = [CCLabelTTF labelWithString:@"Play Again?" fontName:@"American Typewriter" fontSize:18.0f];
    playAgain.color = [CCColor whiteColor];
    playAgain.position = ccp(width/2, height/2 - 10.0f);
    [_physicsWorld addChild:playAgain];
    
    yesButton = [CCButton buttonWithTitle:@"Yes" fontName:@"American Typewriter" fontSize:16.0f];
    yesButton.position = ccp(width/2 - 25.0f, height/2 - 40.0f);
    [yesButton setTarget:self selector:@selector(yesBtn:)];
    [_physicsWorld addChild:yesButton];
    
    noButton = [CCButton buttonWithTitle:@"No" fontName:@"American Typewriter" fontSize:16.0f];
    noButton.position = ccp(width/2 + 25.0f, height/2 - 40.0f);
    [noButton setTarget:self selector:@selector(noBtn:)];
    [_physicsWorld addChild:noButton];
}

// restart game
- (void)yesBtn:(id)sender {
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[MainScene scene]];
}

// go back to main menu
- (void)noBtn:(id)sender {
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

@end
