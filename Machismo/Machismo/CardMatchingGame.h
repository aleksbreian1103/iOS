//
//  CardMatchingGame.h
//  Machismo
//
//  Created by John Ramsey, Jr on 1/30/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id) initWithCardCount:(NSUInteger)cardCount
               usingDeck:(Deck *)deck;

- (void) flipCardAtIndex:(NSUInteger)index;

- (Card *) cardAtIndex:(NSUInteger)index;

@property (nonatomic, strong) NSString *moveDescription;
@property (nonatomic) int requiredMatches;
@property (nonatomic, readonly) int score;
@property (strong, nonatomic) NSMutableArray *cards;

@end
