//
//  HighScoreScene.m
//  BrickBreak
//
//  Created by Christopher Rockwell on 9/17/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "HighScoreScene.h"
#import "IntroScene.h"

@implementation HighScoreScene
int height;
int width;
NSArray *bestArray;
NSMutableArray *localScores;
CCLabelTTF *nameLabel;

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (HighScoreScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // get screen size
    CGSize s = [[CCDirector sharedDirector] viewSize];
    width = s.width;
    height = s.height;
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Brick Break label
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"High Scores" fontName:@"American Typewriter" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor whiteColor];
    label.position = ccp(0.5f, 0.8f);
    [self addChild:label];
    
    // back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ back ]" fontName:@"Verdana-Bold" fontSize:16.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.10f, 0.9f);
    [backButton setTarget:self selector:@selector(back:)];
    [self addChild:backButton];
    
    // alphabetically filter button
    CCButton *alpahbetBtn = [CCButton buttonWithTitle:@"[ Filter: Alphabetically ]" fontName:@"Verdana-Bold" fontSize:12.0f];
    alpahbetBtn.positionType = CCPositionTypeNormalized;
    alpahbetBtn.position = ccp(0.2f, 0.7f);
    [alpahbetBtn setTarget:self selector:@selector(alphaFilter:)];
    [self addChild:alpahbetBtn];
    
    // best score filter button
    CCButton *bestButton = [CCButton buttonWithTitle:@"[ Filter: Best Score ]" fontName:@"Verdana-Bold" fontSize:12.0f];
    bestButton.positionType = CCPositionTypeNormalized;
    bestButton.position = ccp(0.8f, 0.7f);
    [bestButton setTarget:self selector:@selector(bestFilter:)];
    [self addChild:bestButton];
    
    // retrieve high score and games played
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // check for local highs scores
    if (![defaults objectForKey:@"hsArray"]) {
        // do nothing
    } else {
        localScores = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"hsArray"]];
        bestArray = [[NSArray alloc] initWithArray:localScores];
        NSMutableString *scoreStr = [[NSMutableString alloc] init];
        for (int i = 0; i < localScores.count; i++) {
            [scoreStr appendString:[NSString stringWithFormat:@"%@\n", [localScores objectAtIndex:i]]];
            if (i == localScores.count - 1) {
                nameLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", scoreStr] fontName:@"American Typewriter" fontSize:20.0f];
                nameLabel.color = [CCColor whiteColor];
                nameLabel.position = ccp(width/2, 150.0f);
                [self addChild:nameLabel];
            }
        }
    }
    
    
    return self;
}

// back button method to go back to the main menu
- (void)back:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]];
}

- (void)alphaFilter:(id)sender {
    [nameLabel removeFromParent];
    NSArray *alphabetArray = [localScores sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableString *scoreStr = [[NSMutableString alloc] init];
    for (int i = 0; i < alphabetArray.count; i++) {
        [scoreStr appendString:[NSString stringWithFormat:@"%@\n", [alphabetArray objectAtIndex:i]]];
        if (i == localScores.count - 1) {
            nameLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", scoreStr] fontName:@"American Typewriter" fontSize:20.0f];
            nameLabel.color = [CCColor whiteColor];
            nameLabel.position = ccp(width/2, 150.0f);
            [self addChild:nameLabel];
        }
    }
}

- (void)bestFilter:(id)sender {
    [nameLabel removeFromParent];
    NSMutableString *scoreStr = [[NSMutableString alloc] init];
    for (int i = 0; i < bestArray.count; i++) {
        [scoreStr appendString:[NSString stringWithFormat:@"%@\n", [bestArray objectAtIndex:i]]];
        if (i == localScores.count - 1) {
            nameLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", scoreStr] fontName:@"American Typewriter" fontSize:20.0f];
            nameLabel.color = [CCColor whiteColor];
            nameLabel.position = ccp(width/2, 150.0f);
            [self addChild:nameLabel];
        }
    }
}

@end
