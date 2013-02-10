//
//  CardMatchingGame.m
//  Machismo
//
//  Created by John Ramsey, Jr on 1/30/13.
//  Copyright (c) 2013 RamFam. All rights reserved.
//

#import "CardMatchingGame.h"

#import "PlayingCardDeck.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) int score;
@end

@implementation CardMatchingGame


- (NSMutableArray *) cards
{
    if ( !_cards ) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i=0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        self.requiredMatches = 2;
    }
    
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

- (void) flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (card.isUnplayable) return;
    
    card.faceUp = !card.isFaceUp;
    
    if (card.isFaceUp)
    {
        NSMutableArray *faceUpCards = [[NSMutableArray alloc] init];
        
        for (Card *otherCard in self.cards) {
            if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                [faceUpCards addObject: otherCard];
            }
        }
        
        if ( [faceUpCards count] < self.requiredMatches)
        {
            self.score -= FLIP_COST;
            self.moveDescription = [NSString stringWithFormat:@"You flipped %@", card.contents];
        }
        else if ([faceUpCards count] == self.requiredMatches)
        {
            int matchscore = [card match:faceUpCards];
            
            if (matchscore == 0) {
                for (Card *c in faceUpCards) {
                    c.faceUp = NO;
                }
                card.faceUp = YES;
                self.score -= MISMATCH_PENALTY;
                NSString *mismatches = [faceUpCards componentsJoinedByString:@"&"];
                self.moveDescription = [NSString stringWithFormat:@"%@ don't match! %d point penalty", mismatches, MISMATCH_PENALTY];
            }
            else {
                self.score += matchscore * MATCH_BONUS;
                for (Card *c in faceUpCards) {
                    c.unplayable = YES;
                    card.unplayable = YES;
                }
                
                NSString *matches = [faceUpCards componentsJoinedByString:@"&"];
                self.moveDescription = [NSString stringWithFormat:@"Matched %@ for %d points!", matches,
                                        matchscore * MATCH_BONUS];
            }
        }
        
        faceUpCards = nil;
    }
}

@end
